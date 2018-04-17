# Parsing meassage data collected from an iphone using "EaseUS MobiMover Free"
# By Johan Wållgren 201804

# Creates a RData file with a tibble 

# Results should look something like this

# A tibble: 25,569 x 11
# person text                dateTime            date   year  month day   time  hour  weekday    id
# <fct>  <chr>               <dttm>              <chr>  <chr> <chr> <chr> <chr> <chr> <fct>   <int>
# 1 Alice  Till telefon        2012-11-11 20:33:00 2012-~ 2012  11    11    20:3~ 20    Sunday      1
# 2 Bob   Haal                2012-11-13 22:51:39 2012-~ 2012  11    13    22:5~ 22    Tuesday     2
# 3 Bob   Test sms til ad fi~ 2012-11-14 16:27:03 2012-~ 2012  11    14    16:2~ 16    Wednes~     3

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
