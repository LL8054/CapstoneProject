#Tokenization for en_US.twitter.txt

library(tm)

#for windows
setwd("~/LL/Coursera/Courses/Capstone/CapstoneProject") #for windows
path <- "~/LL/Coursera/Courses/Capstone/Coursera-SwiftKey/final/" #for windows

#for osx
setwd("~/datasciencecoursera/Courses/Capstone/capstoneproject") #for osx
path <- "~/datasciencecoursera/Courses/Capstone/Coursera-SwiftKey/final/" #for osx

enTwitter <- scan(paste(path, "en_US/en_US.twitter.txt", sep=""), what="char", quote="", skipNul=TRUE)

enTwitter.block.head <- VectorSource(head(enTwitter, n=1000))
inspect(Corpus(enTwitter.block.head))