set dias;

param P {d in dias};#capacidad de produccion por dia
param B_fab;#capacidad de almacenamiento
param B_may;#capacidad de mayorista
param B_dist;#capacidad de distribuidor
param demanda{d in dias};#demanda diaria comercio minorista
param E;#despacho inicial desde fabrica a mayorista
param C_d {d in dias};#costo por litro producido el dia d
param G_fab {d in dias};#costo por cada litro almacenado fabrica
param G_may {d in dias};#costo por cada litro almacenado mayorista
param G_dist {d in dias};#costo por cada litro almacenado distribuidor
param w {d in dias};#costo por litro de la fabrica al mayorista el dia d
param v {d in dias};#costo por litro de el mayorista al distribuidor el dia d

var x {d in dias} >= 0;#cuanto se produce por el dia d
var y {d in dias} >= 0;#cuanto se envia al mayorista el dia d
var z {d in dias} >= 0;#cuanto se envia al distribuidor el dia d
var I_fab {d in dias} >= 0;#Litros almacendados en las bodegas fabrica
var I_may {d in dias} >= 0;#Litros almacendados en las bodegas mayoristas
var I_dist {d in dias} >= 0;#Litros almacendados en las bodegas distribuidora

minimize Suma_Costos: 
	sum{d in dias} C_d[d]*x[d] + sum{d in dias} (G_fab[d]*I_fab[d]+G_may[d]*I_may[d]+G_dist[d]*I_dist[d]) +sum{d in dias} (y[d]*w[d]) + sum{d in dias} (z[d]*v[d]);#envio
	
#Restricciones:
#No superar capacidad de almacenaje-----------------------------------

subject to no_superar_capacidad_fab {d in dias}:
	I_fab[d]<=B_fab;
subject to no_superar_capacidad_may {d in dias}:
	I_may[d]<=B_may;
subject to no_superar_capacidad_dist {d in dias}:
	I_dist[d]<=B_dist;

#almacen dia 1 igual al dia 30 todos-------------------------------------

subject to alamcenaje_inicial_fab:
	I_fab[1]==I_fab[30];
subject to alamcenaje_inicial_may:#cambio!!!!!!!!!!!!!-!!!
	I_may[1]==I_may[30];
subject to alamcenaje_inicial_dist:
	I_dist[1]==I_dist[30];

#almacenaje inicial y final mayorista--------------------------------------

	subject to envio_planificado:
	y[30]=E;

#almacenaje inicial todo

subject to almacenaje_inicial_dato_fab:
	I_fab[1]=2000+x[1]-y[1];
subject to almacenaje_inicial_dato_may:
	I_may[1]==3000+E-z[1];

subject to almacenaje_inicial_dato_dist:
	I_dist[1]=500+z[1]-demanda[1];

#capacidad de  produccion-----------------------------------------------

subject to Cap_prod{d in dias}:
	x[d]<=P[d];

#update inventario----------------------------------------------------------
subject to updateI_fab{d in dias: 1<d}:
	I_fab[d]=I_fab[d-1]+x[d]-y[d];
#caso dia 2
	subject to updateI_may:
	I_may[2]==I_may[1]-z[2];
subject to updateI_may2{d in dias: 1<d <30}:
	I_may[d+1]=I_may[d]+y[d-1]-z[d+1];
subject to updateI_dist{d in dias: d <30}:
	I_dist[d+1]=I_dist[d]+z[d+1]-demanda[d+1];#cumple la demanda

