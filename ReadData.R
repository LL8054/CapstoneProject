# make sure package "data.table" is installed.  you'll need it for fread.

library(data.table)

setwd("~/LL/Coursera/Courses/Capstone")
path <- "~/LL/Coursera/Courses/Capstone/Coursera-SwiftKey/final/"

GERMAN
deBlogs <- scan(paste(path, "de_DE/de_DE.blogs.txt", sep=""), what="char", sep="", quote="")
deNews <- scan(paste(path, "de_DE/de_DE.news.txt", sep=""), what="char", sep="", quote="")
deTwitter <- scan(paste(path, "de_DE/de_DE.twitter.txt", sep=""), what="char", sep="", quote="")


#ENGLISH
enBlogs <- scan(paste(path, "en_US/en_US.blogs.txt", sep=""), what="char", sep="", quote="")
enNews <- scan(paste(path, "en_US/en_US.news.txt", sep=""), what="char", sep="", quote="")
enTwitter <- scan(paste(path, "en_US/en_US.twitter.txt", sep=""), what="char", sep="", quote="")