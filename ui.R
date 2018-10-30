library(shiny)
library(shinydashboard)
library(leaflet)
library(leaflet.extras)
library(plotly)
# Define UI for application that plots random distributions



sidebar <- dashboardSidebar(
  sidebarMenu(id="submenu",
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Treemap", tabName = "treemap", icon = icon("dashboard")),
    menuItem("Weekday", tabName = "weekday", icon = icon("dashboard")),
    menuItem("Weekdaydesc", tabName = "weekdaydesc", icon = icon("dashboard")),    
    menuItem("region", tabName = "region", icon = icon("dashboard")),        
    menuItem("Heatmap", icon = icon("th"), tabName = "heatmap",
             badgeLabel = "new", badgeColor = "green")
  )
)

body <- dashboardBody(
  tags$style(type = "text/css", "#myMap {height: calc(100vh - 80px) !important;}"),
  tabItems(
    tabItem(tabName = "dashboard",
            {
              verbatimTextOutput("summary")
            }
    ),    
    tabItem(tabName = "treemap",
                  {
                    plotOutput("treemap")
                  }
    ),
    tabItem(tabName = "weekday",
            {
              plotlyOutput("weekday")
            }
    ),
    tabItem(tabName = "weekdaydesc",
            {
              plotOutput("weekdaydesc")
            }
    ),
    tabItem(tabName = "region",
            {
              plotlyOutput("region")
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
