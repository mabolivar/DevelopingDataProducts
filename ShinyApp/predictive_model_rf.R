#=========================================================
# Libraries
#=========================================================
library(readr)
library(dplyr)
library(caret)
library(randomForest)
source("read_data.R")
#=========================================================

predictive_model_rf <- function(d){

#New variables
d$logarea <- log(d$area) #Area log
d$logarea2 <- log(d$area)^2 #Area log2
d$br <- d$bathr/d$rms #Bath/Rooms
d$ar <- d$area/d$rms #Area/Rooms

#Remove variables
d$area <- NULL
d$published <- NULL

#RandomForest
mf_rf <- randomForest(price ~ .,data=d, mtry=2,ntree=500)

return(mf_rf)
}