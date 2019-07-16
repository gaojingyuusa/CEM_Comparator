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

# WDI file: data_file contains all the indicator data needed for the structural and aspirational comparators
data_file <- read.csv("test.csv", header=T)

# WBG classification file: class_file contains information such as which country belongs to which group defined by WBG like region and income level
class_file <- read.csv("iso_class.csv", header=T)

# Indicator class file: indicator_file contains the description of each indicator used in the tool
indicator_file <- read.csv("indicator.csv", header=T)

