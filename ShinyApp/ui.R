library(shiny)

shinyUI(fluidPage(
  
  # Application title
  headerPanel("Calculate your desired apartment rent in Bogota, Colombia"),
  p("Using the data published in online classified ads, this app trains a machine learning algorithm to predict the monthly rent for your desired apartment in Bogota, Colombia. For further information about the data or the machine learning algorithm's tuning or accuracy, see the app description below."),
  sidebarPanel(
    p("To calculate your desired apartment rent, you should fill the following options including your desired", strong("neighbourhood"),", ",strong("apartment size")," (in squared meters), number of ",strong("rooms")," and number of ",strong("bathrooms"),"."),
    selectInput("neigh", "Choose a neighbourhood:", 
                choices = sort(c("CHAPINERO", "ROSALES","TEUSAQUILLO",
                                 "QUINTA CAMACHO", "CASTILLO",
                                 "EMAUS", "GALERIAS","NUEVA GRANADA",
                                 "JAVERIANA","MARLY", "PALERMO", "SOLEDAD")),
                selected = "MARLY"),
    numericInput("meters", 
                 "Apartment size (in squared meters):", 
                 min = 25,
                 max = 200, 
                 value = 45),
    sliderInput("rms", 
                "Number of rooms", 
                min = 1,
                max = 5, 
                value = 2),
    sliderInput("bath", 
                "Number of bathrooms:", 
                min = 1,
                max = 5, 
                value = 1),
    p("Additionally, you can adjust the map zoom to see a more detailed view of your desired apartment's neighbourhood."),
    sliderInput("zoom", 
                "Map zoom:", 
                min = 10,
                max = 20, 
                value = 15),
    actionButton("UpdateMapB","Update map zoom")
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    h3("The predicted rent of your desired aparment is:"),
    h4(textOutput("text1")),
    plotOutput("distPlot",width = "600px",height = "600px")
  )
))

