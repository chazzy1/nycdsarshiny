library(shiny)
library(shinydashboard)
library(leaflet)
library(leaflet.extras)

# Define UI for application that plots random distributions





sidebar <- dashboardSidebar(
  sidebarMenu(id="submenu",
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Heatmap", icon = icon("th"), tabName = "heatmap",
             badgeLabel = "new", badgeColor = "green")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "dashboard",
            {
              verbatimTextOutput("summary")
            }
    ),
    
    tabItem(tabName = "heatmap",
            leafletOutput("myMap")
            
    )
  )
)


dashboardPage(
  dashboardHeader(title = "Simple tabs"),
  sidebar,
  body
)
