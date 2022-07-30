#Load Libraries
library("ggplot2")
library("tibble")
library("gridExtra")
library("dplyr")
library("Lock5Data")
library("ggthemes")
library("fun")
library("zoo")
library("corrplot")
library("ggthemes")
library("purrr")

#Set pathname for the directory where you have data
setwd("C:/Users/Luis Cerda/Documents/UdeSA/Cursos/IIT/HCI/Clase5/Tarea5")

#Check working directory
getwd()

#cargamos los archivos a utilizar
df <- read.csv("data/gapminder-data.csv")
df2 <- read.csv("data/xAPI-Edu-Data.csv")
df3 <- read.csv("data/LoanStats.csv")


#Summary of the three datasets
str(df)
str(df2)
str(df3)


########################################################################
#Graph 1
########################################################################

#Activity:Using faceting to understand data

df3s <- subset(df3,grade %in% c("A","B","C","D","E","F","G"))
pb1<-ggplot(df3s,aes(x=loan_amnt))
pb2<-pb1+geom_histogram(bins=10,fill="cadetblue4") + labs(title="Distribution of credits granted by classification",x="Credit amount (USD)", y = "Numbers of credits granted", caption = "Source: https://github.com/TrainingByPackt/Applied-Data-Visualization-with-R-and-ggplot2") +
  theme(plot.caption.position = "plot",
        plot.caption = element_text(hjust = 0))
#Utilización de la función Facet_wrap
pb3<-pb2+facet_wrap(~grade) 
pb3


########################################################################
#Graph 2
########################################################################

#Subtopic: Themes and changing the appearance of graphs
#Exercise:Using theme to customize a plot
#“The color palette can be found at: “http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf”

dfn <- subset(HollywoodMovies2013, Genre %in% c("Action","Adventure","Comedy","Drama","Romance")
              & LeadStudio %in% c("Fox","Sony","Columbia","Paramount","Disney"))
p1 <- ggplot(dfn,aes(Genre,WorldGross)) 
p2 <- p1+geom_bar(stat="Identity",aes(fill=LeadStudio),position="dodge")

p7 <- p2+theme_economist()+ggtitle("Genres of movies produced by studio in 2013", subtitle = "(Recording hours)")+scale_colour_economist() + labs(x="", y = "", caption = "Source: https://github.com/TrainingByPackt/Applied-Data-Visualization-with-R-and-ggplot2") +
  theme(plot.caption.position = "plot",
        plot.caption = element_text(hjust = 0))
p7

########################################################################
#Graph 3
########################################################################

## Advanced Geoms and Statistics
# Create a bubble chart
#In this graph, we will plot the electricity consumption per capita for different years and countries. The size of the dot will vary, depending on the population of the country

dfs <- subset(df,Country %in% c("Germany","India","China","United States","Japan"))

ggplot(dfs,aes(x=Year,y=Electricity_consumption_per_capita)) + geom_point(aes(size=population,color=Country))+
  coord_cartesian(xlim=c(1950,2020))+
  labs(title="Annual electricity consumption per country", subtitle="(Kilowatts consumed per year, dot size varies depending on population size)", x="", y = "", caption = "Source: https://github.com/TrainingByPackt/Applied-Data-Visualization-with-R-and-ggplot2") +
  theme(plot.caption.position = "plot", plot.caption = element_text(hjust = 0)) + scale_size(breaks=c(0,1e+8,0.3e+9,0.5e+9,1e+9,1.5e+9),range=c(1,5)) 


