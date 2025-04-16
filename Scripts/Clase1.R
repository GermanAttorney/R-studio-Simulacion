#librerias
install.packages("data.tables")
install.packages("tidyverse", dependencies = TRUE)
library(data.table)
library(tidyverse)

#Rprofile, cambios locales, cargar configs
if(!file.exists("~/.Rprofile")){
  file.create("~/.Rprofile")
}else{
  file.edit("~/.Rprofile")
}

#vectores
179/5378641

options(scipen = 999)
options(digits = 4)

x <- c(12,5,7,22)

sum(x)
mean(x)

x %>% sum()

