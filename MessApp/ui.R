# ui

##########################################################################
# Set initial state

phoneOwner <- 'Johan'
contact <- 'Theo'

messYears <- c(2012, 2013, 2014, 2015, 2016, 2017, 2018)

daysOfWeek <-
  list('Monday',
       'Tuesday',
       'Wednesday',
       'Thursday',
       'Friday',
       'Saturday',
       'Sunday')

hoursOfDay <- c(0:23)

##########################################################################
# UI
ui <- fluidPage(titlePanel("DEV"),
                sidebarLayout(
                  sidebarPanel(
                    ####################################
                    # Sidebar panel
                    
                    # Selecting people
                    checkboxGroupInput(
                      "people",
                      "Select people:",
                      choiceNames =
                        list(phoneOwner, contact),
                      choiceValues =
                        list(phoneOwner, contact),
                      selected =
                        list(phoneOwner, contact)
                    ),
                    
                    # Selecting years
                    sliderInput(
                      "years",
                      label = "Select range for years:",
                      min = min(messYears),
                      max = max(messYears),
                      value = c(min(messYears), max(messYears)),
                      sep = '',
                      step = 1
                    ),
                    
                    # Selecting weekdays
                    checkboxGroupInput(
                      "weekdays",
                      "Select weekdays:",
                      choiceNames =
                        daysOfWeek,
                      choiceValues =
                        daysOfWeek,
                      selected =
                        daysOfWeek
                    ),
                    
                    # Selecting hours
                    sliderInput(
                      "hours",
                      label = "Select range for hours:",
                      min = min(hoursOfDay),
                      max = max(hoursOfDay),
                      value = c(min(hoursOfDay), max(hoursOfDay)),
                      step = 1
                    )
                    
                  ),
                  ####################################
                  # Main panel
                  
                  mainPanel(tabsetPanel(
                    
                    ########################
                    tabPanel(
                      "Wordcloud",
                      
                      textOutput("selectedPeople"),
                      textOutput("selectedYears"),
                      textOutput("selectedWeekdays"),
                      textOutput("selectedHours")
                    ),
                    
                    ########################
                    tabPanel(
                      "Statistics",
                      
                      
                      textOutput("selectedX"),
                      textOutput("selectedFill"),
                      textOutput("selectedFacett"),
                      
                      ########################
                      # Inputs for plot, 
                      # None = 0 
                      # Weekdays = 1 
                      # Years = 2 
                      # Hours = 3 
                      # People = 4
                      # Value for Y-axis is always number of messages
                      
                      # What to plot on x-axis
                      selectInput("xvalue", label = "Select variable on X-axis", 
                                  choices = list("Weekdays" = 1, "Years" = 2, "Hours" = 3, "People" = 4), 
                                  selected = 1),
                      
                      # What to use for fill
                      selectInput("fillValue", label = "Select variable for color fill", 
                                  choices = list("None" = 0, "Weekdays" = 1, "Years" = 2, "People" = 4), 
                                  selected = 4),
                      
                      # What to use for facetting
                      selectInput("facettValue", label = "Select variable for facetting", 
                                  choices = list("None" = 0, "Weekdays" = 1, "Years" = 2, "People" = 4), 
                                  selected = 0)

                    )
                  ))
                  
                  
                ))
