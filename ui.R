library(shiny)
library(shinydashboard)
library(leaflet)
library(leaflet.extras)
library(plotly)
# Define UI for application that plots random distributions



sidebar <- dashboardSidebar(
  sidebarMenu(
    id = "submenu",
    menuItem(
      "Dashboard",
      tabName = "dashboard",
      icon = icon("dashboard")
    ),
    menuItem(
      "Incidents",
      tabName = "incidents",
      icon = icon("dashboard")
    ),
    menuItem(
      "NoiseVSCity",
      tabName = "region",
      icon = icon("dashboard")
    ),
    menuItem("Treemap", tabName = "treemap", icon = icon("dashboard")),
    menuItem(
      "Weekdaydesc",
      tabName = "weekdaydesc",
      icon = icon("dashboard")
    ),
    menuItem("Cause", tabName = "descriptor", icon = icon("dashboard")),
    menuItem(
      "Heatmap",
      icon = icon("th"),
      tabName = "heatmap",
      badgeLabel = "new",
      badgeColor = "green"
    ),
    menuItem(
      "Heatmap2",
      icon = icon("th"),
      tabName = "heatmap2",
      badgeLabel = "new",
      badgeColor = "green"
    )
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
            }),
    tabItem(tabName = "incidents",
            {
              fluidPage(
                titlePanel("Tabsets"),
                
                
                
                
                sidebarLayout(
                  
                  # Sidebar panel for inputs ----
                  sidebarPanel(
                    
                    # Input: Select the random distribution type ----
                    radioButtons("incidentGroups", "Incidents grouped by:",
                                 c("Borough" = "borough",
                                   "Types" = "types",
                                   "Weekdays" = "weekdays")),
                    
                    # br() element to introduce extra vertical spacing ----
                    br(),
                    
                    # Input: Slider for the number of observations to generate ----
                    dateRangeInput('dateRange',
                                   label = paste('Date range input 2: range is limited,',
                                                 'dd/mm/yy, language: fr, week starts on day 1 (Monday),',
                                                 'separator is "-", start view is year'),
                                   start = Sys.Date() - 3, end = Sys.Date() + 3,
                                   min = Sys.Date() - 10, max = Sys.Date() + 10,
                                   separator = " - ", format = "dd/mm/yy",
                                   startview = 'year', language = 'fr', weekstart = 1
                    )
                    
                  ),
                  
                  # Main panel for displaying outputs ----
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
            leafletOutput("myMap2"))
  )
)


dashboardPage(dashboardHeader(title = "Noise in NYC"),
              sidebar,
              body)
