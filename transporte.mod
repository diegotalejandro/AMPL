#*****************************
#	 Modelo Ejemplo AMPL
#	Modelo de Transporte
#	Archivos: 	transporte.mod
#				transporte.dat
#*****************************

#Defimos los conjuntos (los elementos los asignamos aparte)
# clientes : clientes
# bodegas : bodegas

set clientes;
set bodegas;

/*Parametros
 P = num de bodegas a instalaar
   c_ij = costo de servir al cliente i desde j
   d_i	= demanda del cliente i
   M = numero >> 1
*/

param P;
param c {i in clientes, j in bodegas};
param d {i in clientes};
param M;

/*Variables
Se definen las variables y su naturaleza en al mismo tiempo
	x_ij = unidades llevadas al cliente i de la bodega j
	y_j = 1 si se abre la bodega j
*/

var x {i in clientes, j in bodegas} >= 0; 
var y {i in bodegas} binary;

/*Funcion Objetivo
 	Min sum(i, sum(j, c_ij*x_ij ))
*/

minimize Suma_Costos: 
	sum{i in clientes, j in bodegas} c[i,j]*x[i,j];
	
#Restricciones
#  Solo abro P bodegas
#  sum(j, y_j) = P

subject to  abrir_P_bodegas :
  	  sum{j in bodegas} y[j] == P;

/*Cumplo con la demanda de todos los clientes
	sum (j, x_ij ) = d_i	forall i
 */

subject to satisfacer_demanda {i in clientes} :
  	 	sum{j in bodegas} x[i,j] >= d[i];
  	
/*Solo atiendo a clientes desde bodegas abiertas
sum(i,  x_ij ) <= M*y_j 	forall j
*/
subject to 	Mgrande {i in clientes, j in bodegas}:
  	    x[i,j] <= M*y[j];
	