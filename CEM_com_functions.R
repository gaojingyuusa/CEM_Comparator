# function to label if countries are in the same region (a dummy variable)

# 1 function to find out the group of target country
region <- function(target,group){
  class_file[class_file$Code==target,group]
}