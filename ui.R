library(shiny)

# Define UI for application that plots random distributions 
shinyUI(
  fluidPage(
    leafletOutput("mymap"),
    p(),
    actionButton("recalc", "New points")  
  )
)