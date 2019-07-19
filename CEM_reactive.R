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
  ind <- c(input$INDICATOR1,input$INDICATOR2,input$INDICATOR3,input$INDICATOR4,input$INDICATOR5,input$INDICATOR6) %>% sapply(indicator) #%>% unique()
  ind <- ind[!ind=="Select"]
  middle <- subset(data_file, year>=input$YEAR[1] & year<=input$YEAR[2] ,select=c("countryname","iso3","year",ind)) 
  middle <- aggregate(middle, by = list(middle$countryname,middle$iso3), FUN=mean, na.rm=T) 
  result <- middle[,!names(middle) %in% c("iso3","countryname","year")]
  names(result)[1:2] <- c("countryname","iso3")
  result
})


# 2.a match indicator and its weight
struc_match <- reactive({
  data.frame(
    selected = c(indicator(input$INDICATOR1),indicator(input$INDICATOR2),indicator(input$INDICATOR3),indicator(input$INDICATOR4),indicator(input$INDICATOR5),indicator(input$INDICATOR6)),
    weight = c(input$W1,input$W2,input$W3,input$W4,input$W5,input$W6),
    stringsAsFactors = F
  ) %>% subset(selected!="Select")
})


# 2.b create table for the structural ranking
struc_ranking <- reactive({
  struc_rank <- struc_data() %>% mutate(add=1)
  struc_rank[,3:ncol(struc_rank)] <- sapply(struc_rank[,3:ncol(struc_rank)], function(x) rank(-x, na.last="keep")) 
  target <- struc_rank[struc_rank$countryname == input$TARGET,3:ncol(struc_rank)] %>% as.matrix()
  struc_rank[,3:ncol(struc_rank)] <- sweep(struc_rank[,3:ncol(struc_rank)],2, target,"-") %>% sapply(abs)
  #struc_rank <- struc_rank[,!names(struc_rank)=="add"]
  # inser the weight vector
  weight <- c(struc_match()[,"weight"],0)#%>% as.matrix()
  struc_rank[,3:ncol(struc_rank)] <- sweep(struc_rank[,3:ncol(struc_rank)],2, weight,"*")
  struc_rank$weighted_dif <- rowSums(struc_rank[,!names(struc_rank) %in% c("iso3","countryname")],na.rm=T)/sum(weight)
  struc_rank$na_percent <- apply(struc_rank,1, function(x) sum(is.na(x))/length(weight))
  struc_rank$weighted_dif[struc_rank$weighted_dif==0|struc_rank$na_percent>=0.50] <- NA
  # rows with values more than half
  struc_rank$result <- rank(-struc_rank$weighted_dif, na.last = "keep")
  struc_rank 
})

# 2.c structural peers top 10
struc_result <- reactive({
  struc_ranking() %>% arrange(desc(-weighted_dif)) %>% slice(1:10)
})

# 2.d structural indicator average for tartget country
ind1 <- reactive({
  subset(struc_data(),countryname==input$TARGET, select=c(indicator(input$INDICATOR1)))[1,1]
})

ind2 <- reactive({
  subset(struc_data(),countryname==input$TARGET, select=c(indicator(input$INDICATOR2)))[1,1]
})

ind3 <- reactive({
  subset(struc_data(),countryname==input$TARGET, select=c(indicator(input$INDICATOR3)))[1,1]
})

ind4 <- reactive({
  subset(struc_data(),countryname==input$TARGET, select=c(indicator(input$INDICATOR4)))[1,1]
})

ind5 <- reactive({
  subset(struc_data(),countryname==input$TARGET, select=c(indicator(input$INDICATOR5)))[1,1]
})

ind6 <- reactive({
  subset(struc_data(),countryname==input$TARGET, select=c(indicator(input$INDICATOR6)))[1,1]
})


