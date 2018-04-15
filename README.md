# iMessage
Visualization of iMessages between two people



We text in swedish, the only time this becomes an issue is when generating the word cloud, see Step 2.C. 

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

Run packagesNedded.R to install all necessary packages.


B.

Run parseMessages.R to extract data from html-file.

To get correct names change following code:

rightTexter <- 'phoneOwner'

leftTexter <- 'contact'


C.

Run generateWordCloud.R to generate word cloud. 

Code is written for messages in swedish, to change language change following code:

mainLanguage <- 'swedish'

Word cloud for only one texter can be created by changing following code:

words <- filter(words, person == leftTexter || person == rightTexter) 
to
words <- filter(words, person == leftTexter)

The word cloud is generated as a plot which can be saved as a jpeg or a pdf.

NOTE: The plot window (the acctual window) in RStudio needs to be lagre in size when generatin the word cloud.
If you get warnings saying  "...could not be fit on page. It will not be plotted..." make the window lagrer.


D.

Run plotMessageStats.R to generate plots of stats on messages. Messages per day, year, person, hour.
/Johan Wållgren 20180414
