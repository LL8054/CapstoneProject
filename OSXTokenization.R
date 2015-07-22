#Tokenization 
library(tm)
library(SnowballC)
library(quanteda) # download package from devtools::install_github("kbenoit/quanteda"), then install pkg
library(caTools)

##### Building the Corpus

## For OSX
setwd("~/datasciencecoursera/Courses/Capstone/capstoneproject")
path <- "~/datasciencecoursera/Courses/Capstone/Coursera-SwiftKey/final"

#read in files for OSX
enBlogs <- readLines("~/datasciencecoursera/Courses/Capstone/Coursera-SwiftKey/final/en_US/en_US.blogs.txt")
enNews <- readLines("~/datasciencecoursera/Courses/Capstone/Coursera-SwiftKey/final/en_US/en_US.news.txt")
enTwitter <- readLines("~/datasciencecoursera/Courses/Capstone/Coursera-SwiftKey/final/en_US/en_US.twitter.txt")

#subset enBlogs to .1%
set.seed(1)
enBlogs.subset <- enBlogs[rbinom(n = length(enBlogs), size = length(enBlogs), prob = .001)]
a <- grep("deleteme", iconv(enBlogs.subset, "latin1", "ASCII", sub="deleteme"))
enBlogs.subset <- enBlogs.subset[-a]
rm(enBlogs)

#subset enNews to .1%
set.seed(1)
enNews.subset <- enNews[rbinom(n = length(enNews), size = length(enNews), prob = .001)]
a <- grep("deleteme", iconv(enNews.subset, "latin1", "ASCII", sub="deleteme"))
enNews.subset <- enNews.subset[-a]
rm(enNews)

#subset enTwitter to .1%
set.seed(1)
enTwitter.subset <- enTwitter[rbinom(n = length(enTwitter), size = length(enTwitter), prob = .001)]
a <- grep("deleteme", iconv(enTwitter.subset, "latin1", "ASCII", sub="deleteme"))
enTwitter.subset <- enTwitter.subset[-a]
rm(enTwitter)

#write subsets to files for OSX
write.csv(enBlogs.subset, file="~/datasciencecoursera/Courses/Capstone/Subsets/enBlogs.subset.csv", 
          row.names=FALSE, col.names=FALSE)
write.csv(enNews.subset, file="~/datasciencecoursera/Courses/Capstone/Subsets/enNews.subset.csv", 
          row.names=FALSE, col.names=FALSE)
write.csv(enTwitter.subset, file="~/datasciencecoursera/Courses/Capstone/Subsets/enTwitter.subset.csv", 
          row.names=FALSE, col.names=FALSE)

#write large en.subset to file for OSX
write.csv(en.subset, file="~/datasciencecoursera/Courses/Capstone/Subset2/en.subset.csv", 
          row.names=FALSE, col.names=FALSE)

#combine subsets to make one large subset
en.subset <- c(enBlogs.subset, enNews.subset, enTwitter.subset)
#enCorpus <- Corpus(VectorSource(en.subset))  #//writes corpus from within R
#enCorpus <- Corpus(DirSource("~/datasciencecoursera/Courses/Capstone/Subsets/"), 
#                   readerControl=list(language="en_US")) #//writes corpus from 3 different files
system.time(enCorpus <- Corpus(DirSource("~/datasciencecoursera/Courses/Capstone/Subset2/"), 
                   readerControl=list(language="en_US"))) #//writes corpus from 1 file
enClean <- tm_map(enCorpus, removeNumbers)
enClean <- tm_map(enClean, removePunctuation)
enClean <- tm_map(enClean, content_transformer(tolower))
swearWords <- read.csv("~/datasciencecoursera/Courses/Capstone/CapstoneProject/swearWords.csv", header=FALSE,
                       stringsAsFactors=FALSE) # as downloaded from http://www.bannedwordlist.com/
swearWords <- paste(swearWords[1:length(swearWords)])
enClean <- tm_map(enClean, removeWords, swearWords)
enClean <- tm_map(enClean, stripWhitespace)
system.time(corpus <- data.frame(text=unlist(sapply(enClean, `[`, "content")), 
                                stringsAsFactors=F))
system.time(corpus.dfm <- as.dfm(corpus))
system.time(en.ngrams <- dfm(corpus, ngrams = 1:10, verbose = FALSE))

en.dfm <- dfm(en.subset, ignoredFeatures = stopwords("english"), stem = TRUE)
#system.time for above line: user 239.749, system 23.150, elapsed 279.794
write.csv(en.dfm, file="~/datasciencecoursera/Courses/Capstone/Subsets/en.dfm.csv", 
          row.names=FALSE, col.names=FALSE)
topwords <- topfeatures(en.dfm)


en.ngrams <- dfm(en.subset, ngrams = 1:10, verbose = FALSE)
#system.time for above line: user 3058.536, system 1910.045, elapsed 7774.843
ngrams1 <- as.data.frame(en.ngrams[1])