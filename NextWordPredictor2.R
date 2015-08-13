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

NextWordPredictor <- function(input=char()){
    
    
    input <- tolower(input)
    input <- strsplit(input, " ")[[1]]
    input <- gsub("[,.:;?!']\\s*", "", input)
    inputTail <- tail(input, 3)
    n <- length(inputTail)
    
    if (n == 0) {grams <- readRDS("~/datasciencecoursera/Courses/Capstone/Subsets/Unigrams.rds")}
    if (n == 1) {grams <- readRDS("~/datasciencecoursera/Courses/Capstone/Subsets/Bigrams.rds")}
    if (n == 2) {grams <- readRDS("~/datasciencecoursera/Courses/Capstone/Subsets/Trigrams.rds")}
    if (n == 3) {grams <- readRDS("~/datasciencecoursera/Courses/Capstone/Subsets/Quadgrams.rds")}
    gramsFreq <- topfeatures(grams, n = nfeature(grams)) 
    
    foundGrams <- gramsFreq[grepl(paste(c("^", inputTail), collapse=""), names(gramsFreq))]
    if(length(foundGrams) < 1) {
        
        ###########################################################################################
        ###################### build stemmed and stopped trigrams from input ######################
        ###########################################################################################
        input2 <- paste(input, collapse=" ")
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
        lastWords <- strsplit(df[nrow(df), ncol(df)], " ")[[1]]
        foundFailTail <- tail(lastWords, 3)
        
        
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