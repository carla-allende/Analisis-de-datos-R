# En el presente post se abordar? la funci?n sqldf( ) ?nica funci?n del 
# paquete {sqldf}, mediante la cual es posible utilizar las formulaciones 
# y la sintaxis convencional de SQL en el entorno de R.


# Paquetes

# El paquete {sqldf} consiste en una funci?n sqldf(). 
# Dicha funci?n se acompa?a con el comando SELECT de SQL 
# seguido de la sintaxis tradicional de SQL (Structured Query Language). 
# Esta funci?n nos permite trabajar con las formulaciones de SQL 
# sobre dataframes del entorno de R. 



# En primer lugar descargamos el paquete {sqldf} y el paquete {tidyverse} 
# que nos servir? para comparar la sintaxis de SQL 
# con la sintaxis tradicional de {dplyr}. 


library(sqldf)
library(tidyverse)
#library(Hmisc)

# Dataset

# Utilizaremos el dataset Roman Emperors, donde encontraremos diversa informaci?n 
# sobre los emperadores romanos (nombre, fecha de nacimiento, causa de la muerte, dinast?a, etc.). 


emperors <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-08-13/emperors.csv")



  
todo_df <- sqldf('SELECT * FROM emperors')
head(todo_df)

sqldf('SELECT * FROM emperors LIMIT 6')

SELECT

# Como hemos visto en el apartado anterior, el asterisco (*) 
# sirve para seleccionar el conjunto de variables y observaciones del dataframe. 
# Sin embargo, es probable que queramos identificar ?nicamente 
# las observaciones para un conjunto de variables del dataset original. 
# Para ello utilizaremos SELECT, que se asemeja en gran medida a 
# la funci?n select() del paquete {dplyr}. 
# Pongamos que nos interesa ?nicamente extraer el nombre del emperador, la dinast?a, 
# la fecha de nacimiento, la causa de la muerte, 
# el asesino de entre todas las variables del dataframe.



sqldf('SELECT name, dynasty, birth, killer, cause  FROM emperors LIMIT 10')

 #AS
# Es posible que nos interese modificar el nombre de las columnas del dataset resultante. 
# En SQL estos cambios los podemos realizar f?cilmente con AS. 
# Veamos por ejemplo c?mo podr?amos cambiar el nombre de todas 
# las variables seleccionadas en el punto anterior.

sqldf('SELECT name AS Nombre, 
              dynasty AS Dinastia, 
              birth AS Nacimiento, 
              killer AS Asesino, 
              cause AS Causa_muerte 
      FROM emperors 
      LIMIT 10')

#En R, para seleccionar las columnas mencionadas con la funci?n select() de {dplyr} indicamos:

emperors %>%
select(name, dynasty, birth, killer, cause) %>%
head(10)

#ORDER BY

# En SQL podemos utilizar ORDER BY para ordenar las observaciones 
# del dataset al estilo de la funci?n arrange() del paquete {dplyr}. 
# De esta forma pongamos, por ejemplo, que queremos ordenar el dataset 
# con las variables previamente seleccionadas seg?n la fecha de nacimiento, b
# ien sea en orden ascendente o descendente. 
# Para ello utilizamos ORDER BY junto a ASC o DESC 
# (y seleccionamos ?nicamente las 10 primeras observaciones con LIMIT por motivos de espacio)



# Orden ascendente:

sqldf('SELECT name, dynasty, birth, killer, cause 
      FROM emperors 
      ORDER BY birth ASC 
      LIMIT 10')


# Orden descendente:

sqldf('SELECT name, dynasty, birth, killer, cause 
      FROM emperors 
      ORDER BY birth DESC 
      LIMIT 10')


# De forma similar podemos utilizar diversos criterios para ordenar el dataset. 
# Pongamos que nos interesa ordenar el dataset, en primer lugar, seg?n la dinast?a, 
# despu?s por la causa de la muerte y en tercer lugar seg?n su asesino,
# todos los criterios de forma ascendente.

sqldf('SELECT name, dynasty, birth, cause, killer 
      FROM emperors 
      ORDER BY dynasty ASC, cause ASC, killer ASC 
      LIMIT 20')


# En R, como se ha se?alado, indicando los mismos criterios de selecci?n 
# y utilizando la funci?n arrange() del paquete {dplyr} obtenemos el mismo resultado.

emperors %>%
  select(name, dynasty, birth, cause, killer) %>%
  arrange(dynasty, cause, killer) %>%
  head(20)

#COUNT / DISTINCT

# La funci?n COUNT nos permite identificar el n?mero de filas que no contienen valores NA.
# En el ejemplo de los emperadores romanos, al aplicar este operador a dos 
# columnas distintas comprobamos que el valor obtenido para la columna 
# birth_cty es menor (51) que la columna name de los emperadores (68), 
# indicando que existen 17 valores NA en dicha variable.



sqldf('SELECT COUNT(name) AS num_cols
      FROM emperors')

sqldf('SELECT COUNT(birth_cty) AS num_cols
      FROM emperors')


# El comando DISTINCT nos devuelve las observaciones, 
# eliminando las posibles repeticiones. 
# En el siguiente comando observamos, con la funci?n dim(), 
# que existen 68 observaciones en la variable name, 
# una por cada emperador, mientras que existen 31 ciudades (30 ciudades y un NA) 
# en la variable birth_cities debido a la existencia de ciudades que han visto 
# nacer a m?s de un emperador.


names <- sqldf('SELECT DISTINCT name 
      FROM emperors')

dim(names)

head(names, n=10)


birth_cities <- sqldf('SELECT DISTINCT birth_cty 
      FROM emperors')
dim(birth_cities)

head(birth_cities, n=10)

# El comando DISTINCT se corresponde a la popular funci?n unique() de R. 
# Consecuentemente las siguientes expresiones devolver?n el mismo resultado


names_2 <- unique(emperors$name)
dim(names_2)

head(names_2, n=10)


birth_cities_2 <- unique(emperors$birth_cty)
dim(birth_cities_2)

head(birth_cities_2, n=10)




#WHERE

# WHERE nos permite establecer alg?n criterio de selecci?n a la hora 
# de extraer informaci?n del dataframe. WHERE en SQL funciona en gran medida 
# como la funci?n filter()de {dplyr}. Por ejemplo, 
# pongamos que queremos extraer el nombre de los emperadores, 
# su ciudad de nacimiento y su asesino, pero ?nicamente de aquellos emperadores 
# cuya causa de la muerte fue por motivo de asesinato.


sqldf('SELECT name, birth_cty, killer 
      FROM emperors 
      WHERE cause = "Assassination"')

# WHERE . AND / OR
# Podemos a?adir otros criterios de selecci?n. 
# Pongamos que adem?s de interesarnos aquellos emperadores romanos 
# que han muerto asesinados nos interesa identificar aquellos emperadores 
# que han muerto asesinados por su guardia pretoriana. 
# Para ello utilizamos podemos utilizar AND de la siguiente forma 
# (aunque en este caso particular no ser?a necesario indicar la causa del asesinato 
# en tanto en cuanto la existencia de un asesino implica por defecto la causa de muerte)


sqldf('SELECT name, birth_cty, killer 
      FROM emperors 
      WHERE cause = "Assassination" 
      AND killer = "Praetorian Guard"')

# Pongamos que nos interesa seleccionar aquellos emperadores asesinados 
# bien por su guardia pretoriana bien por su propio ej?rcito:
  
 
sqldf('SELECT name, birth_cty, killer 
      FROM emperors 
      WHERE killer = "Praetorian Guard" 
      OR killer = "Own Army"')


# Su equivalencia en R utilizando la funci?n filter() ser?a la siguiente:
 
emperors %>%
  select(name, birth_cty, killer) %>%
  filter(killer == "Praetorian Guard" | killer == "Own Army")



#Tradicionalmente en R se utiliza %in% para obtener el resultado obtenido con LIKE en SQL.



emperors %>%
  select(name, dynasty, birth, cause) %>%
  filter(dynasty %in% c("Flavian", "Gordian")) %>%
  head(20)




#WHERE . LIKE / NOT LIKE


sqldf('SELECT name, name_full
      FROM emperors 
      WHERE name LIKE "Constantine%"')



sqldf('SELECT name, name_full
      FROM emperors 
      WHERE name NOT LIKE "%ius"
      LIMIT 15')


#GROUP BY

# GROUP_BY permite agrupar los resultados al estilo de la funci?n group_by() de {dplyr}. 
# Pongamos, por ejemplo, que queremos contar los emperadores romanos 
# que pertenec?an a cada dinast?a:
  
  
  
sqldf('SELECT dynasty, count(*) AS total
    FROM emperors 
    GROUP BY dynasty')


# En R el mismo resultado se obtendr?a con las funciones group_by() y summarise() 
# de las siguiente forma:
  
  
  
emperors %>%
  group_by(dynasty) %>%
  summarise(total = n())


