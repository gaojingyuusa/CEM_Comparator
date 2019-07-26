
# Deal with CEM Master file that contains everything needed for the tool
library(tidyr)
# Importing data from csv
master_file <- read.csv("Micro_Master.csv")
master_file$var <- NULL
names(master_file)[1] <- "Indicator"
master_file$value <- as.numeric(as.character(master_file$value))
master_file$Year <- as.integer(master_file$Year)

# Abnormal data filter
src <- c("WMS","HCI","GSMA","BTI","EIU","DB","CPI","GFIN")
indc <- c("HK_5","HK_6","ICT_5",
          "ICT_6","ICT_7","ICT_8","ICT_9","ICT_13","ICT_10","ICT_11","ICT_12","INV_4",
          "INV_5","INV_6","INV_8",
          "CEP_4","CMP_5","CMP_6",
          "FIN_58", "FIN_59","FIN_60","FIN_61","FIN_62", "FDI_12")

# Normal data subset
normal_dt <- subset(master_file, !(Source %in% src) & !(Indicator %in% indc))




# Test data query from data

# Comparators+Target
isocode <- c("CHN", "JPN", "USA", "CHL", "BRA", "RUS", "IND", "IDN", "MYS", "MEX", "COL", "SGP","KOR")
group <- c("Target", "Stuc_1","Stuc_2","Stuc_3","Aspr_1","Aspr_2","Aspr_3","High income","High income","ASEAN","ASEAN","OECD","OECD")
basis <- data.frame(
  isocode = isocode,
  group = group,
  stringsAsFactors = F
)

# Subset user defined data
normal_inv <- subset(normal_dt, ISO %in% basis$isocode[1:7] & Year >=2005 & Year <= 2010) %>% select(-Source)


# Subset and aggregate 3 typologies
 # Define a function to do the trick
 test <- unique(basis$group[8:nrow(basis)])[1]

 
 typ_cal <-function(test, start, end){
 typo_iso <- basis$isocode[basis$group==test]
 sub_tp <- subset(normal_dt, ISO %in% typo_iso & Year >=start & Year <= end) 
 sub_tp <- aggregate(x=sub_tp$value, by=list(sub_tp$Year, sub_tp$Indicator), FUN=mean, na.rm=T)
 names(sub_tp) <- c("Year", "Indicator", "value")
 sub_tp$ISO <- test
 sub_tp
 }
 
 result <- typ_cal("OECD", 2005, 2010)
 
 full <- rbind(sub_tp, normal_inv) %>% spread(ISO, value)
