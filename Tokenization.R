#Tokenization for en_US.twitter.txt

library(tm)

setwd("~/LL/Coursera/Courses/Capstone/CapstoneProject")
path <- "~/LL/Coursera/Courses/Capstone/Coursera-SwiftKey/final/"

enTwitter <- scan(paste(path, "en_US/en_US.twitter.txt", sep=""), what="char", quote="", skipNul=TRUE)

enTwitter.block <- VectorSource(enTwitter)
inspect(Corpus(enTwitter.block))