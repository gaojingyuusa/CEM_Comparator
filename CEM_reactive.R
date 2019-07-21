# this script stores all reactive elements for the shiny app

# 1 reactive component of target country group

country <- reactive({
  input$TARGET
})

country.region <- reactive({
  region(data_file[data_file$countryname==input$TARGET %>% unique,"iso3"],"Region")
})

  country.region.txt <- reactive({
    paste("Region:",region(data_file[data_file$countryname==input$TARGET %>% unique,"iso3"],"Region"))
  })
  
  period <- reactive({
    paste0(input$TARGET," ",input$YEAR[1],"-",input$YEAR[2]," Mean")
  })

# 1.a reactive component of target country income
country.income <- reactive({
  region(data_file[data_file$countryname==input$TARGET %>% unique,"iso3"],"Income.group")
})

# 1.b reactive component of target country landlocked
country.landlocked <- reactive({
  paste("Landlocked:",ifelse(region(data_file[data_file$countryname==input$TARGET,"iso3"] %>% unique,"landlocked")==1,"Landlocked","Not Landlocked"))
})

# 1.c reactive component of target country smallstates
country.small <- reactive({
  paste("Small States:",ifelse(region(data_file[data_file$countryname==input$TARGET,"iso3"] %>% unique,"smallstates")==1,"Small state","Not small state"))
})

# 1.d reactive component of target country smallstates
country.fcs <- reactive({
  paste("Fragile & Conflicted States:",ifelse(region(data_file[data_file$countryname==input$TARGET,"iso3"] %>% unique,"fcs")==1,"FCS","Not FCS"))
})


# 2 Structural: reactive dataset selected by the user
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
  struc_rank$weighted_dif[struc_rank$weighted_dif==0|struc_rank$na_percent>=0.40] <- NA
  # rows with values more than half
  struc_rank$result <- rank(-struc_rank$weighted_dif, na.last = "keep")
  struc_rank 
})

# 2.c structural peers top 10
struc_result <- reactive({
    full <- merge(class_file, struc_ranking(),by.x="Code", by.y="iso3")
  if(input$RESTRICTION=="all"){
    full <- full
  } else if (input$RESTRICTION=="small"){
    full <- full[full$smallstates==1,]
  } else if (input$RESTRICTION=="region"){
    full <- full[full$Region==country.region() & !is.na(full$weighted_dif),]
  } else if (input$RESTRICTION=="fcs"){
    full <- full[full$fcs==1,]
  }
  
  struc_list <- full %>% arrange(desc(-weighted_dif)) %>% slice(1:10) %>% select(Code, weighted_dif)
  temp <- subset(struc_data(),iso3 %in% struc_list$Code)
  merge(temp, struc_list, by.x="iso3", by.y="Code") %>% arrange(desc(-weighted_dif)) %>% select(-weighted_dif)
  #merge(temp,struc_list, by.x=Code, by.y=iso3)
  #struc_data()[struc_data()$iso3 %in% struc_list[[1]],]
  #full %>% arrange(desc(-weighted_dif)) %>% slice(1:10) %>% select(Code)
  #select(-Region, -Income.group, -landlocked, - smallstates, -fcs, - add, -weighted_dif, - na_percent, - result)
})

# 2.d structural indicator average for tartget country
ind1 <- reactive({
  subset(struc_data(),countryname==input$TARGET, select=c(indicator(input$INDICATOR1)))[1,1] %>% round(2)
})

ind2 <- reactive({
  subset(struc_data(),countryname==input$TARGET, select=c(indicator(input$INDICATOR2)))[1,1] %>% round(2)
})

ind3 <- reactive({
  subset(struc_data(),countryname==input$TARGET, select=c(indicator(input$INDICATOR3)))[1,1] %>% round(2)
})

ind4 <- reactive({
  subset(struc_data(),countryname==input$TARGET, select=c(indicator(input$INDICATOR4)))[1,1] %>% round(2)
})

ind5 <- reactive({
  subset(struc_data(),countryname==input$TARGET, select=c(indicator(input$INDICATOR5)))[1,1] %>% round(2)
})

ind6 <- reactive({
  subset(struc_data(),countryname==input$TARGET, select=c(indicator(input$INDICATOR6)))[1,1] %>% round(2)
})


# 3 As[pirational: reactive dataset selected by the user

# 3.a aspirarional indicator data table
aspr_data <- reactive({
  middle <- subset(data_file, year>=input$YEAR[1] & year<=input$YEAR[2] ,select=c("countryname","iso3","year",indicator(input$ASPR))) 
  middle <- aggregate(middle, by = list(middle$countryname,middle$iso3), FUN=mean, na.rm=T) 
  result <- middle[,!names(middle) %in% c("iso3","countryname","year")]
  names(result)[1:2] <- c("countryname","iso3")
  result$rank <- rank(-result[,3], na.last="keep") %>% as.integer()
  result
})

# 3.b ranking of aspirational indicator data table
# aspr_rank <- reactive({
# aspr_rank <- aspr_data() 
# aspr_rank[,3] <- rank(-aspr_rank[,3], na.last="keep")
#  aspr_rank
# })

# 3.c mean and ranking of target country in aspirational indicator
 # mean
aspr_target_mean <- reactive({
  subset(aspr_data(),countryname==input$TARGET, select=c(indicator(input$ASPR)))[1,1] %>% round(2)
})
 # rank
aspr_target_rank <- reactive({
  subset(aspr_data(),countryname==input$TARGET, select=c("rank"))[1,1] 
})
 # max
aspr_target_max <- reactive({
  max(subset(aspr_data(),select=c(indicator(input$ASPR)))[[1]],na.rm=T)
})


