#server.R for NLP app
rm(list=ls())
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
library(shinyIncubator)

shinyServer(
    function(input, output){
        
        NextWordPredictor4 <- function(i=char()){
            inp <- tolower(i)
            inp <- strsplit(inp, " ")[[1]]
            inp <- gsub("[,.:;?!']\\s*", "", inp)
            inputTail <- tail(inp, 3)
            n <- as.numeric(length(inputTail))
            
#             if (n == 0) {
#                 gramsFreq <- readRDS("data/uniFreq.rds")
#                 gramsFreq <- data.table(count=(gramsFreq), token=names(gramsFreq))
#             }
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
            if(identical(as.numeric(nrow(foundGrams)), 0)) { #1
                
                ###########################################################################################
                ###################### build stemmed and stopped trigrams from input ######################
                ###########################################################################################
                input2 <- paste(inp, collapse=" ")
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
                
                if(identical(as.numeric(nrow(foundFailGrams)),0)) { #2
                    
                    ###########################################################################################
                    ###########################  search n-1 grams  from 25% subset  ###########################
                    ###########################################################################################
                    if(length(inputTail) > 1){ #2.1
                        
                        inputTail2 <- inputTail[-1]
                        foundGrams2 <- gramsFreq[grepl(paste(c("^",paste(inputTail2, collapse=" ")), collapse=""), gramsFreq$token)]
                        
                        if(identical(as.numeric(nrow(foundGrams2)), 0)){ #2.1.1
                            
                            ###########################################################################################
                            ######################  search for last tail word from 25% subset  ########################
                            ###########################################################################################
                            
                            inputTail3 <- inputTail2[length(inputTail2)]
                            foundGrams3 <- gramsFreq[grepl(inputTail3, gramsFreq$token)]
                            
                            if(identical(as.numeric(nrow(foundGrams3)), 0)){ #2.1.1.1
                                cout <- "sorry, do you have misspelled words?"
                                print(cout)
                            }
                            else { #2.1.1.1
                                n3 <- length(inputTail3)
                                foundNames <- names(foundGrams3)
                                foundWords <- as.character()
                                foundWords <- foundGrams3[[n3+1]]
                                if(as.numeric(length(foundWords)) < 4) { #2.1.1.1.1
                                    return(foundWords[1])
                                }
                                else { #2.1.1.1.1
                                    foundWordsShort <- foundWords[1]
                                    return(foundWordsShort)
                                }
                            }
                        }
                        else{ #2.1.1
                            
                            n3 <- length(inputTail2)
                            foundNames <- names(foundGrams2)
                            foundWords <- as.character()
                            foundWords <- foundGrams2[[n3+1]]
                            if(as.numeric(length(foundWords)) < 4) { #2.1.1.1
                                return(foundWords[1])
                            }
                            else { #2.1.1.1
                                foundWordsShort <- foundWords[1]
                                return(foundWordsShort)
                            }
                            
                        }
                    }
                    else{ #2.1
                        cout <- "sorry, do you have misspelled words?"
                        print(cout)
                    }
                 }
            
            else { #2
                    
                nFail <- length(foundFailTail)
                #foundNames <- names(foundFailGrams)
                foundWords <- as.character()
                foundWords <- foundFailGrams[[nFail+1]]
                if(as.numeric(length(foundWords)) < 4) { #2.1
                    print(foundWords[1])
                }
                else { #2.1
                    foundWordsShort <- foundWords[1]
                    return(foundWordsShort)
                }
                    
            }
                
            ###########################################################################################
            ################  end search stemmed and stopped trigrams from 25% subset  ################                ###########################################################################################
                
        }
        else{ #1
                
            foundWords <- as.character()
            foundWords <- foundGrams[[n+1]]
            if(as.numeric(length(foundWords)) < 4) {
                return(foundWords[1])
            }
            else {
                foundWordsShort <- foundWords[1]
                return(foundWordsShort)
            }
                
        }
            
    }
        
        
    observe({
        if (input$save == 0)
            return()
            
        isolate({
            output$result <- renderPrint({NextWordPredictor4(input$Input)})
        })
    })
        
   }
)
