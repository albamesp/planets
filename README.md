#Misión 1: The return of the Data Miner
La tabla unificada con la geolocalización de los planetas y las variables recogidas en los ficheros data-planets1.csv y data-planets2.csv puede descargarse [aquí](https://github.com/albamesp/planets/blob/master/planets.csv).

El campo id es establecido como "primary key" que unirá las distintas tablas.

#Misión 2 : The Machine Learner Strikes back
Para generar un modelo predictivo con datos espaciales voy a crear un modelo de la forma
(1) ![\bar{z}=\bar{x}\bar{\beta} + \bar{v} + \bar{e}](http://mathurl.com/gqajmk6.png)

donde ![\bar{z}](http://mathurl.com/jmscoug.png) es la variable dependiente, ![\bar{x}\bar{\beta}](http://mathurl.com/zuz8wyc.png) son las variables predictivas, ![\bar{v}](http://mathurl.com/h45qg8b.png) es el término de correlación espacial y ![\bar{e}](http://mathurl.com/h9cwv2g.png) representa un error de medida. 

Sección realizada usando la versión de R 3.3. El [script](https://github.com/albamesp/planets/blob/master/planets2.R) realiza las siguientes tareas:

1) El campo afinidad es asociado a cada uno de los planetas a partir del id.

2) Lleva a cabo una inspección de las distintas variables para evitar multicolinealidad: calcula una matrix de correlaciones y elimina aquellas variables con una correlación superior a 0.75. En este paso, se eliminan 48 de las 165 variables (no se incluyen en este paso las variables id, name, x,y).

3) Determinación de ![\bar{x}\bar{\beta}](http://mathurl.com/zuz8wyc.png): elaboro un modelo para predecir la variable afinidad como combinación lineal de las variables predictiva, ordenando primero las variables segun su capacidad explicativa (a partir del paquete de R [_CARET_](https://cran.r-project.org/web/packages/caret/index.html)).

Este análisis determina que no hay ninguna variable altamente explicativa (como mucho hasta un 3% de la varianza) de manera independiente ([***Figura 1***](https://github.com/albamesp/planets/blob/master/importance.png)). 

De forma paralela, un análisis visual de gráficos correlacionando la variable afinidad con el resto de variables sugiere que no existe correlación ([***Figura 2***](https://github.com/albamesp/planets/blob/master/covariates.png)).

Aun así, pruebo a generar un modelo a partir de las variables con mayor importancia (según el calculo anterior), pero como era de esperar se cumple la máxima "garbage in-garbage out". Podemos observar la mala capacidad predictiva en su error de crosvalidación (
[***Figura 3***](https://github.com/albamesp/planets/blob/master/crossvalidation_m1.png)).

4) Ahora vamos a tratar de determinar si hay algun tipo de estructura espacial (calculamos  ![\bar{v}](http://mathurl.com/h45qg8b.png)). Para ello, genero un variograma a partir de los residuos calculados con el modelo anterior ([***Figura 4***] (https://github.com/albamesp/planets/blob/master/residual_nonsp.png)). Debido al mal ajuste del modelo, no desvela ningún tipo de estructura espacial en ninguna de sus direcciones ([***Figura 5***](https://github.com/albamesp/planets/blob/master/var_anis.png)), por lo que seguir adelante con la interpolación con kriging no tiene mucho sentido. De haber encontrado un modelo de correlación espacial decente, usaríamos el nugget del variograma como estimador de ![\bar{e}](http://mathurl.com/h9cwv2g.png) en (1) para determinar ![\bar{z}](http://mathurl.com/jmscoug.png).

#Misión 3: A spatial hope

La primera tarea es calcular una matriz de distancias entre las bases enemigas y determinar aquellas que se encuentran a menos de 15000 UG ([***Figura 6***](https://github.com/albamesp/planets/blob/master/evils_close.png)).

Para la realización de la segunda tarea (encontrar la posición óptima de una nueva base aliada), he establecido la siguiente función de coste que favorece aquellas localizaciones (s) cercanas a los planetas (![\mu_i](http://mathurl.com/htykwc8.png)) y lejanas a las bases enemigas (![\xi_i](http://mathurl.com/zsb2mdp.png))

(2) ![ J_{\bar{s}} = \sum_{i=1}^{n} \alpha_{i}\|\bar{s}-\bar{\mu}_{i} \| + \beta \sum_{j=1}^{m} \frac{1} {\|\bar{s}-\bar{\xi}_{j}\|}](http://mathurl.com/jx63ul8.png)

donde ![\alpha_i](http://mathurl.com/hav5gw8.png) = f(affinity, population) establece los pesos que daríamos a los distintos planetas en función de la afinidad y población, mientras que ![\beta](http://mathurl.com/2eznoyo.png) parametriza las bases enemigas. En este modelo se ha supuesto que todas son iguales. La función f y el parámetro ![\beta](http://mathurl.com/2eznoyo.png) son variables a ajustar. 

La localización óptima será aquella que minimiza la función de coste. Este problema se puede resolver, por ejemplo, utilizando la función de minimización no lineal "nlm" de R.
