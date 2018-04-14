# Generating word cloud of most frequent words in messages
# By Johan Wållgren 201804

library(tidyverse)
library(tidytext)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)

rightTexter <- 'Johan'
leftTexter <- 'Theo'
mainLanguage <- 'swedish'

# Loads parsed message data from file mess.RData
load('mess.RData')

# Tibble with one word per row
words <- unnest_tokens(mess, word, text)

# Possible to filter word cloud by person, remove '||' and one name to use filter
words <- filter(words, person == leftTexter || person == rightTexter)

# Removing stop words
stop_words <- as_tibble(stopwords(mainLanguage)) %>%
  rename(word = value)

words <- words %>%
  anti_join(stop_words)

# Calculating frequenzy of words
topWords <- count(words, word, sort = TRUE)

# Generating word cloud for all messages
set.seed(2018)
wordcloud(
  words = topWords$word,
  freq = topWords$n,
  min.freq = 5,
  max.words = 500,
  random.order = FALSE,
  rot.per = 0.35,
  colors = brewer.pal(8, "Set1")
)
