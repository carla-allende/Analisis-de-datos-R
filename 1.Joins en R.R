########################
#JUNTAR DOS DATA FRAMES
########################

# Unir Columnas con CBIND

Datos_1=data.frame(
  id=c(1:10),
  Nombre=c("Juan", "Clara", "David", "Mar?a", "Pedro", "Claudia", "Mart?n", "Ignacio", "Jose", "Lucas" ))
Datos_2=data.frame(  Edad=c(20, 32, 18, 26, 38, 52, 19, 31, 29, 60 ),
                     Peso=c(68, 42, 70, 47, 76, NA, 71, 83, 69, 92))

cbind(Datos_1,Datos_2)

# Unir Filas con RBIND

Datos_1=data.frame(
  id=c(1:10),
  Nombre=c("Juan", "Clara", "David", "María", "Pedro", "Claudia", "Martín", "Ignacio", "Jose", "Lucas" ))
Datos_3=data.frame(
  id=c(11,12,13),
  Nombre=c("Ximena","Bruno","Silvina"))

rbind(Datos_1,Datos_3)

rbind(Datos_3,Datos_3)

library(tidyverse)

# JOINS O MERGE

#Definimos los data frame
Datos_4=data.frame(
  Id=c(1:6),
  Nombre=c("Juan", "Clara", "David", "María", "Pedro", "Claudia")
)
Datos_5=data.frame(
  Id=c(1,2,5,6,8,9),
  Edad=c(20,32,38,52,31,29)
)
# Inner join

inner_join(Datos_4, Datos_5, by="Id")

#Leftjoin

left_join(Datos_4, Datos_5, by="Id")

#Right join

right_join(Datos_4, Datos_5, by="Id")

#Full join

full_join(Datos_4, Datos_5, by="Id")

# Funcion MERGE
Clie_Fact <- merge(Clientes, Facturacion, by.x = "Cliente", by.y = "Codigo", all = TRUE)

Fact_Clie <- merge(Facturacion,Clientes , by.x ="Codigo" , by.y = "Cliente", all = TRUE)

