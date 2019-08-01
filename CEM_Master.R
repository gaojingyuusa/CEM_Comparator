
# Deal with CEM Master file that contains everything needed for the tool
library(tidyr)
library(stringr)
# Importing data from csv
master_file <- read.csv("Micro_Master.csv")
master_file$var <- NULL
names(master_file)[1] <- "Indicator"
master_file$value <- as.numeric(as.character(master_file$value))
master_file$Year <- as.integer(master_file$Year)

# Abnormal data filter
src <- c("WMS","HCI","GSMA","BTI","EIU","DB","CPI","GFIN","BL")
indc <- c("HK_5","HK_6","ICT_5",
          "ICT_6","ICT_7","ICT_8","ICT_9","ICT_13","ICT_10","ICT_11","ICT_12","INV_4",
          "INV_5","INV_6","INV_8",
          "CEP_4","CMP_5","CMP_6",
          "FIN_58", "FIN_59","FIN_60","FIN_61","FIN_62", "FDI_12")

# Normal data subset
normal_dt <- subset(master_file, !(Source %in% src) & !(Indicator %in% indc))


# Fixed year data subset: where indicators for a fixed year are needed

fixed_dt <- subset(master_file, 
                   # WMS = 2014
                   (Source == "WMS" & Year == 2014)|
                   (Source == "HCI" & Year == 2019)|
                   (Source == "BL" & Year == 2010)|
                   (Source == "EIU" & Year == 2018)|
                   (Source == "GFIN" & Year == 2017)|
                   (Indicator %in% c("HK_5","HK_6") & Year == 2017)
                   )


# 



















# Test data query from data

# Comparators+Target
isocode <- c("CHN", "JPN", "USA", "CHL", "BRA", "RUS", "CHL", "IDN", "MYS", "MEX", "COL", "SGP","KOR")
group <- c("Target", "Stuc_1","Stuc_2","Stuc_3","Aspr_1","Aspr_2","Aspr_3","High income","High income","ASEAN","ASEAN","OECD","OECD")

basis <- data.frame(
  isocode = isocode,
  group = group,
  stringsAsFactors = F
)

# Subset user defined data


## Individual comparators
basis_inv <- basis[1:7,]
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
 typo_iso <- basis$isocode[basis$group==test]
 sub_tp <- subset(normal_dt, ISO %in% typo_iso & Year >=start & Year <= end) 
 sub_tp <- aggregate(x=sub_tp$value, by=list(sub_tp$Year, sub_tp$Indicator), FUN=mean, na.rm=T)
 names(sub_tp) <- c("Year", "Indicator", "value")
 sub_tp$identifier <- test
 sub_tp}
 
 # run a loop to do the trick
normal_typ <- data.frame()
basis_typ <- unique(basis$group[8:nrow(basis)])

for (j in basis_typ){
  repl <- typ_cal(j, 2005, 2010)
  normal_typ <- rbind(normal_typ, repl)
}


## Append all data together
 full <- rbind(normal_inv, normal_typ) %>% spread(identifier, value)
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
 
 
 
 