library(shiny)
library(shinydashboard)
library(leaflet)
library(leaflet.extras)
library(plotly)
library(DT)
# Define UI for application that plots random distributions



sidebar <- dashboardSidebar(
  sidebarMenu(
    id = "submenu",
    menuItem(
      "Incidents",
      tabName = "incidents",
      icon = icon("dashboard")
    ),
    menuItem("Treemap", tabName = "treemap", icon = icon("dashboard")),
    menuItem(
      "Heatmap",
      icon = icon("th"),
      tabName = "heatmap"
    ),
    menuItem(
      "Heatmap2",
      icon = icon("th"),
      tabName = "heatmap2"
    ),
    menuItem(
      "NoiseTracker",
      icon = icon("th"),
      tabName = "NoiseTracker",
      badgeLabel = "App!!!",
      badgeColor = "green"
    )
  )
)

body <- dashboardBody(
  tags$style(type = "text/css", "#treemap {height: calc(100vh - 80px) !important;}"),
  tags$style(type = "text/css", "#weekday {height: calc(100vh - 80px) !important;}"),
  tags$style(type = "text/css", "#incidentPlot {height: calc(100vh - 160px) !important;}"),
  tags$style(type = "text/css", "#incidentPlotly {height: calc(100vh - 160px) !important;}"),
  tags$style(type = "text/css", "#weekdaydesc {height: calc(100vh - 80px) !important;}"),
  tags$style(type = "text/css", "#myMap {height: calc(100vh - 80px) !important;}"),
  tags$style(type = "text/css", "#myMap2 {height: calc(100vh - 80px) !important;}"),
  tags$style(type = "text/css", "#descriptor {height: calc(100vh - 80px) !important;}"),
  tabItems(
    tabItem(tabName = "dashboard",
            {
              verbatimTextOutput("summary")
            }),
    tabItem(tabName = "incidents",
            {
              fluidPage(
                titlePanel("Noise Incidents"),
                
                
                
                
                sidebarLayout(
                  
                  sidebarPanel(
                    
                    radioButtons("incidentGroups", "Incidents grouped by:",
                                 c("Borough" = "borough",
                                   "Types" = "types",
                                   "Weekdays" = "weekdays")),
                    
                    br(),
                    
                    dateRangeInput('dateRange',
                                   label = paste('Incidents between'),
                                   start = Sys.Date() - 30, end = Sys.Date(),
                                   min = Sys.Date() - 31, max = Sys.Date() + 1,
                                   separator = " - ", format = "dd/mm/yy",
                                   startview = 'month', language = 'en', weekstart = 1
                    )
                    
                  ),
                  
                  mainPanel(

                    conditionalPanel("input.incidentGroups == 'weekdays'",
                                     plotOutput("incidentPlot")
                    ),
                    conditionalPanel("input.incidentGroups == 'types' || input.incidentGroups == 'borough'",
                                     plotlyOutput("incidentPlotly")
                    )                    
                  )
                
                
                
                
                )
                
                
                
                
                
                
                
                
                
                
              )
            }),
    
    tabItem(tabName = "region",
            {
              plotlyOutput("region")
            }),
    tabItem(tabName = "treemap",
            {
              plotOutput("treemap")
            }),
    tabItem(tabName = "weekdaydesc",
            {
              plotOutput("weekdaydesc")
            }),
    tabItem(tabName = "descriptor",
            {
              plotlyOutput("descriptor")
            }),
    tabItem(tabName = "heatmap",
            leafletOutput("myMap")),
    tabItem(tabName = "heatmap2",
            leafletOutput("myMap2")),
    
    
    tabItem(tabName = "NoiseTracker",

            
            {
              fluidPage(
                titlePanel("Party Noise Tracker"),
                
                fluidRow(
                  
                  sliderInput("ndays", "last (n) days:",
                              min = 1, max = 30,
                              value = 1, step = 1,
                              animate =TRUE)
                  
                  
                ),
                
               fluidRow(
                 

                 leafletOutput("ndaysMap")
                 
                 
                 
               ),
                
                
               
               fluidRow(
                 
                 dataTableOutput("ndaysDT")
                 
                 
               )
                
                
               
                
                
                
                
                
                
                
              )
            }            
            
            
            
            
            
            )    
    
    
  )
)


dashboardPage(dashboardHeader(title = "Noise in NYC"),
              sidebar,
              body)
