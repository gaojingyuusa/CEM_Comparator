
normal_result <- reactive({
  
## Individual comparators
# Retrieve individual comparators + target country list
basis_inv <- final_list()[1:7,]

# Loop to retrieve and append individual comparator's data with new identifier
normal_inv <- data.frame()
for (i in seq_along(basis_inv$isocode)){
  repl <- subset(normal_dt, ISO == basis_inv$isocode[i] & Year >=2005 & Year <= 2010) %>% 
    mutate(identifier=paste0(basis_inv$isocode[i],"_",basis_inv$group[i])) %>% 
    select(-Source, -ISO) 
  normal_inv <- rbind(normal_inv,repl)
}

## Aggregate 3 typologies
# Define a function to do the trick
typ_cal <-function(test, start, end){
  typo_iso <- final_list()$isocode[final_list()$group==test]
  sub_tp <- subset(normal_dt, ISO %in% typo_iso & Year >=start & Year <= end) 
  sub_tp <- aggregate(x=sub_tp$value, by=list(sub_tp$Year, sub_tp$Indicator), FUN=mean, na.rm=T)
  names(sub_tp) <- c("Year", "Indicator", "value")
  sub_tp$identifier <- test
  sub_tp}

# Loop to retrieve, transform and append aggregated typology group data
normal_typ <- data.frame()
basis_typ <- unique(final_list()$group[8:nrow(final_list())])
for (j in basis_typ){
  repl <- typ_cal(j, 2005, 2010)
  normal_typ <- rbind(normal_typ, repl)
}


## Append individual and typology
# From long to wide with column names stored
full <- rbind(normal_inv, normal_typ) %>% spread(identifier, value)
# Reorder the name in the following order: Target, Stuc1, Stuc2, Stuc3, Aspr1, Aspr2, Aspr3, Typo1, Typo2, Typo3
ordername <- names(full)
full <- full[c("Indicator","Year",
               ordername[grep("Target",ordername)],
               ordername[grep("Stuc_1",ordername)],
               ordername[grep("Stuc_2",ordername)],
               ordername[grep("Stuc_3",ordername)],
               ordername[grep("Aspr_1",ordername)],
               ordername[grep("Aspr_2",ordername)],
               ordername[grep("Aspr_3",ordername)],
               ordername[grep(basis_typ[1],ordername)],
               ordername[grep(basis_typ[2],ordername)],
               ordername[grep(basis_typ[3],ordername)]
)]

## Output the table of normal data
basis_inv
})