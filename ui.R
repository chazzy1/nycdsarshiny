library(shiny)
library(shinydashboard)
library(leaflet)
library(leaflet.extras)
library(plotly)
# Define UI for application that plots random distributions



sidebar <- dashboardSidebar(
  sidebarMenu(id="submenu",
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("NoiseVSCity", tabName = "region", icon = icon("dashboard")),     
    menuItem("Treemap", tabName = "treemap", icon = icon("dashboard")),
    menuItem("Weekdaydesc", tabName = "weekdaydesc", icon = icon("dashboard")),    
    menuItem("Cause", tabName = "descriptor", icon = icon("dashboard")),
    menuItem("Heatmap", icon = icon("th"), tabName = "heatmap",
             badgeLabel = "new", badgeColor = "green"),
    menuItem("Heatmap2", icon = icon("th"), tabName = "heatmap2",
             badgeLabel = "new", badgeColor = "green")
  )
)

body <- dashboardBody(
  tags$style(type = "text/css", "#treemap {height: calc(100vh - 80px) !important;}"),
  tags$style(type = "text/css", "#weekday {height: calc(100vh - 80px) !important;}"),
  tags$style(type = "text/css", "#region {height: calc(100vh - 80px) !important;}"),
  tags$style(type = "text/css", "#weekdaydesc {height: calc(100vh - 80px) !important;}"),
  tags$style(type = "text/css", "#myMap {height: calc(100vh - 80px) !important;}"),
  tags$style(type = "text/css", "#myMap2 {height: calc(100vh - 80px) !important;}"),
  tags$style(type = "text/css", "#descriptor {height: calc(100vh - 80px) !important;}"),
  tabItems(
    tabItem(tabName = "dashboard",
            {
              verbatimTextOutput("summary")
            }
    ),
    tabItem(tabName = "region",
            {
              plotlyOutput("region")
            }
    ),        
    tabItem(tabName = "treemap",
                  {
                    plotOutput("treemap")
                  }
    ),
    tabItem(tabName = "weekdaydesc",
            {
              plotOutput("weekdaydesc")
            }
    ),    
    tabItem(tabName = "descriptor",
            {
              plotlyOutput("descriptor")
            }
    ),
    tabItem(tabName = "heatmap",
            leafletOutput("myMap")
            
    ),
    tabItem(tabName = "heatmap2",
            leafletOutput("myMap2")
            
    )
  )
)


dashboardPage(
  dashboardHeader(title = "Noise in NYC"),
  sidebar,
  body
)
