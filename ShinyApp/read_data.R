

read_data <- function(path){
  
  d <- read_csv(path)
  
  #Neighborhood as factor
  d$neigh <- d$neigh %>% as.factor
  #Use only complete cases  
  d <- subset(d,complete.cases(d))
  
  # Remove over valued leases 
  d <- filter(d, price <= 5.00e+06) 
  
  return(d)
}

