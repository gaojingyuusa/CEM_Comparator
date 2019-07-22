# build a file for all the data cleaning documents
library(shiny)
library(leaflet)
library(rgdal)
library(raster)
library(dplyr)
library(formattable)
library(shinydashboard)
library(WDI)
library(rsconnect)

# function to make factor text
text.fun <- function(data){
  data[,sapply(data, class) == "factor"] <- sapply(data[,sapply(data, class) == "factor"],as.character)
  data
}


# WDI file: data_file contains all the indicator data needed for the structural and aspirational comparators
data_file <- read.csv("cem_full.csv", header=T) %>% text.fun()
names(data_file)[1] <- "iso3"
# WBG classification file: class_file contains information such as which country belongs to which group defined by WBG like region and income level
class_file <- read.csv("iso_class.csv", header=T) %>% text.fun()

# Indicator class file: indicator_file contains the description of each indicator used in the tool
indicator_file <- read.csv("indicator.csv", header=T) %>% text.fun()
names(indicator_file)[1] <- "Description"
# Structural Break data from Miodrag
struc_break_file <- read.csv("CEM_stru_break.csv", header=T) %>% text.fun()

# ISO and Name concordance table
iso_name <- unique(data_file[,c("iso3","countryname")])


















summary <- aggregate(data_file, by = list(data_file$countryname), FUN=mean, na.rm=T) %>% subset(select=c("Group.1", "gdp","gdppc")) %>% mutate(add=1)
#rank(-summary$gdp, na.last="keep") ,"gdpc","gdppc","gdppcc"

summary[,2:ncol(summary)] <- sapply(summary[,2:ncol(summary)], function(x) rank(-x, na.last="keep"))
#summary[summary$Group.1 == "China",2:3]
#sweep(summary[,2:3], 2, c(1,2),"-")

#summary[,!names(summary)=="Group.1"]

test <- sapply(summary[,2:ncol(summary)], function(x) rank(-x, na.last="keep")) %>% as.matrix()
chn <- summary[summary$Group.1 == "China",2:ncol(summary)] %>% as.matrix()
summary[,2:ncol(summary)] <- sweep(test,2, chn,"-")


