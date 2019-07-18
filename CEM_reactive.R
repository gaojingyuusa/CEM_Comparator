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

# 2 reactive dataset selected by the user
struc_data <- reactive({
  # convert to short name
  ind <- c(input$INDICATOR1,input$INDICATOR2,input$INDICATOR3,input$INDICATOR4,input$INDICATOR5,input$INDICATOR6) %>% sapply(indicator) %>% unique()
  ind <- ind[!ind=="Select"]
  middle <- subset(data_file, year>=input$YEAR[1] & year<=input$YEAR[2] ,select=c("iso3","year",ind)) 
  middle <- aggregate(middle, by = list(middle$iso3), FUN=mean, na.rm=T) 
  result <- middle[,!names(middle) %in% c("iso3","year")]
  result
})

# 2.a match indicator and its weight
struc_match <- reactive({
  data.frame(
    selected = c(input$INDICATOR1,input$INDICATOR2,input$INDICATOR3,input$INDICATOR4,input$INDICATOR5,input$INDICATOR6),
    weight = c(input$W1,input$W2,input$W3,input$W4,input$W5,input$W6),
    stringsAsFactors = F
  )
})
