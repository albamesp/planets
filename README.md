# planets
Repositorio para el ejercicio de data science. 

#Misión 1: The return of the Data Miner
La tabla unificada con la geolocalizacion de los planetas y las variables recogidas en los ficheros data-planets1.csv y data-planets2.csv puede descargarse [aqui](https://github.com/albamesp/planets/blob/master/planets.csv).

El campo id es establecido como "primary key" que unira las distintas tablas.
La limpieza de datos sera realizada en la siguiente tarea.

#Misión 2 : The Machine Learner Strikes back

Para generar un modelo predictivo con datos espaciales mi idea es crear un modelo 



Sección realizada usando la versión de R 3.3.1.
El script puede ser descargado aqui** y realiza las siguientes tareas:

1) El campo afinidad es asociado a cada uno de los planetas a partir del id

2) Lleva a cabo una inspección de las distintas variables para evitar multicolinealidad. Para ello calcula una matrix de correlaciones y elimina aquellas variables con una correlación superior a 0.75. En este paso se eliminan 48 de las 165 variables (excluyo aqui las variables id, name, x,y).

3) Elabora un modelo para predecir la variable afinidad como una combinación lineal de las variables restantes. Para ello utilizo un algoritmo que ordenará las variables segun su capacidad explicativa. Este análisis determina que no hay ninguna variable altamente explicativa (como mucho hasta un 3% de la varianza) de manera independiente. Un analisis visual de graficos correlacionando la variable afinidad (como var dependiente) con el resto de variables sugiere que no existe correlación. 
Aun asi, genero un modelo a aprtir de las variables con mayor importancia (segun el calculo anterior), pero como era de esperar se cumple la maxima "garbage in-garbage out". Podemos observar la mala capacidad predictiva en su error de crosvalidacion** (no me molesto en hacer subcojuntos training-test....).

4) Genero un variograma a partir de los residuos del paso anterior, pero debido al mal ajuste del modelo, este variograma no desvela ningun tipo de estructura espacial, por lo que seguir adelante con la interpolacion con kriging no tiene mucho sentido.




