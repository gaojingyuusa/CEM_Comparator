

# Normal indicators that can be filtered by full range of years and comparators
normal_result <- reactive({
  
## Individual comparators
# Retrieve individual comparators + target country list
basis_inv <- final_list()[1:7,]

# Normal: Loop to retrieve and append individual comparator's data with new identifier
normal_inv <- data.frame()
for (i in seq_along(basis_inv$isocode)){
  repl <- subset(normal_dt, ISO == basis_inv$isocode[i] & Year >=input$TT_ST & Year <= input$TT_ED) %>% 
    mutate(identifier=paste0(basis_inv$isocode[i],"_",basis_inv$group[i])) %>% 
    select(-Source, -ISO) 
  normal_inv <- rbind(normal_inv,repl)
}

# Fixed year: Loop to retrieve and append individual comparator's data with new identifier
fixed_inv <- data.frame()
for (i in seq_along(basis_inv$isocode)){
  repl <- subset(fixed_dt, ISO == basis_inv$isocode[i]) %>% 
    mutate(identifier=paste0(basis_inv$isocode[i],"_",basis_inv$group[i])) %>% 
    select(-Source, -ISO) 
  fixed_inv <- rbind(fixed_inv,repl)
}

# End year:  Loop to retrieve and append individual comparator's data with new identifier
end_inv <- data.frame()
for (i in seq_along(basis_inv$isocode)){
  repl <- subset(end_dt, ISO == basis_inv$isocode[i]) %>% 
    mutate(identifier=paste0(basis_inv$isocode[i],"_",basis_inv$group[i])) %>% 
    select(-Source, -ISO) 
  end_inv <- rbind(end_inv,repl)
}



## Aggregate 3 typologies

# Normal: Define a function to do the trick
typ_cal <-function(test, start, end){
  typo_iso <- final_list()$isocode[final_list()$group==test]
  sub_tp <- subset(normal_dt, ISO %in% typo_iso & Year >=start & Year <= end) 
  sub_tp <- aggregate(x=sub_tp$value, by=list(sub_tp$Year, sub_tp$Indicator), FUN=mean, na.rm=T)
  names(sub_tp) <- c("Year", "Indicator", "value")
  sub_tp$identifier <- test
  sub_tp}

# Normal: Loop to retrieve, transform and append aggregated typology group data
normal_typ <- data.frame()
basis_typ <- unique(final_list()$group[8:nrow(final_list())])
for (j in basis_typ){
  repl <- typ_cal(j, input$TT_ST, input$TT_ED)
  normal_typ <- rbind(normal_typ, repl)
}


# End: Define a function to do the trick
typ_cal_end <-function(test, end){
  typo_iso <- final_list()$isocode[final_list()$group==test]
  sub_tp <- subset(end_dt, ISO %in% typo_iso & Year == end) 
  # if sub_tp has zero, which means there is no data for this year, we should skip the following aggregation process
  if(nrow(sub_tp)==0){
    subtp <- data.frame()
  } else {
  
  sub_tp <- aggregate(x=sub_tp$value, by=list(sub_tp$Year, sub_tp$Indicator), FUN=mean, na.rm=T)
  names(sub_tp) <- c("Year", "Indicator", "value")
  sub_tp$identifier <- test
  }
  sub_tp
  }


# End year: Loop to retrieve, transform and append aggregated typology group data
end_typ <- data.frame()
basis_typ <- unique(final_list()$group[8:nrow(final_list())])
for (j in basis_typ){
  repl <- typ_cal_end(j, input$TT_ED)
  end_typ <- rbind(end_typ, repl)
}



# Fixed year: Loop to retrieve, transform and append aggregated typology group data
# Define a function to do the trick
typ_cal_fixed <-function(test){
  typo_iso <- final_list()$isocode[final_list()$group==test]
  sub_tp <- subset(fixed_dt, ISO %in% typo_iso) 
  sub_tp <- aggregate(x=sub_tp$value, by=list(sub_tp$Year, sub_tp$Indicator), FUN=mean, na.rm=T)
  names(sub_tp) <- c("Year", "Indicator", "value")
  sub_tp$identifier <- test
  sub_tp}

# Normal: Loop to retrieve, transform and append aggregated typology group data
fixed_typ <- data.frame()
basis_typ <- unique(final_list()$group[8:nrow(final_list())])
for (j in basis_typ){
  repl <- typ_cal_fixed(j)
  fixed_typ <- rbind(fixed_typ, repl)
}




## Append individual and typology
# From long to wide with column names stored
full <- rbind(normal_inv, normal_typ, fixed_inv, fixed_typ, end_inv, end_typ) %>% spread(identifier, value)
# Reorder the name in the following order: Target, Struc1, Struc2, Struc3, Aspr1, Aspr2, Aspr3, Typo1, Typo2, Typo3
ordername <- names(full)
full <- full[c("Indicator","Year",
               ordername[grep("Target",ordername)],
               ordername[grep("Struc_1",ordername)],
               ordername[grep("Struc_2",ordername)],
               ordername[grep("Struc_3",ordername)],
               ordername[grep("Apsr_1",ordername)],
               ordername[grep("Apsr_2",ordername)],
               ordername[grep("Apsr_3",ordername)],
               ordername[grep(basis_typ[1],ordername)],
               ordername[grep(basis_typ[2],ordername)],
               ordername[grep(basis_typ[3],ordername)])]







## Output the table of normal data
full
})













