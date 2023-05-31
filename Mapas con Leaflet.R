# MAPAS CON LEAFLET
# Leaflet nos permite hacer mapas interactivos.

library(leaflet)
library(sf)
#MAPAS BASE

leaflet()%>%  # leaflet trabaja con el operador %>% 
   #addTiles()  # Configura el mapa base OpenStreetMap map tiles
  #addProviderTiles(providers$CartoDB.Positron)
  #addProviderTiles(providers$Stamen.Toner)
  addProviderTiles(providers$Esri.NatGeoWorldMap)

#MARCADORES
#Use marcadores para señalar puntos, expresar ubicaciones con latitud / longitud
#coordenadas, aparecen como iconos o como círculos.
#Los datos provienen de vectores o marcos de datos asignados, u objetos de paquete sf
Centros_salud <- read_sf("C:\\Users\\carli\\OneDrive\\Documents\\EducaciónIT\\Analisis data R\\rr\\centros-de-salud-y-accion-comunitaria.dbf")

file.choose()

leaflet()%>%
  #addProviderTiles(providers$Esri.NatGeoWorldMap)%>%
  addMarkers(data=Centros_salud)

#Podemos ponerle informacion para cuando uno pase por arriba con el mouse

leaflet()%>%
  addProviderTiles(providers$Esri.NatGeoWorldMap)%>%
  addMarkers(data=Centros_salud,label=~nombre)

#O ponerle informacion cuando uno hace un click

leaflet()%>%
  addProviderTiles(providers$Esri.NatGeoWorldMap)%>%
  addMarkers(data=Centros_salud,popup =~nombre)