# this script stores all reactive elements for the shiny app

# 1 reactive component of target country group
country.region <- reactive({
  region(data_file[data_file$countryname==input$TARGET %>% unique,"iso3"],"Region")
})

# 2 reactive component of target country income
country.income <- reactive({
  region(data_file[data_file$countryname==input$TARGET %>% unique,"iso3"],"Income.group")
})

# 3 reactive component of target country landlocked
country.landlocked <- reactive({
  ifelse(region(data_file[data_file$countryname==input$TARGET,"iso3"] %>% unique,"landlocked")==1,"Landlocked","Not Landlocked")
})

# 4 reactive component of target country smallstates
country.small <- reactive({
  ifelse(region(data_file[data_file$countryname==input$TARGET,"iso3"] %>% unique,"smallstates")==1,"Small state","Not small state")
})

# 5 reactive component of target country smallstates
country.fcs <- reactive({
  ifelse(region(data_file[data_file$countryname==input$TARGET,"iso3"] %>% unique,"fcs")==1,"FCS","Not FCS")
})