rm(list=ls())
options(warn=-1)
source('~/datasciencecoursera/Courses/Capstone/capstoneproject/ngramTailFinder.R')
source('~/datasciencecoursera/Courses/Capstone/capstoneproject/ngramTailFinder1.R')
library(stringi)
library(tm) 
library(quanteda)
library(RWeka)
library(tm)
library(tau)

NextWordPredictor <- function(input=char(), n=integer(), a=char()){
    
    
    
    foundTail <- ngramTailFinder(input, n, a)
    
    if (n == 0) {grams <- readRDS("~/datasciencecoursera/Courses/Capstone/Subsets/Unigrams.rds")}
    if (n == 1) {grams <- readRDS("~/datasciencecoursera/Courses/Capstone/Subsets/Bigrams.rds")}
    if (n == 2) {grams <- readRDS("~/datasciencecoursera/Courses/Capstone/Subsets/Trigrams.rds")}
    gramsFreq <- topfeatures(grams, n = nfeature(grams)) 
    #enBlogsGramsFreq.prune <- enBlogsGramsFreq[enBlogsGramsFreq > 1]
    #foundGrams <- enBlogsGramsFreq.prune[grepl(paste(c("^", foundTail), collapse=""),names(enBlogsGramsFreq.prune))]
    foundGrams <- gramsFreq[grepl(paste(c("^", foundTail), collapse=""),names(gramsFreq))]
    if(length(foundGrams) < 1) {
        
        ###########################################################################################
        ###################### build stemmed and stopped trigrams from input ######################
        ###########################################################################################
        input2 <- strsplit(input, "[,.:;?!]\\s*")
        inputCorpus <- Corpus(VectorSource(input2))
        inputClean <- tm_map(inputCorpus, removeNumbers)
        inputClean <- tm_map(inputClean, removeWords, stopwords("english")) 
        inputClean <- tm_map(inputClean, removePunctuation)
        inputClean <- tm_map(inputClean, content_transformer(tolower))
        swearWords <- readLines("~/datasciencecoursera/Courses/Capstone/CapstoneProject/swearWords.csv") # as downloaded from http://www.bannedwordlist.com/
        swearWords <- paste(swearWords[1:length(swearWords)])
        inputClean <- tm_map(inputClean, removeWords, swearWords)
        inputClean <- tm_map(inputClean, stripWhitespace)
        
        df <- data.frame(text=unlist(sapply(inputClean, `[`, "content")), stringsAsFactors=F)
        lastWords <- (df[nrow(df), ncol(df)])
        lastWordsCount <- length(unlist(strsplit(df[nrow(df), ncol(df)], " ")))
        foundFailTail <- ngramTailFinder(lastWords, lastWordsCount, " ")
        
        #next 5 lines are unnecessary if i don't need to tokenize through DTM()
        #options(mc.cores = 1)
        #require(tm)
        #require(RWeka)
        #TrigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
        #tri <- DocumentTermMatrix(inputClean, control = list(tokenize = TrigramTokenizer))
        #use next line to manually view tri results
        #findFreqTerms(tri, lowfreq=1)
        
        #delete next 4 lines if previous TermDocumentMatrix() line with TrigramTokenizer work
        #TrigramTokenizer <- function(x, n=3) return(rownames(as.data.frame(unclass(textcnt(x,method="string",n=3)))))
        #Trigrams
        #tri <- DocumentTermMatrix(inputClean, control = list(tokenize=TrigramTokenizer, 
        #                                                     bounds = list(global = c(1, Inf)), wordLengths=c(3, Inf)))
        
        #delete next 2 lines if no tokenizers needed at all
        #triFreq <- sort(colSums(as.matrix(tri)), decreasing = TRUE)
        #failTrigrams <- triFreq
        
        #following dfm() line doesn't work to create ngrams with removed stopwords
        #dfm(input, ngrams= n+1, ignoredFeatures = stopwords("english"), stem = TRUE, verbose = TRUE)
        
        ###########################################################################################
        ################## build stemmed and stopped trigrams from corpus subset ##################
        ###########################################################################################
        subset2 <- strsplit(subset, "[,.:;?!]\\s*")
        corpus <- Corpus(VectorSource(subset2))
        clean <- tm_map(corpus, removeNumbers)
        clean <- tm_map(clean, removeWords, stopwords("english")) 
        clean <- tm_map(clean, removePunctuation)
        clean <- tm_map(clean, content_transformer(tolower))
        swearWords <- readLines("~/datasciencecoursera/Courses/Capstone/CapstoneProject/swearWords.csv") # as downloaded from http://www.bannedwordlist.com/
        swearWords <- paste(swearWords[1:length(swearWords)])
        clean <- tm_map(clean, removeWords, swearWords)
        clean <- tm_map(clean, stripWhitespace)
        
        DF <- data.frame(text=unlist(sapply(clean, `[`, "content")), stringsAsFactors=F)
        allClean <- unlist(strsplit(DF[,1], " "))
        allClean <- paste(allClean, collapse = " ")
        allCleanTrigrams <- dfm(allClean, ignoredFeatures = stopwords("english"), stem = TRUE, ngrams = 3, verbose = FALSE)
        allCleanTrigramsFreq <- colSums(allCleanTrigrams)
        allCleanTrigramsFreq <- sort(allCleanTrigramsFreq, decreasing=TRUE) 
        #next 5 lines are unnecessary if i don't need to tokenize through DTM()
        #options(mc.cores = 1)
        #require(tm)
        #require(RWeka)
        #TrigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
        #enBlogsTrigrams <- DocumentTermMatrix(enBlogsClean, control = list(tokenize = TrigramTokenizer))
        #use next line to manually view tri results
        #findFreqTerms(enBlogsTrigrams, lowfreq=1)
        
        #do these next 3 lines even work?
        #triBlogs <- DocumentTermMatrix(enBlogsClean, control = list(tokenize=TrigramTokenizer, 
        #       bounds = list(global = c(1, Inf)), wordLengths=c(3, Inf)))
        #triBlogsFreq <- sort(colSums(as.matrix(triBlogs)), decreasing = TRUE)
        
        failTrigrams <- allCleanTrigramsFreq
        
        foundFailGrams <- failTrigrams[grepl(paste(c("^", foundFailTail), collapse=""),
                                                  names(failTrigrams))]
        
        if(length(foundFailGrams) < 1) {
            cout <- "sorry, no word predicted.  try again with a shorter ngram."
            print(cout)
        }
        else {
            for (i in 1:length(foundFailGrams)){
                names(foundFailGrams)[i] <- ngramTailFinder1(names(foundFailGrams)[i], "_")
            }
            print(foundFailGrams)
        }
        
        
    }
    else{
        for (i in 1:length(foundGrams)){
            names(foundGrams)[i] <- ngramTailFinder1(names(foundGrams)[i], "_")
        }
        print(foundGrams)
    }
}