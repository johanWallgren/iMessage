# server

server <- function(input, output) {
  
  ################################################
  # Possilbe selections:
  # X: Weekdays Years Hours People
  # Fill: Weekdays Years People
  # Y: Always number of messages
  
  ################################################
  # Reactive function returning data to plot
  statisticsInput <- reactive({
    
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
    rm(temp)
    plotData
    
  })
  
  
  ################################################
  # Reactive function returning data to plot
  wordcloudInput <- reactive({
    
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
    
    filtMess
    
  })
  
  ################################################
  # returning interactive plot
  
  output$interactiveMessagePlot <- renderPlot({
    
    dataToPlot <- statisticsInput()
    
    yValue = 'numberOfMessages'
    
    interactiveMessagePlot <-
      ggplot(dataToPlot,
             aes_string(input$xValue, yValue, fill = input$fillValue))
    interactiveMessagePlot + geom_bar(stat = 'identity') +
      theme_bw()
  })
  
  ################################################
  # returning interactive plot
  
  output$wordcloudPlot <- renderPlot({
    
    dataToPlot <- wordcloudInput()
    
    mainLanguage <- input$language
    
    # Tibble with one word per row
    words <- unnest_tokens(dataToPlot, word, text)
    
    # Tibble with stop words to be removed
    stop_words <- as_tibble(stopwords(mainLanguage))
    
    # Remove all numbers as well
    stop_numbers <- as_tibble(as.character(seq(1:1e6)))
    
    stop_words <- bind_rows(stop_words, stop_numbers) %>%
      rename(word = value)
    
    # Removing stop words
    words <- words %>%
      anti_join(stop_words)
    
    # Calculating frequenzy of words
    topWords <- count(words, word, sort = TRUE)
    
    # Generating word cloud for all messages
    wordcloud(
      words = topWords$word,
      freq = topWords$n,
      scale=c(input$zoom[2],input$zoom[1]),
      min.freq = 10,
      max.words = 150,
      random.order = FALSE,
      rot.per = 0.35,
      colors = brewer.pal(9, "Set1")
    )
    
  })
  
}
