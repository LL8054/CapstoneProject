source('~/datasciencecoursera/Courses/Capstone/capstoneproject/ngramTailFinder.R')
source('~/datasciencecoursera/Courses/Capstone/capstoneproject/ngramTailFinder1.R')
library(stringi)
library(tm)
library(quanteda)

NextWordPredictor <- function(input=char(), n=integer(), a=char()){
    enBlogs <- stri_read_lines("~/datasciencecoursera/Courses/Capstone/Coursera-SwiftKey/final/en_US/en_US.blogs.txt") #user 3.437, system .496, elapsed 3.982
    set.seed(100)
    enBlogsSubset <- sample(enBlogs, size=length(enBlogs)*.25, replace=FALSE)
    
    foundTail <- ngramTailFinder(input, n, a)
    enBlogsGrams <- dfm(enBlogsSubset, ngrams = n+1, verbose = TRUE)
    enBlogsGramsFreq <- topfeatures(enBlogsGrams, n = nfeature(enBlogsGrams)) 
    enBlogsGramsFreq.prune <- enBlogsGramsFreq[enBlogsGramsFreq > 1]
    foundGrams <- enBlogsGramsFreq.prune[grepl(paste(c("^", foundTail), collapse=""),names(enBlogsGramsFreq.prune))]
    for (i in 1:length(foundGrams)){
        names(foundGrams)[i] <- ngramTailFinder1(names(foundGrams)[i], "_")
    }
    return(foundGrams)
}