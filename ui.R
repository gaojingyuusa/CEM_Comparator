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
                    ",
                    
                    ".selectize-input {}
                     #INDICATOR1+ div>. selectize-input{height:10px;font-size: 11px; line-height: 16px;}
                    
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
                 selectInput("TARGET","Select Target Country",choices=unique(data_file$countryname),"Afghanistan", multiple = F),
                 textOutput("country.region"),
                 textOutput("country.income"),
                 textOutput("country.land"),
                 textOutput("country.small"),
                 textOutput("country.fcs"),
                 checkboxInput("REGION", "Regional Peers", value=FALSE),
                 checkboxInput("LAND", "Landlocked", value=FALSE),
                 checkboxInput("SMALL", "Small States", value=FALSE),
                 checkboxInput("FCS", "Fragile & Conflicted States", value=FALSE)
                ),
    
    # Main Panel: Structural and Aspirational
    mainPanel(
      tabsetPanel(type="tabs",
                  tabPanel("Structural Comparators",
                           h3("Find Structural Comparators", style="color:#002244"),
                           p("Structural comparators are defined as countries that are similar to the target country in terms of selected indicators."),
                           h4(strong("Select up to 6 indicators and their weight")),
                      # Title of indicator selections
                         fluidRow(
                           column(9,
                                 "Indicators"
                                 ),
                           column(3,
                                  "Weight"
                                 )
                                 ),
                      # Indicator 1
                         fluidRow(
                           column(9,
                               selectInput("INDICATOR1",NULL,choices=unique(indicator_file$Description),selected="GDP (constant 2010 US$)")
                                 ),
  
                           column(3, 
                                conditionalPanel(
                                  condition = "input.INDICATOR1 != 'Select'",
                                  numericInput("W1",NULL,value=1)
                                                )
                                 )
                                 ),
                      # Indicator 2    
                      fluidRow(
                        column(9,
                               selectInput("INDICATOR2",NULL,choices=unique(indicator_file$Description),selected="Select")
                        ),
                        
                        column(3, 
                               conditionalPanel(
                                 condition = "input.INDICATOR2 != 'Select'",
                                 numericInput("W2",NULL,value=1)
                               )
                        )
                              ),
                      # Indicator 3
                      fluidRow(
                        column(9,
                               selectInput("INDICATOR3",NULL,choices=unique(indicator_file$Description),selected="Select")
                        ),
                        
                        column(3, 
                               conditionalPanel(
                                 condition = "input.INDICATOR3 != 'Select'",
                                 numericInput("W3",NULL,value=1)
                                               )
                              )
                              ),
                      
                      # Indicator 4
                      fluidRow(
                        column(9,
                               selectInput("INDICATOR4",NULL,choices=unique(indicator_file$Description),selected="Select")
                        ),
                        
                        column(3, 
                               conditionalPanel(
                                 condition = "input.INDICATOR4 != 'Select'",
                                 numericInput("W4",NULL,value=1)
                                               )
                              )
                              ),
                      
                      # Indicator 5
                      fluidRow(
                        column(9,
                               selectInput("INDICATOR5",NULL,choices=unique(indicator_file$Description),selected="Select")
                               ),
                        
                        column(3, 
                               conditionalPanel(
                                 condition = "input.INDICATOR5 != 'Select'",
                                 numericInput("W5",NULL,value=1)
                                               )   
                              )
                              ),
                      
                      # Indicator 6
                      fluidRow(
                        column(9,
                               selectInput("INDICATOR6",NULL,choices=unique(indicator_file$Description),selected="Select")
                        ),
                        column(3, 
                               conditionalPanel(
                                 condition = "input.INDICATOR6 != 'Select'",
                                 numericInput("W6",NULL,value=1)
                                               )
                              )
                              ),
                      
                      # Structural data table
                      tableOutput("struc_table"),
                      tableOutput("str_matchind")
                       
                           
                           
                          ),
                  tabPanel("Aspirational Comparators")
                 )
             )
               )
  

  
)

