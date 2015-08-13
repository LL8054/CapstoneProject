library(RWeka)
library(tm)
library(tau)

input <- "Very early observations on the Bills game: Offense still struggling but the"
#col <- removeFeatures(collocations(input, size=3), stopwords="english")

input <- strsplit(input, "[,.:;?!]\\s*")
inputCorpus <- Corpus(VectorSource(input))
inputClean <- tm_map(inputCorpus, removeNumbers)
inputClean <- tm_map(inputClean, removeWords, stopwords("english")) 
inputClean <- tm_map(inputClean, removePunctuation)
inputClean <- tm_map(inputClean, content_transformer(tolower))
swearWords <- readLines("~/datasciencecoursera/Courses/Capstone/CapstoneProject/swearWords.csv") # as downloaded from http://www.bannedwordlist.com/
swearWords <- paste(swearWords[1:length(swearWords)])
inputClean <- tm_map(inputClean, removeWords, swearWords)
inputClean <- tm_map(inputClean, stripWhitespace)

inputDTM <- DocumentTermMatrix(inputClean, control = list(wordLengths = c(3, Inf)))

options(mc.cores = 1)

#BigramTokenizer <- function(x, n=2) return(rownames(as.data.frame(unclass(textcnt(x,method="string",n=n)))))
#TrigramTokenizer <- function(x, n=3) return(rownames(as.data.frame(unclass(textcnt(x,method="string",n=n)))))
#QuadgramTokenizer <- function(x, n=4) return(rownames(as.data.frame(unclass(textcnt(x,method="string",n=n)))))
#PentagramTokenizer <- function(x, n=5) return(rownames(as.data.frame(unclass(textcnt(x,method="string",n=n)))))
#HexagramTokenizer <- function(x, n=6) return(rownames(as.data.frame(unclass(textcnt(x,method="string",n=n)))))

BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
TrigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
QuadgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))


#Unigrams
uni <- DocumentTermMatrix(inputClean, control = list(minDocFreq = 10, wordLengths=c(3, Inf)))
uniFreq <- sort(colSums(as.matrix(uni)), decreasing=TRUE)

#Bigrams
bi <- DocumentTermMatrix(inputClean, control = list(tokenize=BigramTokenizer, 
        bounds = list(global = c(1, Inf)), wordLengths=c(3, Inf)))
biFreq <- sort(colSums(as.matrix(bi)), decreasing = TRUE)

#Trigrams
tri <- DocumentTermMatrix(inputClean, control = list(tokenize=TrigramTokenizer, 
        bounds = list(global = c(1, Inf)), wordLengths=c(3, Inf)))
triFreq <- sort(colSums(as.matrix(tri)), decreasing = TRUE)

#Quadgrams
quad <- DocumentTermMatrix(inputClean, control = list(tokenize=QuadgramTokenizer, 
        bounds = list(global = c(1, Inf)), wordLengths=c(3, Inf)))
quadFreq <- sort(colSums(as.matrix(quad)), decreasing = TRUE)

#Pentagrams
penta <- DocumentTermMatrix(inputClean, control = list(tokenize=PentagramTokenizer, 
        bounds = list(global = c(1, Inf)), wordLengths=c(3, Inf)))
pentaFreq <- sort(colSums(as.matrix(penta)), decreasing = TRUE)

#Hexagrams
hexa <- DocumentTermMatrix(inputClean, control = list(tokenize=HexagramTokenizer, 
        bounds = list(global = c(1, Inf)), wordLengths=c(3, Inf)))
hexaFreq <- sort(colSums(as.matrix(hexa)), decreasing = TRUE)
