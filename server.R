library(shiny)

#r_colors <- rgb(t(col2rgb(colors()) / 255))
#names(r_colors) <- colors()


# Define server logic required to generate and plot a random distribution
shinyServer(
  function(input, output, session) {
    
    points <- eventReactive(input$recalc, {
      cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
    }, ignoreNULL = FALSE)
    
    output$mymap <- renderLeaflet({
      leaflet() %>%
        addProviderTiles(providers$Stamen.TonerLite,
                         options = providerTileOptions(noWrap = TRUE)
        ) %>%
        addMarkers(data = points())
    })
  }
  
  
  
)