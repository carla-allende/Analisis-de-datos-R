################################
# INFORMACION GEOGRAFICA Y MAPAS
################################

# R maneja distintas formas de analizar los datos espaciales. 
# Esto difiere según la librería con la que se trabaje. 
# Para esta clase, vamos a trabajar principalmente con los radios censales 
# que se pueden descargar de la web. 
# El radio censal, es una unidad geográfica que agrupa, 
# en promedio 300 viviendas en las ciudades. 
# Si los radios son rurales o rurales mixtos, 
# la cantidad promedio es menor.



library(tidyverse)
library(sf)

radios <- st_read("https://bitsandbricks.github.io/data/CABA_rc.geojson")

# GRAFICOS CON ggplott

#Una vez imporatdo los datos los podemos graficar con la siguiente función

ggplot() + 
  geom_sf(data = radios)

#Podemos cambiar el color de las líneas

ggplot() + 
  geom_sf(data = radios,color="hotpink")

#Si tenemos alguna variable q mida algo dentro de cada polígon, 
#podemos colorear los distintos polígonos.

ggplot() + 
  geom_sf(data = radios,aes(fill=POBLACION))

#Para quitarle los bordes
ggplot() + 
  geom_sf(data = radios,aes(fill=POBLACION),color=NA)

#Podemos cambiar la paleta de colores
ggplot() + 
  geom_sf(data = radios,aes(fill=POBLACION),color=NA)+
  scale_fill_gradient(low = "#4F0039", high = "#ECADDB")

#Podemos pintar el mapa por medio de una variable de tipo factor 

radios<-radios%>%
  mutate(Comuna=paste("Comuna: ",COMUNA,sep=""))
ggplot() + 
  geom_sf(data = radios, aes(fill=Comuna), color=NA)

#Al igual que como hicimos con los data.frame, 
#podemos realizar agrupaciones, como por ejemplo por comuna

datos_comuna<-radios%>%
  group_by(Comuna)%>%
  summarise(Poblacion=sum(POBLACION,na.rm = TRUE),
            Hogares=sum(HOGARES, na.rm = TRUE))

#######################################
# COMO USAR na.rm en R
######################################

#Puede utilizar el argumento na.rm = TRUE para excluir los valores perdidos 
# al calcular estadísticas descriptivas en R.

#Los siguientes ejemplos muestran cómo utilizar este argumento en la práctica 
#tanto con vectores como con marcos de datos.

x <- c(3, 4, 5, 5, 7, NA, 12, NA, 16)

#Operaciones sin na.rm=TRUE

mean(x)

sum(x)

max(x)

sd(x)

#Operaciones con na.rm=TRUE

mean(x, na.rm = TRUE)

sum(x, na.rm = TRUE)

max(x, na.rm = TRUE)

sd(x, na.rm = TRUE)
###########################################################

#Ejecutamos el codigo, vemos como los datos geograficos tambien se 
#ajustaron al agrupamiento

ggplot() + 
  geom_sf(data = datos_comuna)

#Y ahora podemos pintar las comunas 
#teniendo en cuenta la población por comuna

ggplot() + 
  geom_sf(data = datos_comuna, aes(fill=Poblacion),color = NA)+
  scale_fill_gradient(low = "#56B1F7", high = "#132B43")

################################################################
#practica

comunas_1 <- st_read("https://cdn.buenosaires.gob.ar/datosabiertos/datasets/ministerio-de-educacion/comunas/comunas.geojson")

ggplot() + 
  geom_sf(data = comunas_1)

#Podemos poner otra capa de datos al mapa ya creado. 
#Importamos los datos correspondientes a los hospitales en CABA.

file.choose()
Centros_salud<- st_read("centros-de-salud-y-accion-comunitaria.shp")
Centros_salud<- st_read(centros)

ggplot() + 
  geom_sf(data = datos_comuna, aes(fill=Poblacion/Hogares),color = NA, alpha=0.7)+
  scale_fill_gradient(low = "#56B1F7", high = "#132B43") +
  geom_sf(data=Centros_salud)

#Agreguemos otras capas mas a nuestro proyecto
#Cargamos 2 fuentes de datos mas
subte_lineas <- st_read("http://bitsandbricks.github.io/data/subte_lineas.geojson")
subte_estaciones <- st_read("http://bitsandbricks.github.io/data/subte_estaciones.geojson")
subte_estaciones <- st_read(estaciones)
ggplot() + 
  geom_sf(data = datos_comuna, aes(fill=Poblacion/Hogares),color = NA, alpha=0.7)+
  scale_fill_gradient(low = "#56B1F7", high = "#132B43") +
  geom_sf(data=Centros_salud)+
  geom_sf(data=subte_lineas, color='yellow')+
  geom_sf(data=subte_estaciones, color= 'red')

subte_lineas <- st_read("http://bitsandbricks.github.io/data/subte_lineas.geojson")
subte_estaciones <- st_read("http://bitsandbricks.github.io/data/subte_estaciones.geojson")
rivadavia <- st_read("https://cdn.buenosaires.gob.ar/datosabiertos/datasets/jefatura-de-gabinete-de-ministros/calles/avenida_rivadavia.geojson")
ggplot() + 
  geom_sf(data = datos_comuna, aes(fill=Poblacion/Hogares),color = NA, alpha=0.7)+
  scale_fill_gradient(low = "#56B1F7", high = "#132B43") +
  geom_sf(data=Centros_salud)+
  geom_sf(data=subte_lineas, color='yellow')+
  geom_sf(data=subte_estaciones, color= 'red')+
  geom_sf(data=rivadavia, color= 'green')

