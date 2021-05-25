
library(shiny)
library(leaflet)
library(RColorBrewer)
library(spData)
library(sf)
library(dplyr)

shinyServer(function(input, output) {
  
      data("world")
    
    # filter the data here
    # example: worldData <- reactive({
    #   dat <- world
    #   dat <- filter(dat, ...)
    # }) 
    
    worldData <- reactive({
      dat <- world %>%
        mutate(pop_km2 = pop/area_km2)
      
      data <- filter(dat, continent == input$continent)
      
      # this doesn't work
      data <- ifelse(input$continent == "All", dat, filter(dat, continent == input$continent))
      
    })
    
    colorpal <- reactive({
      colorNumeric(brewer.pal(6, "Greens"), worldData()$pop_km2)
    })
    
    output$map <- renderLeaflet({
      leaflet() %>% 
        addProviderTiles("Stamen.TonerLite") %>%
        setView(lng=0, lat=0, zoom = 1.5)
      
      # addTiles() %>%
      
      # Fill in leaflet code here
    })
    
    observe({
      pal <- colorpal()
      
      proxy <- leafletProxy("map", data = worldData()) %>%
        clearShapes() %>%
        addPolygons(data = worldData(),
                    fillColor = ~pal(pop_km2), color = "#777777", weight = 1, opacity = 1,
                    layerId = ~iso_a2, 
                    highlight = highlightOptions(
                      weight = 5,
                      color = "#666",
                      fillOpacity = 0.7,
                      bringToFront = TRUE),
                    label = paste0("Country: ", worldData()$name_long, "<br>Pop density (km²):", round(worldData()$pop_km2),2),
                    labelOptions = labelOptions(
                      style = list("font-weight" = "normal", padding = "3px 8px"),
                      textsize = "15px",
                      direction = "auto"
                    )
        )
      
      # Modify the leaflet proxy here
      
    })
    
    
  })
  


if (requireNamespace("sf", quietly = TRUE)) {
library(sf)
data(world)
}

world <- st_read(system.file("shapes/world.gpkg", package="spData"))
data("world")
