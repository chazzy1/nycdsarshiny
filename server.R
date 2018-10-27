library(shiny)
library(leaflet)
library(leaflet.extras)


#r_colors <- rgb(t(col2rgb(colors()) / 255))
#names(r_colors) <- colors()


# Define server logic required to generate and plot a random distribution
shinyServer(
  function(input, output, session) {
    
    
    
    output$myMap <- renderLeaflet({
      leaflet() %>% 
        addTiles() %>%
        setView(24, 27, zoom = 2) 
    })
    
    # output$myMap <- renderLeaflet({
    #   leaflet() %>% 
    #     addProviderTiles(providers$CartoDB.Positron, group = "Default Maptile") %>% 
    #     addProviderTiles(providers$CartoDB.DarkMatter, group = "Dark Maptile") %>%
    #     addProviderTiles(providers$Esri.WorldImagery, group = "Satellite Maptile") %>%
    #     setView(24, 27, zoom = 2) %>% 
    #     addLayersControl(
    #       baseGroups = c("Default Maptile", "Dark Maptile", "Satellite Maptile"),
    #       options = layersControlOptions(collapsed = FALSE)
    #     )
    # })
    
    observe({
      
      withProgress(message = 'Please wait...',
                   value = 0/4, {
                     
                     #req(input$file1)
                     
                     
                     incProgress(1/4, detail = "reading data")
                     noisedata <- read.csv(file="data//311_Noise_Complaints_sample.csv", header=TRUE, sep=",")
                     #locationdata <- fromJSON(input$file1$datapath, simplifyVector = TRUE, simplifyDataFrame = TRUE)
                     
                     #newIcons <- iconList(
                     #  stand = makeIcon("stand.png", "stand.png", 36, 36),
                    #   drive = makeIcon("drive.png", "drive.png", 36, 36)
                     #)
                     
                     incProgress(1/4, detail = "cleaning data")

                     myData <- noisedata %>% 
                       select(Street.Name, Latitude, Longitude) %>% 
                       mutate(lat = Latitude, lon = Longitude) %>%
                       drop_na()

                     incProgress(1/4, detail = "rendering map")
                     
                     print(head(myData))
                      
                     print(min(na.omit(myData$lon)))
                     print(min(myData$lat))
                     print(max(myData$lon))
                     print(max(myData$lat))
                     
                     
                     leafletProxy("myMap", data = myData) %>%
                       fitBounds(~min(lon), ~min(lat), ~max(lon), ~max(lat)) %>%
                       addHeatmap(lng = ~lon, lat = ~lat, group = "HeatMap", blur = 20, max = 0.01, radius = 15)
                       # addMarkers(data = head(myData, 50000), ~lon, ~lat, icon = ~newIcons[image], clusterOptions = markerClusterOptions(),
                       #            label = ~ format(Date, format = "%H:%M %d-%b-%Y"), group = "Points") %>%
                       # 
                       # addLayersControl(
                       #   baseGroups = c("Default Maptile", "Dark Maptile", "Satellite Maptile"),
                       #   overlayGroups = c("HeatMap"),
                       #   options = layersControlOptions(collapsed = FALSE)
                       # )

                     incProgress(1/4)
                     
                   })
    })
    
    
  }
)