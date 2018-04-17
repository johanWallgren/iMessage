# server

server <- function(input, output) {

  ################################################
  # Using inputs on sidebar
  
  output$selectedPeople <- renderText({ 
    paste(input$people)
  })
  
  output$selectedYears <- renderText({ 
    paste(input$years[1], input$years[2])
  })
  
  output$selectedWeekdays <- renderText({ 
    paste(input$weekdays)
  })
  
  output$selectedHours <- renderText({ 
    paste(input$hours[1], input$hours[2])
  })
  
  
  
  ################################################
  # Using inputs on tab Statistics
  
  # Selections:
  # None = 0 
  # Weekdays = 1 
  # Years = 2 
  # Hours = 3 
  # People = 4
  
  # Value for Y-axis is always number of messages
  
  output$selectedX <- renderText({ 
    paste(input$xvalue)
  })
  
  output$selectedFill <- renderText({ 
    paste(input$fillValue)
  })
  
  output$selectedFacett <- renderText({ 
    paste(input$facettValue)
  })
  
}