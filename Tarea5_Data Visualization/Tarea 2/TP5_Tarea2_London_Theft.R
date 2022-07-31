                    # Herramientas Computacionales de Investigacion 
                                    # TP 5
                    # --- Rigirozzi, Gonzalo y Cerda, Luis --- 

                    # --- Paquetes para el trabajo --- 

#Prior to use, install the following packages:
'
install.packages("ggplot2")
install.packages("dplyr")
install.packages("tmap")
install.packages("tibble")
install.packages("broom")
install.packages("gridExtra")
install.packages("Lock5Data")
install.packages("ggthemes")
install.packages("tidyverse")
install.packages("shadowtext")
install.packages("corrplot")
install.packages("fun")
install.packages("zoo")
install.packages("rgdal")
'
library(ggplot2)
library(dplyr)
library(dplyr)
library(ggplot2)
library(broom)
library(ggpubr)
library(tidyverse)
library(shadowtext)

#Seteo directorio

setwd("/Users/gonzalorigirozzi/Desktop/Clase 5/videos 2 y 3/data")

#Se carga shapefile "london_sport"

library(rgdal) #libreria para poder abrir .shp
lnd <- readOGR("/Users/gonzalorigirozzi/Desktop/Clase 5/videos 2 y 3/data/london_sport.shp")

# Se carga csv con datos de crimen en London
crime_data <- read.csv("mps-recordedcrime-borough.csv",
                       stringsAsFactors = FALSE)

# Se extrae "Theft & Handling"
crime_theft <- crime_data[crime_data$CrimeType == "Theft & Handling", ]

# Se calcula la suma de theft para cada distrito o borough en London
crime_ag <- aggregate(CrimeCount ~ Borough, FUN = sum, data = crime_theft)

# Se verifica que coincidan los nombres en cada Borough y crime_ag
lnd$name %in% crime_ag$Borough
lnd$name[!lnd$name %in% crime_ag$Borough]

# Se realiza un left join, datos que coinciden en ambas(indicando que name es igual a Borough) en una base se llama name y en otra base Borough
lnd@data <- left_join(lnd@data, crime_ag, by = c('name' = 'Borough'))


# Se convierten los datos a DataFrame para usar ggplot luego
lnddf <- broom::tidy(lnd)

lnd$id <- row.names(lnd)
lnddf <- left_join(lnddf, lnd@data)

#Se duplica para trabajar sobre ella
lndcopy <- lnddf

#Se chequea que variables hay que pasar a numeric
sapply(lndcopy, class) 

#Transforma las variables a numéricas. 
lndcopy$piece <- as.numeric(as.factor(lndcopy$piece))
lndcopy$group <- as.numeric(as.factor(lndcopy$group))
lndcopy$id <- as.numeric(as.character(lndcopy$id))
lndcopy$Pop_2001 <- as.numeric(as.character(lndcopy$Pop_2001))
lndcopy$ons_label <- as.numeric(as.character(lndcopy$ons_label))

#Se calcula las medias.
mean_vars <- lndcopy %>% 
  group_by(name) %>%
  summarise_all("mean")


#--------- GGPLOT---------------#

#Se genera map1 con ggplot
map1 <- ggplot(lnddf, aes(long, lat, group = group, fill = CrimeCount)) +
  geom_polygon(colour="Darkblue") + coord_equal() + #plot a los barrios
  geom_shadowtext(aes(label = name),              #nombre de las etiquetas        
                  data = mean_vars,               #data para las labels        
                  check_overlap = TRUE,            #no superposicion de las labels.       
                  stat="identity", position = "identity",                    
                  size = 3,                       #seteo de las labels
                  hjust = 0.4,                            
                  vjust = 0.4,                            
                  color = "black",                        
                  bg.color="white") +                     
  labs(fill = "Amount of thefts ") +
  
  theme(axis.text = element_blank(), # change the theme options
        axis.title = element_blank(), # remove axis titles
        axis.ticks = element_blank())# remove axis ticks

map1 + scale_fill_distiller(name="Amount of thefts by borough", 
                           palette = "Blues", 
                           direction= +1)

ggsave("maptheftgg1.png")

# --------- Mapa con tmap --------------#

library(tmap)
maptheftstmap <- tm_shape(lnd) +
              tm_polygons("CrimeCount", 
              palette = "Blues",                     # paleta de colores
              n=4,                                   # 4 categorías
              title = "Amount of thefts by borough"  # titulo de las categorias 
  ) +
  tm_text("name",                                    # Se agrega tag con nombre de cada borough
          size = 0.5,                                # tamaño de la etiqueta.
          col = "black",                             # color de la etiqueta
          remove.overlap = TRUE,                     # Las tags no se superponen 
          overwrite.lines = TRUE,                    # permito que el nombre se encime con las lineas
          shadow = TRUE                              # sombreado
  ) +
  tm_layout(                                         #config de leyenda
    legend.outside = TRUE,
    legend.position = c("right", "bottom"),
    legend.title.size = 1.3,
    legend.text.size = 0.9,
    frame = FALSE,                                   # Se quita marco
  )

maptheftstmap                                          # Se corre

tmap_save(maptheftstmap)