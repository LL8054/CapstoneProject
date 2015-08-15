library(XML)
library(RCurl)
library(httr)

searchResult <- getForm("http://www.google.com/search", hl="en", lr="", q="Texas", btnG="Search")
searchResult <- htmlTreeParse(searchResult)


indicator <- "<span class=>"
posExtractStart <- gregexpr(indicator, searchResult, fixed = TRUE)[[1]]
stringExtract <- substring(searchResult, first=posExtractStart, last = posExtractStart + 30)
#posResults <- gregexpr("value", stringExtract)
posFirst <- stringExtract[[1]][1]
textLength  <- attributes(posResults[[1]])$match.length
stringExtract <- substring(stringExtract, first=posFirst, last = posFirst + textLength)
stringExtract <- gsub("[^0-9]", "", stringExtract)

