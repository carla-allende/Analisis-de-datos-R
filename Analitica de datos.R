library(tidyverse)

Ventas_Clientes <- Clie_Fact %>% 
  group_by(`Nombre y Apellido`) %>%
  summarise(Total_Ventas = sum(Total))

