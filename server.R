library(shiny)
library(leaflet)
library(leaflet.extras)


shinyServer(function(input, output, session) {
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
  
  observe({
    withProgress(message = 'Please wait...',
                 value = 0 / 4, {
                   
                   incProgress(1 / 4, detail = "reading data")
                   
                   noisedata <-
                     read.csv(file = "data//311_Noise_Complaints_1month_manhattan.csv",
                              header = TRUE,
                              sep = ",")

                   incProgress(1 / 4, detail = "preparing data")
                   
                   myData <- noisedata %>%
                     select(Created.Date, Descriptor,Borough, Latitude, Longitude) %>%
                     drop_na()
                   
                   incProgress(1 / 4, detail = "rendering map")

                   leafletProxy("myMap", data = myData) %>%
                     fitBounds(~ min(Longitude), ~ min(Latitude), ~ max(Longitude), ~
                                 max(Latitude)) %>%
                     addHeatmap(
                       lng = ~ Longitude,
                       lat = ~ Latitude,
                       group = "HeatMap1",
                       blur = 20,
                       max = 0.01,
                       radius = 15
                     ) %>%
                     addHeatmap(
                       lng = ~ Longitude,
                       lat = ~ Latitude,
                       group = "HeatMap2",
                       blur = 10,
                       max = 0.01,
                       radius = 1
                     ) %>%                   
                     addLayersControl(
                       baseGroups = c("Default", "Satellite Maptile"),
                       overlayGroups = c("HeatMap1", "HeatMap2"),
                       options = layersControlOptions(collapsed = FALSE)
                     )
                   
                   incProgress(1 / 4)
                   
                 })
  })
  
  
})