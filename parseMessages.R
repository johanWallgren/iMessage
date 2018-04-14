# Parsing meassage data collected from an iphone using "EaseUS MobiMover Free"
# By Johan Wållgren 201804

# Creates a RData file with a tibble 

# Results should look something like this

# A tibble: 5 x 4
#   person  text                          dateTime            weekday
#   <fct>  <chr>                          <dttm>              <fct>  
# 1 Johan  Till telefon                   2012-11-11 20:33:00 söndag 
# 2 Theo   Haal                           2012-11-13 22:51:39 tisdag 
# 3 Theo   Test sms til ad fixa iMessage  2012-11-14 16:27:03 onsdag 
# 4 Theo   ￼:)                             2012-11-15 16:17:22 torsdag
# 5 Theo   Ja                             2012-11-15 16:17:36 torsdag

library(XML)
library(tidyverse)

# Names of texters
rightTexter <- 'Johan'
leftTexter <- 'Theo'

# Parsing data
fileWithData <-
  'D:/Johans/R/iMessage/mobiMover/TheoMessage.html'

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

# Adding weekday
mess <- mutate(mess, weekday = as.factor(weekdays.Date(dateTime)))

# Adding row id
mess$id <- seq.int(nrow(mess))

# Save mess
save(mess, file = 'mess.RData')
