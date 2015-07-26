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
    
    Unigrams <- dfm(subset, ngrams = 1, verbose = TRUE)
    Bigrams <- dfm(subset, ngrams = 2, verbose = TRUE)
    Trigrams <- dfm(subset, ngrams=3, verbose = TRUE)
    Quadgrams <- dfm(subset, ngrams=4, verbose = TRUE)
    Pentagrams <- dfm(subset, ngrams=5, verbose = TRUE)
    Hexagrams <- dfm(subset, ngrams=6, verbose = TRUE)
    
    saveRDS(Unigrams, file = "~/datasciencecoursera/Courses/Capstone/Subsets/Unigrams.rds")
    saveRDS(Bigrams, file = "~/datasciencecoursera/Courses/Capstone/Subsets/Bigrams.rds")
    saveRDS(Trigrams, file = "~/datasciencecoursera/Courses/Capstone/Subsets/Trigrams.rds")
    saveRDS(Quadgrams, file = "~/datasciencecoursera/Courses/Capstone/Subsets/Quadgrams.rds")
    saveRDS(Pentagrams, file = "~/datasciencecoursera/Courses/Capstone/Subsets/Pentagrams.rds")
    saveRDS(Hexagrams, file = "~/datasciencecoursera/Courses/Capstone/Subsets/Hexagrams.rds")
    
    
    
    
    
    