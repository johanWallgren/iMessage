# iMessage
Visualization of iMessages between two people

Code for R.
Step 1.
Extract iMessage data from phone. 
I used EaseUS MobieMover Free. (https://www.easeus.com/phone-transfer/mobimover-free.html)
DO NOT export all messages, select only one contact. One contact may have more then one phone number which is ok.
The message data is exported to a html-file.
Rename the file to avoid re-writing to same file.


Step 2.
In RStudio.
A. Run packagesNedded.R to install all necessary packages.

B. Run parseMessages.R to extract data from html-file.
To get correct names change following code:
rightTexter <- 'Johan'
leftTexter <- 'Theo'

C. Run generateWordCloud.R to generate word cloud. 
Code is written for messages in swedish, to change language change following code:
mainLanguage <- 'swedish'
Word cloud for only one texter can be created by changing following code:
words <- filter(words, person == 'Theo' || person == 'Johan') 
to
words <- filter(words, person == 'Theo')
The word cloud is generated as a plot which can be saved as a jpeg or a pdf.

/Johan Wållgren 20180414
