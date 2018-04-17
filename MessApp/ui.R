# ui

##########################################################################
# Set initial state
library(shiny)
library(tidyverse)

load('./messData/mess.RData')
mess <<- mess

phoneOwner <- as.character(unique(mess$person)[1])
contact <- as.character(unique(mess$person)[2])
messYears <- as.numeric(unique(mess$year))

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
ui <- fluidPage(titlePanel("Message visualization"),
                sidebarLayout(
                  sidebarPanel(
                    ####################################
                    # Sidebar panel
                    
                    # Selecting people
                    checkboxGroupInput(
                      "person",
                      "Select persons:",
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
                    ),
                    
                    ########################
                    # Inputs for plot,
                    # None = 0
                    # Weekdays = weekdays
                    # Years = years
                    # Hours = hours
                    # People = people
                    # Value for Y-axis is always number of messages
                    
                    # What to plot on x-axis
                    selectInput(
                      "xValue",
                      label = "Select variable on X-axis",
                      choices = list(
                        "Weekdays" = 'weekday',
                        "Years" = 'year',
                        "Hours" = 'hour',
                        "Person" = "person"
                      ),
                      selected = 'weekday'
                    ),
                    
                    # What to use for fill
                    selectInput(
                      "fillValue",
                      label = "Select variable for color fill",
                      choices = list(
                        "Weekdays" = 'weekday',
                        "Years" = 'year',
                        "Person" = "person"
                      ),
                      selected = "person"
                    )
                    
                  ),
                  ####################################
                  # Main panel
                  
                  mainPanel(tabsetPanel(
                    ########################
                    tabPanel(
                      "Wordcloud",
                      
                      textOutput("selectedPersons"),
                      textOutput("selectedYears"),
                      textOutput("selectedWeekdays"),
                      textOutput("selectedHours")
                    ),
                    
                    ########################
                    tabPanel(
                      "Statistics",
                      
                      textOutput("selectedX"),
                      textOutput("selectedFill"),
                      
                      plotOutput(outputId = "interactiveMessagePlot")
                      
                    )
                  ))

                ))
