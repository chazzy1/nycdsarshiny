library(shiny)
library(leaflet)
library(leaflet.extras)
library(ggplot2)
library(dplyr)
library(tidyr)
library(treemapify)
library(plotly)
#library(treemap)

noisedata <-
  read.csv(file = "data/311_Noise_Complaints_last_month.csv",
           header = TRUE,
           sep = ",")


shinyServer(function(input, output, session) {
  values <- reactiveValues()
  values$isNoisedataLoaded <- FALSE
  values$isNoisedataLoaded2 <- FALSE
  output$summary <- renderPrint({
    print("Ready")
  })
  
  output$summary1 <- renderPrint({
    print("Ready")
  })
  

  

  
  
  
  
  
  
  output$incidentPlotly <- renderPlotly({
    
    
    
    if (input$incidentGroups == "types"){
      noiseSimpledata <- noisedata %>%
        select(Created.Date, Descriptor)
      
      noiseSimpledata$date <- as.Date(noiseSimpledata$Created.Date, format = "%m/%d/%Y %I:%M:%S %p")
      
      noiseSimpledata$weekdayf <- factor(format(noiseSimpledata$date, format="%a"))
      
      head(noiseSimpledata)
      
      noisedataDescSum <- noiseSimpledata %>%
        group_by(Descriptor) %>%
        summarise(incidentCount = n())
      
      barplot <- ggplot(noisedataDescSum, aes(x = reorder(Descriptor, -incidentCount), y=incidentCount, fill=Descriptor))
      barplot + geom_bar(width = 1, stat="identity") 
      
      
    } else if (input$incidentGroups == "borough"){
      noisebyborough <-
        read.csv(file = "data/noisebycity.csv",
                 header = TRUE,
                 sep = ",")
      
      
      barplot <- ggplot(noisebyborough, aes(x = reorder(City, -incidentCount), y=incidentCount, fill=City))
      barplot + geom_bar(width = 1, stat="identity") +
        theme(     legend.position="none")
      
      
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
  })
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  output$incidentPlot <- renderPlot({
    


    if (input$incidentGroups == "weekdays"){
      dateRange <- input$dateRange
      print(dateRange)
      print(dist)
      
    noiseSimpledata <- noisedata %>%
      select(Created.Date, Descriptor)
    Sys.setlocale("LC_TIME", "en_US.UTF-8")
    noiseSimpledata$date <- as.Date(noiseSimpledata$Created.Date, format = "%m/%d/%Y %I:%M:%S %p")
    noiseSimpledata$weekdayf <- factor(format(noiseSimpledata$date, format="%a"))
    
    noisedataWeekdayDescSum <- noiseSimpledata %>%
      filter(noiseSimpledata$Descriptor == "Loud Music/Party" | 
               noiseSimpledata$Descriptor == "Noise: Construction Before/After Hours (NM1)" | 
               noiseSimpledata$Descriptor == "Banging/Pounding" | 
               noiseSimpledata$Descriptor == "Loud Talking" | 
               noiseSimpledata$Descriptor == "Car/Truck Music" | 
               noiseSimpledata$Descriptor == "Noise: Construction Equipment (NC1)" | 
               noiseSimpledata$Descriptor == "Car/Truck Horn" 
      ) %>%
      group_by(Descriptor, weekdayf) %>%
      summarise(incidentCount = n())
    
    noisedataWeekdayDescSum$weekdayf <- factor(noisedataWeekdayDescSum$weekdayf, levels = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"))
    
    ggplot(noisedataWeekdayDescSum, aes(x=weekdayf)) + 
      geom_line(aes(y=incidentCount,  colour=Descriptor, group=Descriptor),stat="identity", size=2) 
    
    }
    
    
    
  })
  
  
  output$dateText  <- renderText({
    paste("input$date is", as.character(input$date))
  })
  
  output$dateText2 <- renderText({
    paste("input$date2 is", as.character(input$date2))
  })
  
  output$dateRangeText  <- renderText({
    paste("input$dateRange is", 
          paste(as.character(input$dateRange), collapse = " to ")
    )
  })
  
  output$dateRangeText2 <- renderText({
    paste("input$dateRange2 is", 
          paste(as.character(input$dateRange2), collapse = " to ")
    )
  })  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
    
  
  
  output$treemap <- renderPlot({
    noiseTreemap <- noisedata %>%
      group_by(Complaint.Type, Descriptor) %>%
      summarise(incidentCount = n())
    
    ggplot(noiseTreemap, aes(area = incidentCount, fill = incidentCount, label = Descriptor,
                          subgroup = Complaint.Type)) +
      geom_treemap() +
      geom_treemap_subgroup_border() +
      geom_treemap_subgroup_text(place = "centre", grow = T, alpha = 0.5, colour =
                                   "black", fontface = "italic", min.size = 0) +
      geom_treemap_text(colour = "white", place = "topleft", reflow = T)
    
  })
  
  output$descriptor <- renderPlotly({

    noiseSimpledata <- noisedata %>%
      select(Created.Date, Descriptor)
    
    noiseSimpledata$date <- as.Date(noiseSimpledata$Created.Date, format = "%m/%d/%Y %I:%M:%S %p")
    
    noiseSimpledata$weekdayf <- factor(format(noiseSimpledata$date, format="%a"))
    
    head(noiseSimpledata)
    
    noisedataDescSum <- noiseSimpledata %>%
      group_by(Descriptor) %>%
      summarise(incidentCount = n())
    
    barplot <- ggplot(noisedataDescSum, aes(x = reorder(Descriptor, -incidentCount), y=incidentCount, fill=Descriptor))
    barplot + geom_bar(width = 1, stat="identity") 
      #theme(      axis.text.x=element_blank(), legend.position="none")
    
    
  })  
  
  output$weekdaydesc <- renderPlot({

    noiseSimpledata <- noisedata %>%
      select(Created.Date, Descriptor)
    Sys.setlocale("LC_TIME", "en_US.UTF-8")
    noiseSimpledata$date <- as.Date(noiseSimpledata$Created.Date, format = "%m/%d/%Y %I:%M:%S %p")
    noiseSimpledata$weekdayf <- factor(format(noiseSimpledata$date, format="%a"))

    noisedataWeekdayDescSum <- noiseSimpledata %>%
      filter(noiseSimpledata$Descriptor == "Loud Music/Party" | 
               noiseSimpledata$Descriptor == "Noise: Construction Before/After Hours (NM1)" | 
               noiseSimpledata$Descriptor == "Banging/Pounding" | 
               noiseSimpledata$Descriptor == "Loud Talking" | 
               noiseSimpledata$Descriptor == "Car/Truck Music" | 
               noiseSimpledata$Descriptor == "Noise: Construction Equipment (NC1)" | 
               noiseSimpledata$Descriptor == "Car/Truck Horn" 
      ) %>%
      group_by(Descriptor, weekdayf) %>%
      summarise(incidentCount = n())
    
    noisedataWeekdayDescSum$weekdayf <- factor(noisedataWeekdayDescSum$weekdayf, levels = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"))
    
    ggplot(noisedataWeekdayDescSum, aes(x=weekdayf)) + 
      geom_line(aes(y=incidentCount,  colour=Descriptor, group=Descriptor),stat="identity", size=2) 
    
  })    
  
  
  output$region <- renderPlotly({
    noisebyborough <-
      read.csv(file = "data/noisebycity.csv",
               header = TRUE,
               sep = ",")
    
    
    barplot <- ggplot(noisebyborough, aes(x = reorder(City, -incidentCount), y=incidentCount, fill=City))
    barplot + geom_bar(width = 1, stat="identity") +
      theme(     legend.position="none")
    

    
  })    
  
  
  output$myMap <- renderLeaflet({
    leaflet() %>%
      addTiles(group = "Default") %>%
      addProviderTiles(providers$Esri.WorldImagery, group = "Satellite Maptile") %>%
      setView(24, 27, zoom = 2) %>%
      addLayersControl(
        baseGroups = c("Default", "Satellite Maptile"),
        options = layersControlOptions(collapsed = FALSE)
      )
    
  })
  
  output$myMap2 <- renderLeaflet({
    leaflet() %>%
      addTiles(group = "Default") %>%
      addProviderTiles(providers$Esri.WorldImagery, group = "Satellite Maptile") %>%
      setView(24, 27, zoom = 2) %>%
      addLayersControl(
        baseGroups = c("Default", "Satellite Maptile"),
        options = layersControlOptions(collapsed = FALSE)
      )
    
  })
  
  observeEvent(input$submenu, {
    if (input$submenu == "heatmap" && !values$isNoisedataLoaded) {
      values$isNoisedataLoaded = TRUE
      withProgress(message = 'Please wait...',
                   value = 0 / 4, {
                     incProgress(1 / 4, detail = "reading data")
                     
                     
                     incProgress(1 / 4, detail = "preparing data")
                     
                     myData <- noisedata %>%
                       select(Created.Date, Descriptor, Borough, Latitude, Longitude) %>%
                       drop_na()
                     
                     incProgress(1 / 4, detail = "rendering map")
                     
                     leafletProxy("myMap", data = myData) %>%
                       fitBounds(~ min(Longitude),
                                 ~ min(Latitude),
                                 ~ max(Longitude),
                                 ~
                                   max(Latitude)) %>%
                       addHeatmap(
                         lng = ~ Longitude,
                         lat = ~ Latitude,
                         group = "HeatMap1",
                         blur = 20,
                         max = 0.01,
                         radius = 15
                       )
                     
                     incProgress(1 / 4)
                     
                   })
      
      
    }
    
  })
  
  
  

  
  observeEvent(input$submenu, {
    if (input$submenu == "heatmap2" && !values$isNoisedataLoaded2) {
      values$isNoisedataLoaded2 = TRUE
      withProgress(message = 'Please wait...',
                   value = 0 / 4, {
                     incProgress(1 / 4, detail = "reading data")
                     
                     
                     incProgress(1 / 4, detail = "preparing data")
                     
                     myData <- noisedata %>%
                       select(Created.Date, Descriptor, Borough, Latitude, Longitude) %>%
                       drop_na()
                     
                     incProgress(1 / 4, detail = "rendering map")
                     
                     
                     
                     leafletProxy("myMap2",
                                  data = subset(myData, Descriptor == "Loud Music/Party")) %>%
                       fitBounds(~ min(Longitude),
                                 ~ min(Latitude),
                                 ~ max(Longitude),
                                 ~
                                   max(Latitude)) %>%
                       addHeatmap(
                         lng = ~ Longitude,
                         lat = ~ Latitude,
                         group = "Loud Music/Party",
                         blur = 20,
                         max = 0.01,
                         radius = 15
                       )
                     
                     
                     leafletProxy("myMap2",
                                  data = subset(myData, Descriptor == "Noise: Construction Before/After Hours (NM1)")) %>%
                       fitBounds(~ min(Longitude),
                                 ~ min(Latitude),
                                 ~ max(Longitude),
                                 ~
                                   max(Latitude)) %>%
                       addHeatmap(
                         lng = ~ Longitude,
                         lat = ~ Latitude,
                         group = "Noise: Construction Before/After Hours (NM1)",
                         blur = 20,
                         max = 0.01,
                         radius = 15
                       )                     
                     
                     
                     
                     leafletProxy("myMap2",
                                  data = subset(myData, Descriptor == "Banging/Pounding")) %>%
                       fitBounds(~ min(Longitude),
                                 ~ min(Latitude),
                                 ~ max(Longitude),
                                 ~
                                   max(Latitude)) %>%
                       addHeatmap(
                         lng = ~ Longitude,
                         lat = ~ Latitude,
                         group = "Banging/Pounding",
                         blur = 20,
                         max = 0.01,
                         radius = 15
                       )                      
                     
                     
                     
                     leafletProxy("myMap2",
                                  data = subset(myData, Descriptor == "Loud Talking")) %>%
                       fitBounds(~ min(Longitude),
                                 ~ min(Latitude),
                                 ~ max(Longitude),
                                 ~
                                   max(Latitude)) %>%
                       addHeatmap(
                         lng = ~ Longitude,
                         lat = ~ Latitude,
                         group = "Loud Talking",
                         blur = 20,
                         max = 0.01,
                         radius = 15
                       )   
                     
                     
                     
                     leafletProxy("myMap2",
                                  data = subset(myData, Descriptor == "Car/Truck Music")) %>%
                       fitBounds(~ min(Longitude),
                                 ~ min(Latitude),
                                 ~ max(Longitude),
                                 ~
                                   max(Latitude)) %>%
                       addHeatmap(
                         lng = ~ Longitude,
                         lat = ~ Latitude,
                         group = "Car/Truck Music",
                         blur = 20,
                         max = 0.01,
                         radius = 15
                       )                      
                     
                     
                     
                     
                     leafletProxy("myMap2",
                                  data = subset(myData, Descriptor == "Noise: Construction Equipment (NC1)")) %>%
                       fitBounds(~ min(Longitude),
                                 ~ min(Latitude),
                                 ~ max(Longitude),
                                 ~
                                   max(Latitude)) %>%
                       addHeatmap(
                         lng = ~ Longitude,
                         lat = ~ Latitude,
                         group = "Noise: Construction Equipment (NC1)",
                         blur = 20,
                         max = 0.01,
                         radius = 15
                       )                      
                     
                     
                     
                     
                     
                     
                     
                     leafletProxy("myMap2",
                                  data = subset(myData, Descriptor == "Car/Truck Horn")) %>%
                       fitBounds(~ min(Longitude),
                                 ~ min(Latitude),
                                 ~ max(Longitude),
                                 ~
                                   max(Latitude)) %>%
                       addHeatmap(
                         lng = ~ Longitude,
                         lat = ~ Latitude,
                         group = "Car/Truck Horn",
                         blur = 20,
                         max = 0.01,
                         radius = 15
                       )                      
                     
                     
                     
                     
                     
                     leafletProxy("myMap2", data = myData) %>%
                       fitBounds(~ min(Longitude),
                                 ~ min(Latitude),
                                 ~ max(Longitude),
                                 ~
                                   max(Latitude)) %>%
                       addHeatmap(
                         lng = ~ Longitude,
                         lat = ~ Latitude,
                         group = "HeatMap1",
                         blur = 20,
                         max = 0.01,
                         radius = 15
                       ) %>%
                       addLayersControl(
                         baseGroups = c("Default", "Satellite Maptile"),
                         overlayGroups = c("HeatMap1", "Loud Music/Party", "Noise: Construction Before/After Hours (NM1)", "Banging/Pounding", "Loud Talking", "Car/Truck Music", "Noise: Construction Equipment (NC1)", "Car/Truck Horn"),
                         options = layersControlOptions(collapsed = FALSE)
                       )
                     
                     
                     incProgress(1 / 4)
                     
                   })
      
      
    }
    
  })  
  
  
  
  
  
  
  
  
  
})