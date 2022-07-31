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
lnd_df <- broom::tidy(lnd)

# Se realiza left join by id
lnd$id <- row.names(lnd)
lnd_df <- left_join(lnd_df, lnd@data)

#Se chequea que variables hay que pasar a numeric
sapply(lnd_df, class) 

#Transforma las variables a numéricas. 
lnd_df$piece <- as.numeric(as.factor(lnd_df$piece))
lnd_df$group <- as.numeric(as.factor(lnd_df$group))
lnd_dfy$id <- as.numeric(as.character(lnd_df$id))
lnd_df$Pop_2001 <- as.numeric(as.character(lnd_df$Pop_2001))
lnd_df$ons_label <- as.numeric(as.character(lnd_df$ons_label))

#Se calcula las medias.
mean_vars <- lnd_df %>% 
  group_by(name) %>%
  summarise_all("mean")


#--------- Mapa con ggplot ------------#

#Se genera map con ggplot
ggmap <- ggplot(lnd_df, aes(long, lat, group = group, fill = CrimeCount)) +
  geom_polygon(colour="Darkgray") + coord_equal() +
  geom_shadowtext(aes(label = name),                      # Variable Name para label
                  data = mean_vars,                       # Data mean_vars para label
                  check_overlap = TRUE,                   # para que no haya overlap  
                  size = 3,                               # tamaño para label          
                  hjust = 0.5,                            # horizontal just
                  vjust = 0.5,                            # vertical just
                  color = "black",                        # color de label
                  bg.color="white") +                     # background de label
  labs(fill = "Amount of thefts")                         # titulo que acom
ggmap + scale_fill_distiller(name="Amount of thefts by borough", 
                           palette = "Blues", 
                           direction= +1
                           
)+ theme_transparent()

#Guardamos el mapa
ggsave("ggmap.png")

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

maptheftstmap                                        # Se corre

tmap_save(maptheftstmap)

