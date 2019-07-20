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
                    
                    "
                     .form-group, .selectize-control {
                    margin-bottom: 2px;
                    }
                    .box-body {
                    padding-bottom: 2px;
                    }
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
                 selectInput("TARGET","Select Target Country",
                             #shiny::HTML("<p><span style='color: grey; padding: 0px; margin: 0px;'>Select Target Country</span></p>"),
                             choices=unique(data_file$countryname),"Afghanistan", multiple = F),
                 h4(""),
                 sliderInput("YEAR","Select Period", min=1960, max=2018,value=c(2012,2017)),
                 h4(""),
                 h5(strong("WBG Categories")),
                 h5(textOutput("country"),style="color:#009FDA"),
                 textOutput("country.region.txt"),
                 textOutput("country.income"),
                 textOutput("country.land"),
                 textOutput("country.small"),
                 textOutput("country.fcs")
                # checkboxInput("REGION", "Regional Peers", value=FALSE),
                # checkboxInput("LAND", "Landlocked", value=FALSE),
                # checkboxInput("SMALL", "Small States", value=FALSE),
                # checkboxInput("FCS", "Fragile & Conflicted States", value=FALSE)
                ),
    
    # Main Panel: Structural and Aspirational
    mainPanel(
      tabsetPanel(type="tabs",
                  tabPanel("Structural Comparators",
                           h3("Find Structural Comparators", style="color:#002244"),
                           h3(textOutput("country"), style="color:#009FDA"),
                           p("Structural comparators are defined as countries that are similar to the target country in terms of selected indicators."),
                           h4(strong("Select up to 6 indicators and their weight")),
                      # Title of indicator selections
                         fluidRow(
                           column(4,
                                 "Indicators"
                                 ),

                           column(3,
                                  "Weight"
                                 ),
                           
                           column(5,
                                  "Average"
                                 )
                           
                                 ),
                      # Indicator 1
                         fluidRow(
                           column(4,#style="margin-bottom:0px;padding-right:0px;padding-bottom:0px",
                               selectInput("INDICATOR1",NULL,choices=unique(indicator_file$Description),selected="GDP (constant 2010 US$)")
                                 ),
  
                           column(3, 
                                conditionalPanel(
                                  condition = "input.INDICATOR1 != 'Select'",
                                  numericInput("W1",NULL,value=1)
                                                )
                                 ),
                           
                           column(5, 
                                  conditionalPanel(
                                    condition = "input.INDICATOR1 != 'Select'",
                                    h4(textOutput("ind1"), style="margin-top:2%")
                                  )
                                  )
                           
                                 ),
                      # Indicator 2    
                      fluidRow(
                        column(4, #style="margin-top:0px;padding-right:0px;padding-top:0px",
                               selectInput("INDICATOR2",NULL,choices=unique(indicator_file$Description),selected="Select")
                        ),
                        
                        column(3, 
                               conditionalPanel(
                                 condition = "input.INDICATOR2 != 'Select'",
                                 numericInput("W2",NULL,value=1)
                               )
                        ),
                        
                        column(5, 
                               conditionalPanel(
                                 condition = "input.INDICATOR2 != 'Select'",
                                 h4(textOutput("ind2"), style="margin-top:2%")
                               )
                               )
                        
                      
                              ),
                      # Indicator 3
                      fluidRow(
                        column(4,
                               selectInput("INDICATOR3",NULL,choices=unique(indicator_file$Description),selected="Select")
                        ),
                        
                        column(3, 
                               conditionalPanel(
                                 condition = "input.INDICATOR3 != 'Select'",
                                 numericInput("W3",NULL,value=1)
                                               )
                              ),
                        
                        column(5, 
                               conditionalPanel(
                                 condition = "input.INDICATOR3 != 'Select'",
                                 h4(textOutput("ind3"), style="margin-top:2%")
                               )
                               )
                              ),
                      
                      # Indicator 4
                      fluidRow(
                        column(4,
                               selectInput("INDICATOR4",NULL,choices=unique(indicator_file$Description),selected="Select")
                        ),
                        
                        column(3, 
                               conditionalPanel(
                                 condition = "input.INDICATOR4 != 'Select'",
                                 numericInput("W4",NULL,value=1)
                                               )
                              ),
                        
                        column(5, 
                               conditionalPanel(
                                 condition = "input.INDICATOR4 != 'Select'",
                                 h4(textOutput("ind4"), style="margin-top:2%")
                               )
                               )
                        
                        
                              ),
                      
                      # Indicator 5
                      fluidRow(
                        column(4,
                               selectInput("INDICATOR5",NULL,choices=unique(indicator_file$Description),selected="Select")
                               ),
                        
                        column(3, 
                               conditionalPanel(
                                 condition = "input.INDICATOR5 != 'Select'",
                                 numericInput("W5",NULL,value=1)
                                               )   
                              ),
                        
                        column(5, 
                               conditionalPanel(
                                 condition = "input.INDICATOR5 != 'Select'",
                                 h4(textOutput("ind5"), style="margin-top:2%")
                               )
                               )
                        
                              ),
                      
                      # Indicator 6
                      fluidRow(
                        column(4,
                               selectInput("INDICATOR6",NULL,choices=unique(indicator_file$Description),selected="Select")
                        ),
                        column(3, 
                               conditionalPanel(
                                 condition = "input.INDICATOR6 != 'Select'",
                                 numericInput("W6",NULL,value=1)
                                               )
                              ),
                        
                        column(5, 
                               conditionalPanel(
                                 condition = "input.INDICATOR6 != 'Select'",
                                 h4(textOutput("ind6"), style="margin-top:2%")
                               )
                               )
                        
                              ),
                      
                      # Structural data table
                     
                      h4("Structural Comparators"),     

                      radioButtons("RESTRICTION",NULL, choices=c("All"="all","Regional"="region","Landlocked"="landlocked", "Small States"="small"), inline=T, selected="all"),
                           
                      
                      tableOutput("struc_result"),
                      tableOutput("struc_rank"),
                      tableOutput("struc_table"),
                      tableOutput("str_matchind")
                           
                          ),
                  tabPanel("Aspirational Comparators")
                 )
             )
               )
  

  
)

