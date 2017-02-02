# planets
Repositorio para el ejercicio de data science. 

#Misión 1: The return of the Data Miner
La tabla unificada con la geolocalizacion de los planetas y las variables recogidas en los ficheros data-planets1.csv y data-planets2.csv puede descargarse [aqui](https://github.com/albamesp/planets/blob/master/planets.csv).

El campo id es establecido como "primary key" que unira las distintas tablas.
La limpieza de datos sera realizada en la siguiente tarea.

#Misión 2 : The Machine Learner Strikes back
Seccion realizada usando la versión de R 3.3.1.
El script puede ser descargado aqui**

1) El campo afinidad es asociado a cada uno de los planetas a partir del id

2) Llevo a cabo una inspeccion de las distintas variables para evitar multicolinealidad. Para ello calculo una matrix de correlaciones y elimino aquellas variables con una correlación superior a 0.75. Este paso elimina 48 de las 165 variables (excluyo aqui las variables id, name, x,y).

3) Elaboro un modelo para predecir la afinidad como una combinacion lineal de las variables restantes. Para ello utilizo un algoritmo que ordenará las variables segun su capacidad explicativa. Este analisis determina que no hay ninguna variable altamente explicativa (max 3% de la varianza) 
