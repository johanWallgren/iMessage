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
    paste(input$xValue)
  })
  
  output$selectedFill <- renderText({
    paste(input$fillValue)
  })
  
  
  ################################################
  # Possilbe selections:
  # X: Weekdays Years Hours People
  # Fill: Weekdays Years People
  # Y: Always number of messages
  
  ################################################
  # Reactive function returning data to plot
  datasetInput <- reactive({
    
    print(input$weekdays)
    print(input$person)
    
    filtMess <-
      filter(
        mess,
        year >= input$years[1] &
          year <= input$years[2] &
          weekday %in% input$weekdays &
          person %in% input$person &
          hour >= input$hours[1] &
          hour <= input$hours[2]
      )
    
    factorOrder <-
      c('Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday')
    filtMess$weekday <-
      ordered(filtMess$weekday, levels = factorOrder)
    
    plotData <- as_tibble()
    
    for (i in 1:nrow(unique(filtMess[input$fillValue]))) {
      # fill
      
      temp <-
        filter(filtMess, filtMess[input$fillValue] == as.character(unique(filtMess[input$fillValue][[i, 1]]))) %>%
        group_by_(as.name(input$xValue)) %>% # x-axis
        summarize(numberOfMessages = n())
      
      temp[input$fillValue] <-
        as.character(unique(mess[input$fillValue])[i, ][[1]])
      
      plotData <- bind_rows(plotData, temp)
    }
    print((plotData))
    rm(temp)
    plotData
    
  })
  
  ################################################
  # returning interactive plot
  
  output$interactiveMessagePlot <- renderPlot({
    dataToPlot <- datasetInput()
    
    yValue = 'numberOfMessages'
    
    interactiveMessagePlot <-
      ggplot(dataToPlot,
             aes_string(input$xValue, yValue, fill = input$fillValue))
    interactiveMessagePlot + geom_bar(stat = 'identity') +
      theme_bw()
  })

}
