library(tm)
library(stringi)
library(RWeka)
library(SnowballC)
library(slam)
library(data.table)
library(tidyr)

enBlogs <- stri_read_lines("~/datasciencecoursera/Courses/Capstone/Coursera-SwiftKey/final/en_US/en_US.blogs.txt",
                           encoding="UTF-8") 
set.seed(100)
enBlogsSubset <- sample(enBlogs, size=length(enBlogs)*.25, replace=FALSE)

enTwitter <- readLines("~/datasciencecoursera/Courses/Capstone/Coursera-SwiftKey/final/en_US/en_US.twitter.txt",
                       encoding="UTF-8")
set.seed(100)
enTwitterSubset <- sample(enTwitter, size=length(enTwitter)*.25, replace=FALSE)

enNews <- stri_read_lines("~/datasciencecoursera/Courses/Capstone/Coursera-SwiftKey/final/en_US/en_US.news.txt",
                          encoding="UTF-8")
set.seed(100)
enNewsSubset <- sample(enNews, size=length(enNews)*.25, replace=FALSE)

subset <- c(enBlogsSubset, enTwitterSubset, enNewsSubset)

input <- strsplit(subset, "[,.:;?!]\\s*")
inputCorpus <- Corpus(VectorSource(input), readerControl = list(language="en_US"))
inputClean <- tm_map(inputCorpus, content_transformer(removeNumbers))
inputClean <- tm_map(inputClean, removeWords, stopwords("english"))
inputClean <- tm_map(inputClean, content_transformer(removePunctuation))
inputClean <- tm_map(inputClean, content_transformer(tolower))
swearWords <- readLines("~/datasciencecoursera/Courses/Capstone/CapstoneProject/swearWords.csv") # as downloaded from http://www.bannedwordlist.com/
swearWords <- paste(swearWords[1:length(swearWords)])
inputClean <- tm_map(inputClean, removeWords, swearWords)
inputClean <- tm_map(inputClean, content_transformer(stripWhitespace))
inputClean <- tm_map(inputClean, PlainTextDocument)
saveRDS(inputClean, file = "~/datasciencecoursera/Courses/Capstone/Subsets/Subset.rds")