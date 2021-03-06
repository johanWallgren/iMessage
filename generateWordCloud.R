# Generating word cloud of most frequent words in messages
# By Johan Wållgren 201804

# NOTE: The plot window (the acctual window) in RStudio needs to be lagre in size when generatin word cloud.
# If you get warnings saying  "...could not be fit on page. It will not be plotted..." make the window lagrer.

library(tidyverse)
library(tidytext)
library(tm)
library(wordcloud)
library(RColorBrewer)

# Loads parsed message data from file mess.RData
load('mess.RData')

# Change names or language here:
rightTexter <- unique(mess$person)[1]
leftTexter <- unique(mess$person)[2]
mainLanguage <- 'swedish'
fileNameOfPlot <- 'plotWordcloudAll.png'


# Tibble with one word per row
words <- unnest_tokens(mess, word, text)

# Possible to filter word cloud by person, remove '||' and one name to use filter
words <-
  filter(words, person == leftTexter || person == rightTexter)

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
png(fileNameOfPlot, width=16,height=16, units='cm', res=300)
wordcloud(
  words = topWords$word,
  freq = topWords$n,
  min.freq = 10,
  max.words = 175,
  random.order = FALSE,
  rot.per = 0.35,
  colors = brewer.pal(9, "Set1")
)
dev.off()
