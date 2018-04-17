# server

server <- function(input, output) {

  ################################################
  # Using inputs on sidebar
  
  output$selectedPersons <- renderText({ 
    paste(input$person)
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
  

  
  output$selectedX <- renderText({ 
    paste(input$xvalue)
  })
  
  output$selectedFill <- renderText({ 
    paste(input$fillValue)
  })
  
  output$selectedFacett <- renderText({ 
    paste(input$facettValue)
  })
  
  
  ################################################
  # Possilbe selections:
  # X: Weekdays Years Hours People
  # Fill: None Weekdays Years People
  # Facett: None Weekdays Years People
  # Y: Always number of messages

  ################################################
  # Reactive function returning data to plot
  datasetInput <- reactive({

    mess %>% 
      filter(year >= as.name(input$years[1]) & year <= as.name(input$years[2])) %>%
      filter(weekday %in% input$weekdays) %>%
      filter(person %in% input$person) %>%
      filter(hour >= input$hours[1] & hour <= input$hours[2]) %>%
      group_by_(input$xvalue) %>% 
      summarize(numberOfMessages = n())
  })
  
  
  
  ################################################
  # returning interactive plot
  
  output$interactiveMessagePlot <- renderPlot({
    
    dataToPlot <- datasetInput()
    
    print(head(dataToPlot))

    yValue = 'numberOfMessages'
    
    interactiveMessagePlot <- ggplot(dataToPlot, aes_string(input$xvalue, yValue))
    interactiveMessagePlot + geom_bar(stat = 'identity') + 
      theme_bw()

  })
  
  
  
}




