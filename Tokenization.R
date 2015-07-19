#Tokenization 
library(tm)
library(SnowballC)
library(quanteda) # download package from devtools::install_github("kbenoit/quanteda"), then install pkg

##### Building the Corpus

setwd("~/LL/Coursera/Courses/Capstone/CapstoneProject")
path <- "~/LL/Coursera/Courses/Capstone/Coursera-SwiftKey/final/"

#read in files
enBlogs <- readLines("~/LL/Coursera/Courses/Capstone/Coursera-SwiftKey/final/en_US/en_US.blogs.txt")
enNews <- readLines("~/LL/Coursera/Courses/Capstone/Coursera-SwiftKey/final/en_US/en_US.news.txt")
enTwitter <- readLines("~/LL/Coursera/Courses/Capstone/Coursera-SwiftKey/final/en_US/en_US.twitter.txt")

#subset enBlogs to 10%
set.seed(1)
enBlogs.subset <- enBlogs[rbinom(n = length(enBlogs), size = length(enBlogs), prob = .1)]
a <- grep("deleteme", iconv(enBlogs.subset, "latin1", "ASCII", sub="deleteme"))
enBlogs.subset <- enBlogs.subset[-a]
rm(enBlogs)

#subset enNews to 10%
set.seed(1)
enNews.subset <- enNews[rbinom(n = length(enNews), size = length(enNews), prob = .1)]
a <- grep("deleteme", iconv(enNews.subset, "latin1", "ASCII", sub="deleteme"))
enNews.subset <- enNews.subset[-a]
rm(enNews)

#subset enTwitter to 10%
set.seed(1)
enTwitter.subset <- enTwitter[rbinom(n = length(enTwitter), size = length(enTwitter), prob = .1)]
a <- grep("deleteme", iconv(enTwitter.subset, "latin1", "ASCII", sub="deleteme"))
enTwitter.subset <- enTwitter.subset[-a]
rm(enTwitter)

#write subsets to files
write.csv(enBlogs.subset, file="~/LL/Coursera/Courses/Capstone/Subsets/enBlogs.subset.csv", 
          row.names=FALSE, col.names=FALSE)
write.csv(enNews.subset, file="~/LL/Coursera/Courses/Capstone/Subsets/enNews.subset.csv", 
          row.names=FALSE, col.names=FALSE)
write.csv(enTwitter.subset, file="~/LL/Coursera/Courses/Capstone/Subsets/enTwitter.subset.csv", 
          row.names=FALSE, col.names=FALSE)

#combine subsets to make one large subset
en.subset <- c(enBlogs.subset, enNews.subset, enTwitter.subset)
dfm(en.subset, ignoredFeatures = stopwords("english"), stem = TRUE)

#combine files to make a Corpus
enCorpus <- Corpus(DirSource("~/LL/Coursera/Courses/Capstone/Subsets/"), 
                   readerControl=list(language="en_US")) 

##### Cleaning the text within the Corpus

#using predefined transformations from getTransformations()
enClean <- tm_map(enCorpus, removeNumbers)
enClean <- tm_map(enClean, removePunctuation)
enClean <- tm_map(enClean, tolower)
swearWords <- read.csv("~/LL/Coursera/Courses/Capstone/CapstoneProject/swearWords.csv", header=FALSE,
                       stringsAsFactors=FALSE) # as downloaded from http://www.bannedwordlist.com/
swearWords <- paste(swearWords[1:length(swearWords)])
enClean <- tm_map(enClean, removeWords, swearWords)
enClean <- tm_map(enClean, stripWhitespace)

enClean.analyze <- tm_map(enClean, removeWords, stopwords("english")) # remove most common En words to speed 
        #up initial analysis
enClean.analyze <- tm_map(enClean.analyze, stemDocument, language="english")
enClean.analyze <- tm_map(enClean.analyze, PlainTextDocument)
enClean.analyze.dtm <- DocumentTermMatrix(enClean.analyze)
