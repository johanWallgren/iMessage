# Generating plots of stats for messages
# By Johan Wållgren 201804

library(tidyverse)
library(gridExtra)

# Loads parsed message data from file mess.RData
load('mess.RData')

# Change names here:
rightTexter <- unique(mess$person)[1]
leftTexter <- unique(mess$person)[2]

#########################
# Messages per weekday per person

messPerWeekdayP1 <- filter(mess, person == rightTexter) %>%
  group_by(weekday) %>%
  summarize(messPerDay = n()) %>%
  mutate(person = rightTexter)

messPerWeekdayP2 <- filter(mess, person == leftTexter) %>%
  group_by(weekday) %>%
  summarize(messPerDay = n()) %>%
  mutate(person = leftTexter)

messPerWeekday <- bind_rows(messPerWeekdayP1, messPerWeekdayP2)
      
factorOrder<- c('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday')
messPerWeekday$weekday <- ordered(messPerWeekday$weekday, levels = factorOrder)

png('plotMessPerWeekdayPerson.png', width=20,height=7, units='cm', res=300)

plotMessPerWeekday <- ggplot(messPerWeekday, aes(weekday, messPerDay, fill = person))
plotMessPerWeekday + geom_bar(stat = 'identity', position = 'stack') +
  theme_bw() +
  labs(x = 'Weekday', y = 'Number of messages', title = 'Messages per weekday') + 
  guides(fill=guide_legend(title=""))

dev.off()

#########################
# Messages per hour per person

messhourP1 <- filter(mess, person == rightTexter) %>%
  group_by(hour) %>%
  summarize(messPerHour = n()) %>%
  mutate(person = rightTexter)

messhourP2 <- filter(mess, person == leftTexter) %>%
  group_by(hour) %>%
  summarize(messPerHour = n()) %>%
  mutate(person = leftTexter)

messhour <- bind_rows(messhourP1, messhourP2)

png('plotMessPerHourPerson.png', width=20,height=7, units='cm', res=300)

plotMessPerHour<- ggplot(messhour, aes(hour, messPerHour, fill = person))
plotMessPerHour + geom_bar(stat = 'identity') +
  theme_bw() +
  labs(x = 'Hour', y = 'Number of messages', title = 'Messages per hour and person') + 
  guides(fill=guide_legend(title=""))

dev.off()

#########################
# Messages per hour per day per person
persons <- c(as.character(rightTexter), as.character(leftTexter))
weekdays <- unique(mess$weekday)

messhourPerDay <- as_tibble()

for(i in 1:length(persons)) {
  for (j in 1:length(weekdays)) {
    temp <- filter(mess, person == persons[i] & weekday == weekdays[j]) %>%
      group_by(hour) %>%
      summarize(messPerHourDay = n()) %>%
      mutate(weekday = weekdays[j]) %>%
      mutate(person = persons[i])
    
    messhourPerDay <- bind_rows(messhourPerDay, temp)
  }
}
rm(temp)

factorOrder<- c('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday')
messhourPerDay$weekday <- ordered(messhourPerDay$weekday, levels = factorOrder)
            
png('plotMessPerHourDayPerson.png', width=20,height=3*length(unique(messhourPerDay$weekday)), units='cm', res=300)

plotMessPerHourPerDay <- ggplot(messhourPerDay, aes(hour, messPerHourDay, fill = person))
plotMessPerHourPerDay + geom_bar(stat = 'identity', position = 'stack') +
  theme_bw() +
  labs(x = 'Hour', y = 'Number of messages', title = 'Messages per hour, day and person') + 
  guides(fill=guide_legend(title="")) +
  facet_grid(weekday ~ .)

dev.off()

#########################
# Messages per hour per year per person
persons <- c(as.character(rightTexter), as.character(leftTexter))
years <- unique(mess$year)

messhourPerDay <- as_tibble()

for(i in 1:length(persons)) {
  for (j in 1:length(years)) {
    temp <- filter(mess, person == persons[i] & year == years[j]) %>%
      group_by(hour) %>%
      summarize(messPerHourYear = n()) %>%
      mutate(person = leftTexter) %>%
      mutate(year = years[j]) %>%
      mutate(person = persons[i])
    
    messhourPerDay <- bind_rows(messhourPerDay, temp)
  }
}
rm(temp)

png('plotMessPerHourYearPerson.png', width=20,height=3*length(unique(messhourPerDay$year)), units='cm', res=300)

plotMessPerHourPerYear <- ggplot(messhourPerDay, aes(hour, messPerHourYear, fill = person))
plotMessPerHourPerYear + geom_bar(stat = 'identity', position = 'stack') +
  theme_bw() +
  labs(x = 'Hour', y = 'Number of messages', title = 'Messages per hour, year and person') + 
  guides(fill=guide_legend(title="")) +
  facet_grid(year ~ .)

dev.off()

#########################
# Top messages

toppMess <- count(mess, text, sort = TRUE) %>%
  filter(nchar(text) > 10) %>%
  rename('Top message with more than 10 characters' = text, Frequency = n)

png('plotTopMessages.png', width=15,height=10, units='cm', res=300)

grid.table(head(toppMess,10))

dev.off()







