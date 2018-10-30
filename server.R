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
  read.csv(file = "data//311_Noise_Complaints_last_year.csv",
           header = TRUE,
           sep = ",")


shinyServer(function(input, output, session) {
  values <- reactiveValues()
  values$isNoisedataLoaded <- FALSE
  
  output$summary <- renderPrint({
    print("1234")
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
  
  output$weekday <- renderPlotly({

    noiseSimpledata <- noisedata %>%
      select(Created.Date, Descriptor)
    
    noiseSimpledata$date <- as.Date(noiseSimpledata$Created.Date, format = "%m/%d/%Y %I:%M:%S %p")
    
    noiseSimpledata$weekdayf <- factor(format(noiseSimpledata$date, format="%a"))
    
    head(noiseSimpledata)
    
    noisedataDescSum <- noiseSimpledata %>%
      group_by(Descriptor) %>%
      summarise(incidentCount = n())
    
    barplot <- ggplot(noisedataDescSum, aes(x = reorder(Descriptor, -incidentCount), y=incidentCount, fill=Descriptor))
    barplot + geom_bar(width = 1, stat="identity") +
      theme(      axis.text.x=element_blank(), legend.position="none")
    
    
  })  
  
  output$weekdaydesc <- renderPlot({

    noiseSimpledata <- noisedata %>%
      select(Created.Date, Descriptor)
    
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
      geom_line(aes(y=incidentCount,  colour=Descriptor, group=Descriptor),stat="identity")
    
    
  })    
  
  
  output$region <- renderPlotly({
    noisebyborough <-
      read.csv(file = "data/noisebycity.csv",
               header = TRUE,
               sep = ",")
    
    
    barplot <- ggplot(noisebyborough, aes(x = reorder(City, -incidentCount), y=incidentCount, fill=City))
    barplot + geom_bar(width = 1, stat="identity") +
      theme(      axis.text.x=element_blank(), legend.position="none")
    

    
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
                     
                     
                     
                     leafletProxy("myMap",
                                  data = subset(myData, Descriptor == "Loud Music/Party")) %>%
                       fitBounds(~ min(Longitude),
                                 ~ min(Latitude),
                                 ~ max(Longitude),
                                 ~
                                   max(Latitude)) %>%
                       addHeatmap(
                         lng = ~ Longitude,
                         lat = ~ Latitude,
                         group = "HeatMap2",
                         blur = 10,
                         max = 0.01,
                         radius = 1
                       )
                     
                     
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
                       ) %>%
                       addLayersControl(
                         baseGroups = c("Default", "Satellite Maptile"),
                         overlayGroups = c("HeatMap1", "HeatMap2"),
                         options = layersControlOptions(collapsed = FALSE)
                       )
                     
                     
                     incProgress(1 / 4)
                     
                   })
      
      
    }
    
  })
  
  
})