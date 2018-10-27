library(shiny)
library(shinydashboard)
library(leaflet)
library(leaflet.extras)

# Define UI for application that plots random distributions 
shinyUI(
  dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
    dashboardBody(
      
      
      leafletOutput("myMap")
      
    )
  )
  
  
  
)