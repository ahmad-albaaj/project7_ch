
library(shiny)
library(leaflet)


shinyUI(
  
    bootstrapPage(
      # give the info that full page is used
      tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
      leafletOutput("map", width = "100%", height = "100%"),
      
      
      absolutePanel(top = 10, right = 10,
                    wellPanel(
                      h4("Challenge"),
                      #                 # Add Shiny inputs for filtering here
                      selectInput("continent", label = "Select continent:", 
                                  choices = c("All", unique(world$continent))),
                      checkboxGroupInput("type", label = "Select country type",
                                         choices = c("All", unique(world$type)))
                    )
      )
    ))