# function to label if countries are in the same region (a dummy variable)

# 1 function to find out the group of target country
region <- function(target,group){
  class_file[class_file$Code==target,group]
}

# 2 function to find out the indicator code
indicator <- function(name){
  indicator_file[indicator_file$Description==name, "Name"]
}

sample <- c("gdp", "gdpc", "gdppc", "gdppcc")