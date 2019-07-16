# User interface of CEM country selection website

library(shiny)
library(DT)
source("CEM_com_functions.R", local=F)
source("CEM_selector_data.R", local=T)

fluidPage(
  
  # Maintitle
  titlePanel(
    fluidRow(
      column(6,p("Country Comparator Selection", style="color:#009FDA"))
            )
            ),
          
  sidebarLayout(
    sidebarPanel(id="sidebar",
                 h3(strong("Customization"),style="color:#002244"),
                 h4("Download Indicators", style="color:grey"),
                 selectInput("TARGET","Select Target Country",choices=unique(data_file$countryname),"Afghanistan", multiple = F)
                 
                
                ),
    mainPanel(
      tabsetPanel(type="tabs",
                  tabPanel("Structural Comparators"),
                  tabPanel("Aspirational Comparators")
                 )
             )
               )
  

  
)

