# ui

##########################################################################
# Set initial state
library(shiny)
library(tidyverse)
library(tidytext)
library(tm)
library(wordcloud)
library(RColorBrewer)
library(shinythemes)

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
ui <- fluidPage(theme = shinytheme("united"),
                titlePanel("Message visualization"),
                sidebarLayout(
                  sidebarPanel(width = 3,
                               ####################################
                               # Sidebar panel
                               
                               # Selecting language
                               selectInput(
                                 "language",
                                 label = "Select language",
                                 choices = list(
                                   'Danish' = 'danish',
                                   'Dutch' = 'dutch',
                                   'English' = 'english',
                                   'Finnish' = 'finnish',
                                   'French' = 'french',
                                   'German' = 'german',
                                   'Hungarian' = 'hungarian',
                                   'Italian' = 'italian',
                                   'Norwegian' = 'norwegian',
                                   'Portuguese' = 'portuguese',
                                   'Russian' = 'russian',
                                   'Spanish' = 'spanish',
                                   'Swedish' = 'swedish'
                                 ),
                                 selected = 'swedish',
                                 width = '350px'
                               ),                   
                               
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
                                 step = 1,
                                 width = '350px'
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
                                 step = 1,
                                 width = '350px'
                               )
                  ),
                  ####################################
                  # Main panel
                  
                  mainPanel(tabsetPanel(
                    ########################
                    tabPanel(
                      "Wordcloud",
                      
                      sliderInput(
                        "zoom",
                        label = "Zoom wordcloud:",
                        min = 0.25,
                        max = 7,
                        value = c(1, 5),
                        sep = '',
                        step = 0.25,
                        width = '350px'
                      ),
                      
                      plotOutput(outputId = "wordcloudPlot", width = "700px", height = "700px")

                    ),
                    
                    ########################
                    tabPanel(
                      "Statistics",
                      
                      plotOutput(outputId = "interactiveMessagePlot"),
                      
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
                        selected = 'weekday',
                        width = '350px'
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
                        selected = "person",
                        width = '350px'
                      )
                      
                    )
                  ))
                  
                ))
