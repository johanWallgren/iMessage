# Parsing meassage data collected from an iphone using "EaseUS MobiMover Free"
# By Johan Wållgren 201804

# Creates a RData file with a tibble 

library(XML)
library(tidyverse)

# Names of texters
rightTexter <- 'Alice'
leftTexter <- 'Bob'

# Parsing data
fileWithData <-
  'D:/Johans/R/iMessage/mobiMover/Message.html'

htmlDoc <-
  htmlTreeParse(fileWithData,
                useInternal = TRUE)

# collecting dates from file
dates <- unlist(xpathApply(htmlDoc, '//p', xmlValue))
dates = gsub('Date:', '', dates)
rmRows <- grep('Phone:', dates)
dates <- dates[-rmRows]
dates <- dates[-length(dates)]
dates <- as_tibble(dates)

# Collecting text messages
mesTxt <- unlist(xpathApply(htmlDoc, '//tr', xmlValue))
mesTxt <- mesTxt[seq(3, length(mesTxt), 4)]
mesTxt <- as_tibble(mesTxt)

# Collecting who sent message, Me or Contact
fileAsText <-
  readLines(fileWithData)
mePattern <- '<div class="main-right">'

meRows <- as_tibble(grep(mePattern, fileAsText)) %>%
  mutate(person = rightTexter)

otherPattern <- '<div class="main-left">'

otherRows <- as_tibble(grep(otherPattern, fileAsText)) %>%
  mutate(person = leftTexter)

texter <- bind_rows(meRows, otherRows) %>%
  arrange(value)

# Creating one tibble with person, date, time and text
mess <- bind_cols(texter, dates, mesTxt) %>%
  select(-value) %>%
  rename(date = value1, text = value2) %>%
  separate(date, c('date', 'time'), sep = ' ')

############################################################
# Above: code specific to retreved messages from phone
# Below: Generic code for presenting data from messages or other.
#
# Get a tibble with this format the rest of the code can be used
#
# A tibble: 25,569 x 4
# person    date          time        text                                                                      
# <chr>     <chr>         <chr>       <chr>                                                                     
# 1 Alice   11-15-2012    16:17:22    Hello! What's up?                                                                     
# 2 Bob     11-15-2012    16:18:01    Great! You?                                                     
# 3 Alice   11-15-2012    16:17:36    Same!    
############################################################

# Fixing the date format
mess$date <- as.Date(strptime(as.character(mess$date), "%m-%d-%Y"))
mess <- mutate(mess, dateTime = as.POSIXct(paste(date, time, sep = ' '))) %>%
  select(c(-date, -time)) %>%
  arrange(dateTime)

# Converting person to factor
mess$person <- as.factor(mess$person)

# Adding weekday, year, month, day and hour
Sys.setlocale("LC_TIME", "C")
mess <- mutate(mess, weekday = as.factor(weekdays.Date(dateTime))) %>%
  separate(dateTime, c('date','time'), sep = ' ', remove = FALSE) %>%
  separate(date, c('year', 'month', 'day'), sep = '-', remove = FALSE) %>%
  separate(time, c('hour','minute','second'), sep = ':', remove = FALSE) %>%
  select(-minute, -second) %>%
  mutate(hour = as.integer(hour)) %>%
  mutate(year = as.integer(year)) %>%
  mutate(day = as.integer(day)) %>%
  mutate(month = as.integer(month))

# Adding row id
mess$id <- seq.int(nrow(mess))

# Save mess
save(mess, file = 'mess.RData')
