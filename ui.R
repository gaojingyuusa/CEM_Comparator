# User interface of CEM country selection website

library(shiny)
library(DT)
library(plotly)
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
                 img(src="wbg_efi.png", height = 50),
                 h3(strong("TARGET COUNTRY"),style="color:#002244"),
                 selectInput("TARGET","STEP 1 Select Target Country",
                             choices=country,"Albania", multiple = F),
                 h4(""),
                 sliderInput("YEAR","STEP 2 Select Period", min=1960, max=2018,value=c(2012,2017)),
                 h4(""),
            #     h5(strong("Profile")),
                 h4(textOutput("country"),style="color:#009FDA"),
                 textOutput("country.region.txt"),
                 textOutput("country.income"),
                 textOutput("country.land"),
                 textOutput("country.small"),
                 textOutput("country.fcs"),
                 h3(strong("STRUCTURAL BREAK"),style="color:#009FDA"),
                 sliderInput("YEAR2","Structural Break Period", min=1981, max=2017,value=c(1981,2017)),
                 h4(" "),
                 h5(textOutput("break_point_txt"), style="color:#009FDA"),
          #       tableOutput("break_point"),
                # tableOutput("break_data"),
                 h4(" "),
                 plotOutput("break_plot",height="200px")
                # checkboxInput("REGION", "Regional Peers", value=FALSE),
                # checkboxInput("LAND", "Landlocked", value=FALSE),
                # checkboxInput("SMALL", "Small States", value=FALSE),
                # checkboxInput("FCS", "Fragile & Conflicted States", value=FALSE)
                ),
    
    # Main Panel: Structural and Aspirational
    mainPanel(
      tabsetPanel(type="tabs",
                  ## Structural Comparators
                  tabPanel("Structural Comparators",
                        #  h3("Find Structural Comparators", style="color:#002244"),
                        #   h3(textOutput("country.txt"), style="color:#009FDA"),
                        #   p("Structural comparators are defined as countries that are similar to the target country in terms of selected indicators."),
                           h5(strong("STEP 3 Select Structural Indicators")),
                      # Title of indicator selections
                         fluidRow(
                           column(4,
                                 "Structural indicators"
                                 ),

                           column(3,
                                  "Weight"
                                 ),
                           
                           column(5,
                                  textOutput("period")
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
                                    h4(textOutput("ind1"), style="margin-top:2%;color:#009FDA")
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
                                 h4(textOutput("ind2"), style="margin-top:2%;color:#009FDA")
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
                                 h4(textOutput("ind3"), style="margin-top:2%;color:#009FDA")
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
                                 h4(textOutput("ind4"), style="margin-top:2%;color:#009FDA")
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
                                 h4(textOutput("ind5"), style="margin-top:2%;color:#009FDA")
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
                                 h4(textOutput("ind6"), style="margin-top:2%;color:#009FDA")
                               )
                               )
                        
                              ),
                      
                      h3("                      "),
                      radioButtons("RESTRICTION","Optional: Select Category", choices=c("All"="all","Regional"="region","Landlocked"="landlocked", "Small States"="small"), inline=T, selected="all"),
                      
                      # Structural data table
                      h3("                      "),
          tabsetPanel(type="tabs",
                      tabPanel("Results",  
                      h4("                      "),
                      h4("Structural Comparators: Top 10 Most Structurally Similar Countries",style="margin-top:20px;color:#009FDA"), 
                      
                      fluidRow(
                        column(3,
                        numericInput("STRUC_TOP","Number of Comparators", value=10, max=200)
                              )
                      ),
                  
               #       radioButtons("RESTRICTION","Select Category", choices=c("All"="all","Regional"="region","Landlocked"="landlocked", "Small States"="small"), inline=T, selected="all"),
                           
                      fluidRow(
                          column(5,
                          tableOutput("struc_result")
                                ),
                          column(6,
                                 plotlyOutput("struc_map")
                                 )
                              ),
               
               
                      p("Note: In descending order of similarity", style="color:grey")
            #          tableOutput("struc_rank"),
           #           tableOutput("struc_table"),
          #            tableOutput("str_matchind")
                      ),
                      tabPanel("Data", 
                      h4("      "),
                      p("Table below contains the actual value of structural indicators per structural comparators, which is the simply average of selected period of years.", style="color:grey"),
                      tableOutput("struc_result_data")     
                      )
                      )
                          ),
          
          
         tabPanel("Aspirational Comparators",
             
             #  h3("Find Aspiratio Comparators", style="color:#002244"),
    #         h3(textOutput("country.txt"), style="color:#009FDA"),
             #   p("Structural comparators are defined as countries that are similar to the target country in terms of selected indicators."),
             h5(strong("STEP 4 Select Aspirational Indicator")),
             # Title of indicator selections
             fluidRow(
               column(4,
                      "Aspirational Indicator"
               ),
               
               column(2,
                      "Rank"
                     # textOutput("period")
               ),
               
               column(2,
                      "Average"
                      # textOutput("period")
               ),
               
               column(2,
                      "Max"
                      # textOutput("period")
               )
                     ),
    
              fluidRow(
               column(4,#style="margin-bottom:0px;padding-right:0px;padding-bottom:0px",
                    selectInput("ASPR",NULL,choices=unique(indicator_file$Description),selected="GDP (constant 2010 US$)")
                     ),
               
               column(2, 
                    conditionalPanel(
                    condition = "input.ASPR != 'Select'",
                    h4(textOutput("aspr_target_rank"), style="margin-top:5%;color:#009FDA")
                                    )
                     ),
               
               column(2, 
                      conditionalPanel(
                        condition = "input.ASPR != 'Select'",
                        h4(textOutput("aspr_target_mean"), style="margin-top:5%;color:#009FDA")
                                      )
                     ),
               
               column(2, 
                      conditionalPanel(
                        condition = "input.ASPR != 'Select'",
                        h4(textOutput("aspr_target_max"), style="margin-top:5%;color:#009FDA")
                                      )
                      )
               
                     ),
               
               # determine by rank or by value
               h4("  "),
               h5(strong("STEP 5 Lower and Upper Bound")),
    
               # set the lower and upper bound numeric input
               fluidRow(
               
               column(2,  
               h5("Lower Rank",style="color:#009FDA")
                     ),
               column(2,
               h5("Upper Rank",style="color:#009FDA")
                     ),
               column(1,
               h4("")       
                      ),
               column(2,  
                      h5("Lower Value",style="color:#002244")
               ),
               column(2,
                      h5("Upper Value",style="color:#002244")
               )
               
               
                       ),
               fluidRow(
               
        
               column(2,
                      numericInput("RANK_L",NULL,value=1, min=1, max=233, step=1)
                     ),

               column(2,
                      numericInput("RANK_U",NULL,value=1, min=1, max=233, step=1)
                     ),
               column(1,
               h4("")
                     ),
               column(2,
                      numericInput("VALUE_L",NULL,value=1, step=1)
               ),
               
               column(2,
                      numericInput("VALUE_U",NULL,value=1, step=1)
               )
                       ),
              
              h3("      "),
              radioButtons("RANKVALUE","STEP 6: Select Criteria", choices=c("By Rank"="rank","By Value"="value"), inline=T, selected="rank"),
              h3("      "), 
      # results and data tabs for aspirational comparators
      tabsetPanel(type="tabs",
                tabPanel("Results",
                          h4("Aspirational Comparators: Top 10 Most Structurally Similar Countries Ahead",style="margin-top:20px;color:#009FDA"),
 #                         radioButtons("RANKVALUE","Select Category", choices=c("By Rank"="rank","By Value"="value"), inline=T, selected="rank"),
                        #  tableOutput("aspr_within_rank")
                          tableOutput("aspr_result"),
                          p("Note: In descending order of similarity", style="color:grey")
             #             plotlyOutput("struc_map")
                        ),
                tabPanel("Data",
                         h4(" "),
                         p("Table below contains the actual value of structural indicators per structural comparators, which is the simply average of selected period of years. Listed countries are countries within selected range only.", style="color:grey"),
                         tableOutput("aspr_result_data")
                        )
                
                 )
    
    
    
    
             #  tableOutput("aspr_data")
    
    
    
             
                 ),
      
        tabPanel("CEM 2.0 Input",
                 
                 # Period selection
                 fluidRow(
                   column(3,
                         h4("Total Period")
                         ),
                   column(3,
                          selectInput("TT_ST","Start", choices=c(1980:2014), 2000)
                         ),
                   column(3,
                          selectInput("TT_ED","End", choices=c(1980:2018), NULL)
                         )
                         ),
                 
                 fluidRow(
                   column(3,
                          h4("Historical Period")
                   ),
                   column(3,
                          textOutput("his_start")
                   ),
                   column(3,
                          selectInput("HS_ED",NULL, choices=c(1980:2018), NULL)
                   )
                 ),
                 
                 fluidRow(
                   column(3,
                          h4("Recent Period")
                   ),
                   column(3,
                          selectInput("RS_ST",NULL, choices=c(1980:2018), NULL)
                   ),
                   column(3,
                          textOutput("recent_end")
                   )
                 ),
             
                 
                 # List of comparators selected
                 
                   # 3 Structural comparators
                 fluidRow(
                 column(4,
                 selectInput("STRUT1","Structural Comparators",
                             choices=unique(data_file$countryname),"China", multiple = F),
                 selectInput("STRUT2",NULL,
                             choices=unique(data_file$countryname),"Albania", multiple = F),
                 selectInput("STRUT3",NULL,
                             choices=unique(data_file$countryname),"Albania", multiple = F)
                 ),
                   # 3 Aspirational comparators
                 column(4,
                 selectInput("ASPR1","Aspirational Comparators",
                             choices=unique(data_file$countryname),"Albania", multiple = F),
                 selectInput("ASPR2",NULL,
                             choices=unique(data_file$countryname),"Albania", multiple = F),
                 selectInput("ASPR3",NULL,
                             choices=unique(data_file$countryname),"Albania", multiple = F)
                 )
                 ),
                 
                   # 3 Typology groups
                 selectInput("TYPO1","Other Groups",
                             choices=unique(typology_list$option),"High income", multiple = F),
                 selectInput("TYPO2",NULL,
                             choices=unique(typology_list$option),"OECD", multiple = F),
                 selectInput("TYPO3",NULL,
                             choices=unique(typology_list$option),"IBRD", multiple = F),
                 
                   # List table
                 tableOutput("normal_result")
                 
                 
        
                )
     
    
    
    
  # DON'T TOUCH PARENTHESIS BELOW THIS LINE  
    
    
                 )
             )
               )
  

  
)

