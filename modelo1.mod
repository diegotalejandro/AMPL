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
param I_fab;#Litros almacendados en las bodegas fabrica
param I_may;#Litros almacendados en las bodegas mayoristas
param I_dist;#Litros almacendados en las bodegas distribuidora
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

/*Funcion Objetivo
 	Min sum(i, sum(j, c_ij*x_ij ))
*/

minimize Suma_Costos: 
	sum{d in dias} (C[d]*x[d]) + #Produccion
	sum{d in dias} (G_fab[d]*I_fab[d]+G_may[d]*I_may[d]+G_dist[d]*I_dist[d)) +#almacenaje
	sum{d in dias} (y[d]*w[d]) + sum{d in dias} (z[d]*v[d]);#envio
	
#Restricciones--------------------------------------------------------
#No superar capacidad de almacenaje
subject to no_superar_capacidad_fab {d in dias}:
	x[d]+I_fab[d]<=B_fab;
subject to no_superar_capacidad_may {d in dias}:
	x[d]+I_may[d]<=B_may;
subject to no_superar_capacidad_dist {d in dias}:
	x[d]+I_dist[d]<=B_dist;
#almacen dia 1 igual al dia 30 todos

subject to alamcenaje_inicial_fab:
	I_fab[1]==I_fab[30];
subject to alamcenaje_inicial_may:
	I_may[1]==I_may[30];
subject to alamcenaje_inicial_dist:
	I_dist[1]==I_dist[30];
#almacenaje inicial y final mayorista

subject to alamcenaje_inicial_may:
	I_may[1]+E-z[1]<=B_may;
subject to alamcenaje_final_may:
	I_may[30]>=E;
#capacidad de  produccion

subject to Cap_prod{d in dias}:
	x[d]<=P[d];
#max de envio
subject to max_envio_fab_may{d in dias}:
	y[d]<=B_may;