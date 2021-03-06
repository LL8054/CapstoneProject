library(stringi)
library(tm) 
library(quanteda)
library(RWeka)
library(tm)
library(tau)


CreateNgrams <- function(n=numeric()){
    enBlogs <- stri_read_lines("~/datasciencecoursera/Courses/Capstone/Coursera-SwiftKey/final/en_US/en_US.blogs.txt") #user 3.437, system .496, elapsed 3.982
    set.seed(100)
    enBlogsSubset <- sample(enBlogs, size=length(enBlogs)*n, replace=FALSE)
    
    enTwitter <- readLines("~/datasciencecoursera/Courses/Capstone/Coursera-SwiftKey/final/en_US/en_US.twitter.txt")
    set.seed(100)
    enTwitterSubset <- sample(enTwitter, size=length(enTwitter)*n, replace=FALSE)
    
    enNews <- stri_read_lines("~/datasciencecoursera/Courses/Capstone/Coursera-SwiftKey/final/en_US/en_US.news.txt")
    set.seed(100)
    enNewsSubset <- sample(enNews, size=length(enNews)*n, replace=FALSE)
    
    subset <- c(enBlogsSubset, enTwitterSubset, enNewsSubset)
    
    
    system.time(input <- strsplit(subset, "[,.:;?!]\\s*")) #elapsed 107.209 for 90%
    system.time(saveRDS(input, file = "~/datasciencecoursera/Courses/Capstone/Subsets/Input.rds")) #elapsed 62.37
    
    system.time(inputCorpus <- Corpus(VectorSource(input))) #elapsed 3995.901
    system.time(saveRDS(inputCorpus, file = "~/datasciencecoursera/Courses/Capstone/Subsets/inputCorpus.rds")) #elapsed 475.192
    
    system.time(inputClean <- tm_map(inputCorpus, removeNumbers))
    system.time(saveRDS(inputClean, file = "~/datasciencecoursera/Courses/Capstone/Subsets/inputCleanNums.rds"))
    
    system.time(inputClean <- tm_map(inputClean, removeWords, stopwords("english"))) 
    system.time(saveRDS(inputClean, file = "~/datasciencecoursera/Courses/Capstone/Subsets/inputCleanStops.rds"))
    
    system.time(inputClean <- tm_map(inputClean, removePunctuation))
    skystem.time(saveRDS(inputClean, file = "~/datasciencecoursera/Courses/Capstone/Subsets/inputCleanPunc.rds"))
    
    system.time(inputClean <- tm_map(inputClean, content_transformer(tolower)))
    system.time(saveRDS(inputClean, file = "~/datasciencecoursera/Courses/Capstone/Subsets/inputCleanLower.rds"))
    
    swearWords <- readLines("~/datasciencecoursera/Courses/Capstone/CapstoneProject/swearWords.csv") # as downloaded from http://www.bannedwordlist.com/
    swearWords <- paste(swearWords[1:length(swearWords)])
    system.time(inputClean <- tm_map(inputClean, removeWords, swearWords))
    system.time(saveRDS(inputClean, file = "~/datasciencecoursera/Courses/Capstone/Subsets/inputCleanSwears.rds"))
    
    system.time(inputClean <- tm_map(inputClean, stripWhitespace))
    system.time(saveRDS(inputClean, file = "~/datasciencecoursera/Courses/Capstone/Subsets/inputCleanSpaces.rds"))
    
#     Creating Ngrams without tokenizing using dfm()    
#     system.time(Unigrams <- dfm(subset, ngrams = 1, verbose = TRUE))
#     system.time(saveRDS(Unigrams, file = "~/datasciencecoursera/Courses/Capstone/Subsets/Unigrams.rds"))
#     
#     system.time(Bigrams <- dfm(subset, ngrams = 2, verbose = TRUE))
#     system.time(saveRDS(Bigrams, file = "~/datasciencecoursera/Courses/Capstone/Subsets/Bigrams.rds"))
#     
#     system.time(Trigrams <- dfm(subset, ngrams=3, verbose = TRUE))
#     system.time(saveRDS(Trigrams, file = "~/datasciencecoursera/Courses/Capstone/Subsets/Trigrams.rds"))
#     
#     system.time(Quadgrams <- dfm(subset, ngrams=4, verbose = TRUE))
#     system.time(saveRDS(Quadgrams, file = "~/datasciencecoursera/Courses/Capstone/Subsets/Quadgrams.rds"))
#     
#     system.time(Pentagrams <- dfm(subset, ngrams=5, verbose = TRUE))
#     system.time(saveRDS(Pentagrams, file = "~/datasciencecoursera/Courses/Capstone/Subsets/Pentagrams.rds"))
#     
#     system.time(Hexagrams <- dfm(subset, ngrams=6, verbose = TRUE))
#     system.time(saveRDS(Hexagrams, file = "~/datasciencecoursera/Courses/Capstone/Subsets/Hexagrams.rds"))
   
   
    
    
    
    
    
    