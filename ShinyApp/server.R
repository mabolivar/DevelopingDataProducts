library(shiny)
library(ggplot2)
library(ggmap)
library(readr)
library(dplyr)
source("read_data.R")
source("predictive_model_rf.R")

#Read data form the server
d <- read_data("./data/tidy.csv")
pred_model <- predictive_model_rf(as.data.frame(d))

#Define server logic 
shinyServer(function(input, output) {

  output$text1 <- renderText({ 
    #New data
    info <- data.frame(price=0,neigh=input$neigh, bathr=input$bath, 
                       rms=input$rms,
                       logarea = log(input$meters), 
                       logarea2=log(input$meters)^2,stringsAsFactors = F)
    info$br <- info$bathr/info$rms
    info$ar <- input$meters/info$rms
    info$neigh <- factor(info$neigh,levels =levels(d$neigh))
    
    #Prediction
    rent <- predict(pred_model,newdata=info)
    return(paste("$",format(rent,digits=0,scientific = F,big.mark = ","),
                 " COP/month or $",format(rent/3000,digits=0,scientific = F,big.mark = ","),"USD/month"))
  })
  #Neighbourhood map
  output$distPlot <- renderPlot({
    input$UpdateMapB
    getMap <- get_map(paste(input$neigh,", Bogota, Colombia",sep=""),zoom=isolate(input$zoom))
    ggmap(getMap,extent = "panel")+ylab("Latitude")+xlab("Longitude")
  })
})
