library(tm)
library(SnowballC)
library(quanteda) # download package from devtools::install_github("kbenoit/quanteda"), then install pkg
library(caTools)
library(wordcloud)
library(data.table)
library(stringi)

setwd("~/datasciencecoursera/Courses/Capstone/capstoneproject")
path <- "~/datasciencecoursera/Courses/Capstone/Coursera-SwiftKey/final"

#english blogs
enBlogs <- readLines("~/datasciencecoursera/Courses/Capstone/Coursera-SwiftKey/final/en_US/en_US.blogs.txt")
enBlogsLines <- length(enBlogs)
enBlogsChars <- sum(nchar(enBlogs))
enBlogsWords <- unlist(strsplit(enBlogs," ")) 
enBlogsNumWords <- length(enBlogsWords)
enBlogsWordsUnique <- length(unique(enBlogsWords))

#english twitter
enTwitter <- readLines("~/datasciencecoursera/Courses/Capstone/Coursera-SwiftKey/final/en_US/en_US.twitter.txt")
enTwitterLines <- length(enTwitter)
enTwitterChars <- sum(nchar(enTwitter))
enTwitterWords <- unlist(strsplit(enTwitter,split=" ")) 
enTwitterNumWords <- length(enTwitterWords)
enTwitterWordsUnique <- length(unique(enTwitterWords))

#english news
enNews <- readLines("~/datasciencecoursera/Courses/Capstone/Coursera-SwiftKey/final/en_US/en_US.news.txt")
enNewsLines <- length(enNews)
enNewsChars <- sum(nchar(enNews))
enNewsWords <- unlist(strsplit(enNews,split=" ")) 
enNewsNumWords <- length(enNewsWords)
enNewsWordsUnique <- length(unique(enNewsWords))

#subsets
enBlogsSubset <- sample(enBlogs, size=enBlogsLines*.01, replace=FALSE) #8992 lines
enTwitterSubset <- sample(enTwitter, size=enTwitterLines*.01, replace=FALSE) #23601 lines
enNewsSubset <- sample(enNews, size=enNewsLines*.01, replace=FALSE) #10102 lines
enSubset <- c(enBlogsSubset, enTwitterSubset, enNewsSubset) #for dfm


###################################################################################################
############################################# DFM BEGIN ###########################################
###################################################################################################
#dfm
system.time(en.dfm <- dfm(enSubset)) #user 2.495, system .188, elapsed 2.756
system.time(en.dfm.unigrams <- dfm(enSubset, ngrams = 1, verbose = FALSE)) 
    #user 2.096, system .12, elapsed 2.233

#dfm with stemming sans stopwords
system.time(en.analyze.dfm <- dfm(enSubset, ignoredFeatures = stopwords("english"), stem = TRUE))
    #user 2.78, system .12, elapsed 2.919


######################       analyzing ngrams
#uni
en.analyze.dfm.unigrams <- dfm(enSubset, ignoredFeatures = stopwords("english"),
                               stem = TRUE, ngrams = 1, verbose = FALSE)
system.time(en.analyze.dfm.uni.freq <- colSums(as.matrix(en.analyze.dfm.unigrams)))
    #user 15.017, system 44.339, elapsed 82.617 
uni.freq <- sort(en.analyze.dfm.uni.freq, decreasing=TRUE) 
uni.freq.prune <- as.numeric()
for (i in 1:length(uni.freq)) { 
    if (uni.freq[i] > 10) {
        uni.freq.prune <- c(uni.freq.prune, uni.freq[i]) }
}

#words in context
uni.freq.prune.df <- as.data.frame(uni.freq.prune)
words <- rownames(uni.freq.prune.df)
kwic(enSubset, words[5540], 3)

#2gram
en.analyze.dfm.bigrams <- dfm(enSubset, ignoredFeatures = stopwords("english"), stem = TRUE, ngrams = 2, verbose = FALSE)
en.analyze.dfm.bi.freq <- colSums(en.analyze.dfm.bigrams)
bi.freq <- sort(en.analyze.dfm.bi.freq, decreasing=TRUE) 
bi.freq.prune <- as.numeric()
for (i in 1:length(bi.freq)) { 
    if (bi.freq[i] > 10) {
        bi.freq.prune <- c(bi.freq.prune, bi.freq[i]) }
}

#3gram
en.analyze.dfm.trigrams <- dfm(enSubset, ignoredFeatures = stopwords("english"), stem = TRUE, ngrams = 3, verbose = FALSE)
en.analyze.dfm.tri.freq <- colSums(en.analyze.dfm.trigrams)
tri.freq <- sort(en.analyze.dfm.tri.freq, decreasing=TRUE) 
tri.freq.prune <- as.numeric()
for (i in 1:length(tri.freq)) { 
    if (tri.freq[i] > 10) {
        tri.freq.prune <- c(tri.freq.prune, tri.freq[i]) }
}

#4gram
en.analyze.dfm.quadgrams <- dfm(enSubset, ignoredFeatures = stopwords("english"), stem = TRUE, ngrams = 4, verbose = FALSE)
en.analyze.dfm.quad.freq <- colSums(en.analyze.dfm.quadgrams)
quad.freq <- sort(en.analyze.dfm.quad.freq, decreasing=TRUE) 
quad.freq.prune <- as.numeric()
for (i in 1:length(quad.freq)) { 
    if (quad.freq[i] > 10) {
        quad.freq.prune <- c(quad.freq.prune, quad.freq[i]) }
}

quad.freq.prune.df <- as.data.frame(quad.freq.prune)
words.quad <- rownames(quad.freq.prune.df)
kwic(enSubset, "water", 3)

#5gram
en.analyze.dfm.pentagrams <- dfm(enSubset, ignoredFeatures = stopwords("english"), stem = TRUE, ngrams = 5, verbose = FALSE)
en.analyze.dfm.penta.freq <- colSums(en.analyze.dfm.pentagrams)
penta.freq <- sort(en.analyze.dfm.penta.freq, decreasing=TRUE) 
penta.freq.prune <- as.numeric()
for (i in 1:length(penta.freq)) { 
    if (penta.freq[i] > 10) {
        penta.freq.prune <- c(penta.freq.prune, penta.freq[i]) }
}

source('~/datasciencecoursera/Courses/Capstone/capstoneproject/fixNgram.R')
xlabel.pentagram <- rownames((as.data.frame(penta.freq.prune)))
pentagram.char <- fixNgram(xlabel.pentagram, 5)

#6gram
en.analyze.dfm.hexagrams <- dfm(enSubset, ignoredFeatures = stopwords("english"), stem = TRUE, ngrams = 6, verbose = FALSE)
en.analyze.dfm.hexa.freq <- colSums(en.analyze.dfm.hexagrams)
hexa.freq <- sort(en.analyze.dfm.hexa.freq, decreasing=TRUE) 
hexa.freq.prune <- as.numeric()
for (i in 1:length(hexa.freq)) { 
    if (hexa.freq[i] > 10) {
        hexa.freq.prune <- c(hexa.freq.prune, hexa.freq[i]) }
}


###################################################################################################
############################################# DFM OVER ############################################
###################################################################################################

#write subsets to CVS
#system.time(write.csv(enBlogsSubset, file="~/datasciencecoursera/Courses/Capstone/Subsets/enBlogsSubset.csv", 
#          row.names=FALSE, col.names=FALSE)) #user .397, system .007, elapsed .421
system.time(writeLines(enBlogsSubset, "~/datasciencecoursera/Courses/Capstone/Subsets/enBlogsSubset.txt",
                       sep="\n", useBytes=FALSE))  #user .005, system .004, elapsed .015
system.time(writeLines(enTwitterSubset, "~/datasciencecoursera/Courses/Capstone/Subsets/enTwittersSubset.txt",
                       sep="\n", useBytes=FALSE))
system.time(writeLines(enNewsSubset, "~/datasciencecoursera/Courses/Capstone/Subsets/enNewsSubset.txt",
                       sep="\n", useBytes=FALSE))
rm(list=ls())

#write the Corpus
system.time(enCorpus <- Corpus(DirSource("~/datasciencecoursera/Courses/Capstone/Subsets/"), 
                   readerControl=list(language="en_US"))) 
                    #//writes corpus from 3 different files, user .801, system .004, elapsed .804
#clean the Corpus
enClean <- tm_map(enCorpus, removeNumbers)
enClean <- tm_map(enClean, removePunctuation)
enClean <- tm_map(enClean, content_transformer(tolower))
swearWords <- readLines("~/datasciencecoursera/Courses/Capstone/CapstoneProject/swearWords.csv") # as downloaded from http://www.bannedwordlist.com/
swearWords <- paste(swearWords[1:length(swearWords)])
enClean <- tm_map(enClean, removeWords, swearWords)
enClean <- tm_map(enClean, stripWhitespace)
#convert to DTM
system.time(enClean.dtm <- DocumentTermMatrix(enClean)) #user 2.246, system .176, elapsed 4.172

#term frequencies
enClean.dtm.freqs <- colSums(as.matrix(enClean.dtm))
freq <- sort(enClean.dtm.freqs, decreasing=TRUE)
barplot(freq[1:25], main="25 Most Frequent Words", xlab="Words", ylab="Occurances", col='green',
        las=2, cex.lab=.75, yaxt="n", xaxt="n")
xlabel <- rownames((as.data.frame(head(freq,25))))
axis(1, cex.axis=.5, labels=xlabel, at=1:25, las=2)
axis(2, cex.axis=.5, las=2)

#word cloud
top100words <- as.data.frame(head(freq, 100))
wordcloud(rownames(top100words), top100words[,1], scale=c(2,.1), 
          colors=brewer.pal(8, "Dark2"))

#remove stop words and stem
enClean.analyze <- tm_map(enClean, removeWords, stopwords("english")) 
enClean.analyze <- tm_map(enClean.analyze, stemDocument, language="english")
system.time(enClean.analyze.dtm <- DocumentTermMatrix(enClean.analyze))

#25 most frequent words after stemming sans stop words
enClean.analyze.dtm.freqs <- colSums(as.matrix(enClean.analyze.dtm))
freq.analyze <- sort(enClean.analyze.dtm.freqs, decreasing=TRUE)
barplot(freq.analyze[1:25], main="25 Most Frequent Words", xlab="Words", ylab="Occurances", col='green',
        las=2, cex.lab=.75, yaxt="n", xaxt="n")
xlabel.analyze <- rownames((as.data.frame(head(freq.analyze,25))))
axis(1, cex.axis=.5, labels=xlabel.analyze, at=1:25, las=2)
axis(2, cex.axis=.5, las=2)

#word cloud after stemming sans stop words
top100words.analyze <- as.data.frame(head(freq.analyze, 100))
wordcloud(rownames(top100words.analyze), top100words.analyze[,1], scale=c(2,.1), 
          colors=brewer.pal(8, "Dark2"))




