# iMessage
Visualization of iMessages between two people

Data collected from messages in swedish, the only time this can be an issue is when generating the word cloud, see Step 2.E. 

Code for R.


Step 1.

Extract iMessage data from phone. 

I used EaseUS MobieMover Free. (https://www.easeus.com/phone-transfer/mobimover-free.html)

DO NOT export all messages, use Custom export to select only one contact from messages. One contact may have more then one phone number which is ok.

The message data is exported to a html-file.

Rename the file to avoid re-writing to same file.



Step 2.
In RStudio.


A.

Create a new project. 

Copy files from GitHub to project folder.


B.

Run requierments.R to install all necessary packages.


C.

In parseMessages.R, change following line so that it points to your html-file.

fileWithData <-
  'D:/Johans/R/iMessage/mobiMover/Message.html'

To get correct names change following code:

rightTexter <- 'Alice'

leftTexter <- 'Bob'

The phone the messages were extracted from belongs to Alice.
Alice is texting on right side of the screen, Bob is texting on the left. 

Run parseMessages.R to extract data from html-file.


D.

Copy file mess.RData to folder ./MessApp/messData/

Replace the sample file with your own.


In the console, write:

>library(shiny)

>runApp('MessApp')


This launchs an app for generating wordcloud and creating plots of stats on messages.


E.

Run generateWordCloud.R to generate picture of wordcloud. 

Code is written for messages in swedish, to change language change following code:

mainLanguage <- 'swedish'

Word cloud for only one texter can be created by changing following code:

words <- filter(words, person == leftTexter || person == rightTexter) 
to
words <- filter(words, person == leftTexter)

A picture is saved to your work directory, change file name with following code:

fileNameOfPlot <- 'wordCloudAll'

NOTE: The plot window (the acctual window) in RStudio needs to be lagre in size when generatin the word cloud.
If you get warnings saying  "...could not be fit on page. It will not be plotted..." make the window lagrer.


F.

Run plotMessageStats.R to generate pictures of stats on messages. Messages per day, year, person, hour.
Pictures are saved to your work directory.


/Johan Wållgren April 2018
