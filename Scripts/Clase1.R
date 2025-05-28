#librerias
install.packages("data.tables")
install.packages("tidyverse", dependencies = TRUE)
library(data.table)
library(tidyverse)
#vectores
179/5378641

options(scipen = 999)
options(digits = 4)


getwd()
setwd("/cloud/project/data")
list.files()
library(data.table)
library(readxl)
datos <- setDT(read_excel("Estructura_M0.xlsx"))
save(list = c("datos"), file = "Info.RData", envir = .GlobalEnv)
