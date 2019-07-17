# User interface of CEM country selection website

library(shiny)
library(DT)
source("CEM_com_functions.R", local=F)
source("CEM_selector_data.R", local=T)

fluidPage(
  
  # Style elements
  tags$head(
    tags$style(HTML(
                    "
                    #sidebar  {background-color: white;}
                    "
                   )
              )
           ),
  
  # Maintitle
  titlePanel(
    fluidRow(
      column(6,p("Country Comparator Selection", style="color:#009FDA"))
            )
            ),
  
  # Sidebar   
  sidebarLayout(
    
    # Customization Pane
    sidebarPanel(id="sidebar",
                 h3(strong("Customization"),style="color:#002244"),
                 sliderInput("YEAR","Select Period", min=1960, max=2018,value=c(2012,2017)),
                 selectInput("TARGET","Select Target Country",choices=unique(data_file$countryname),"Afghanistan", multiple = F)
                
                ),
    
    # Main Panel: Structural and Aspirational
    mainPanel(
      tabsetPanel(type="tabs",
                  tabPanel("Structural Comparators"),
                  tabPanel("Aspirational Comparators")
                 )
             )
               )
  

  
)

