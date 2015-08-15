#server.R for NLP app

library(shiny)
options(warn=-1)
source('data/ngramTailFinder.R')
source('data/ngramTailFinder1.R')
library(stringi)
library(tm) 
library(quanteda)
library(RWeka)
library(tm)
library(tau)

shinyServer(
    function(input, output){
    
        NextWordPredictor3 <- function(i=char()){
            inp <- tolower(i)
            inp <- strsplit(inp, " ")[[1]]
            inp <- gsub("[,.:;?!']\\s*", "", inp)
            inputTail <- tail(inp, 3)
            n <- as.numeric(length(inputTail))
            
            if (n == 0) {
                grams <- readRDS("data/Unigrams.rds")
                gramsFreq <- topfeatures(grams, n = nfeature(grams))
            }
            if (n == 1) {
                grams <- readRDS("data/bigrams01.rds")
                gramsFreq <- grams[order(count, decreasing=TRUE)]
            }
            if (n == 2) {
                grams <- readRDS("data/trigrams01.rds")
                gramsFreq <- grams[order(count, decreasing=TRUE)]
            }
            if (n == 3) {
                grams <- readRDS("data/quadgrams01.rds")
                gramsFreq <- grams[order(count, decreasing=TRUE)]
            }
            
            
            foundGrams <- gramsFreq[grepl(paste(c("^",paste(inputTail, collapse=" ")), collapse=""), gramsFreq$token)]
            if(identical(as.numeric(nrow(foundGrams)), 0)) {
                
                ###########################################################################################
                ###################### build stemmed and stopped trigrams from input ######################
                ###########################################################################################
                input2 <- paste(input, collapse=" ")
                inputCorpus <- Corpus(VectorSource(input2))
                inputClean <- tm_map(inputCorpus, removeNumbers)
                inputClean <- tm_map(inputClean, removeWords, stopwords("english")) 
                inputClean <- tm_map(inputClean, removePunctuation)
                inputClean <- tm_map(inputClean, content_transformer(tolower))
                swearWords <- readLines("data/swearWords.csv") # as downloaded from http://www.bannedwordlist.com/
                swearWords <- paste(swearWords[1:length(swearWords)])
                inputClean <- tm_map(inputClean, removeWords, swearWords)
                inputClean <- tm_map(inputClean, stripWhitespace)
                
                df <- data.frame(text=unlist(sapply(inputClean, `[`, "content")), stringsAsFactors=F)
                lastWords <- strsplit(df[nrow(df), ncol(df)], " ")[[1]]
                foundFailTail <- tail(lastWords, 3)
                
                
                ###########################################################################################
                ##################  search stemmed and stopped trigrams from 25% subset  ##################
                ###########################################################################################
                
                trigramsDTprune25 <- readRDS("data/trigramsDTprune25.rds")
                trigramsDTprune25 <- trigramsDTprune25[order(count, decreasing=TRUE)]
                
                foundFailGrams <- trigramsDTprune25[grepl(paste(c("^",paste(foundFailTail, collapse=" ")), collapse=""), 
                                                          trigramsDTprune25$token)]
                
                if(identical(as.numeric(nrow(foundFailGrams)),0)) {
                    
                    ###########################################################################################
                    ###########################  search n-1 grams  from 25% subset  ###########################
                    ###########################################################################################
                    
                    inputTail2 <- inputTail[-1]
                    foundGrams2 <- gramsFreq[grepl(paste(c("^",paste(inputTail2, collapse=" ")), collapse=""), gramsFreq$token)]
                    
                    if(identical(as.numeric(nrow(foundGrams2)), 0)){
                        
                        ###########################################################################################
                        ######################  search for last tail word from 25% subset  ########################
                        ###########################################################################################
                        
                        inputTail3 <- inputTail2[length(inputTail2)]
                        foundGrams3 <- gramsFreq[grepl(inputTail3, gramsFreq$token)]
                        
                        if(identical(as.numeric(nrow(foundGrams3)), 0)){
                            cout <- "sorry, no word predicted.  try again with a shorter ngram."
                            print(cout)
                        }
                        else {
                            n3 <- length(inputTail3)
                            foundNames <- names(foundGrams3)
                            foundWords <- as.character()
                            foundWords <- foundGrams3[[n3+1]]
                            if(as.numeric(length(foundWords)) < 4) {
                                print(foundWords)
                            }
                            else {
                                foundWordsShort <- foundWords[1:3]
                                print(foundWordsShort)
                            }
                        }
                    }
                    else {
                        n2 <- length(inputTail2)
                        foundNames <- names(foundGrams2)
                        foundWords <- as.character()
                        foundWords <- foundGrams2[[n2+1]]
                        if(as.numeric(length(foundWords)) < 4) {
                            print(foundWords)
                        }
                        else {
                            foundWordsShort <- foundWords[1:3]
                            print(foundWordsShort)
                        }
                        
                        
                    }
                }
                else {
                    
                    nFail <- length(foundFailTail)
                    foundNames <- names(foundFailGrams)
                    foundWords <- as.character()
                    foundWords <- foundFailGrams[[nFail+1]]
                    if(as.numeric(length(foundWords)) < 4) {
                        print(foundWords)
                    }
                    else {
                        foundWordsShort <- foundWords[1:3]
                        print(foundWordsShort)
                    }
                    
                }
                
                ###########################################################################################
                ################  end search stemmed and stopped trigrams from 25% subset  ################
                ###########################################################################################
                
            }
            else{
                
                foundNames <- names(foundGrams)
                foundWords <- as.character()
                foundWords <- foundGrams[[n+1]]
                if(as.numeric(length(foundWords)) < 4) {
                    print(foundWords)
                }
                else {
                    foundWordsShort <- foundWords[1:3]
                    print(foundWordsShort)
                }
                
            }
        }
        
        output$result <- renderPrint({NextWordPredictor3(input$Input)})
    }
)
