#*****************************
#	 Modelo Ejemplo AMPL
#	Modelo de Transporte
#	Archivos: 	transporte.mod
#				transporte.dat
#*****************************

#Defimos los conjuntos (los elementos los asignamos aparte)
# clientes : clientes
# bodegas : bodegas

set dias;#se usan dias desde 0 hasta 30

/*Parametros
 P = num de bodegas a instalaar
   c_ij = costo de servir al cliente i desde j
   d_i	= demanda del cliente i
   M = numero >> 1
*/

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


/*Variables
Se definen las variables y su naturaleza en al mismo tiempo
	x_ij = unidades llevadas al cliente i de la bodega j
	y_j = 1 si se abre la bodega j
*/

var x {d in dias} >= 0;#cuanto se produce por el dia d
var y {d in dias} >= 0;#cuanto se envia al mayorista el dia d
var z {d in dias} >= 0;#cuanto se envia al distribuidor el dia d
var I_fab {d in dias} >= 0;#Litros almacendados en las bodegas fabrica
var I_may {d in dias} >= 0;#Litros almacendados en las bodegas mayoristas
var I_dist {d in dias} >= 0;#Litros almacendados en las bodegas distribuidora
/*Funcion Objetivo
 	Min sum(i, sum(j, c_ij*x_ij ))
*/

minimize Suma_Costos: 
	sum{d in dias} C_d[d]*x[d] + sum{d in dias} (G_fab[d]*I_fab[d]+G_may[d]*I_may[d]+G_dist[d]*I_dist[d]) +sum{d in dias} (y[d]*w[d]) + sum{d in dias} (z[d]*v[d]);#envio
	
#Restricciones--------------------------------------------------------

#No superar capacidad de almacenaje-----------------------------------

subject to no_superar_capacidad_fab {d in dias}:
	/*x[d]+*/I_fab[d]<=B_fab;
subject to no_superar_capacidad_may {d in dias: d<=10}:
	/*y[d]+*/I_may[d]<=B_may;
subject to no_superar_capacidad_dist {d in dias: d<=10}:
	/*z[d]+*/I_dist[d]<=B_dist;

#almacen dia 1 igual al dia 30 todos-------------------------------------

subject to alamcenaje_inicial_fab:
	I_fab[1]==I_fab[10];
subject to alamcenaje_inicial_may:#cambio!!!!!!!!!!!!!-!!!
	I_may[1]==I_may[10];
subject to alamcenaje_inicial_dist:
	I_dist[1]==I_dist[10];

#almacenaje inicial y final mayorista--------------------------------------

subject to alamcenaje_inicial_may_cond:
	I_may[1]+E-z[1]<=B_may;
	subject to envio_planificado:
	I_fab[9]==I_fab[8]+x[8]-y[8]-E;

#almacenaje inicial todo

subject to almacenaje_inicial_dato_fab:
	I_fab[1]==2000;
subject to almacenaje_inicial_dato_may:
	I_may[1]==3000;
subject to almacenaje_inicial_dato_dist:
	I_dist[1]==500;

#capacidad de  produccion-----------------------------------------------

subject to Cap_prod{d in dias}:
	x[d]<=P[d];

#update inventario----------------------------------------------------------
subject to updateI_fab{d in dias: d<10 && d!=8}:
	I_fab[d+1]==I_fab[d]+x[d]-y[d];
	/*subject to updateI_may{d in dias: 1<=d <=2}:#cambio!!!!!!!!!!!!
	I_may[d+1]==I_may[d]-z[d];*/
subject to updateI_may2{d in dias: 1<d <10}:#cambio!!!!!!!!!!!!
	I_may[d+1]==I_may[d]+y[d-1]-z[d];
subject to updateI_dist{d in dias: d <10}:
	I_dist[d+1]==I_dist[d]+z[d]-demanda[d];#cumple la demanda
#demanda--------------------
subject to cumplir_demand{d in dias}:
	demanda[d]<=z[d]+I_dist[d];
subject to envio_max_y{d in dias:d>2 }:
	y[d-2]+I_may[d]<= B_may+z[d];
subject to envio_max_z{d in dias}:
	z[d]+I_dist[d]<=B_dist+demanda[d];
