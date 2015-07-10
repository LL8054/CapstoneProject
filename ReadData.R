
setwd("~/LL/Coursera/Courses/Capstone/CapstoneProject")
path <- "~/LL/Coursera/Courses/Capstone/Coursera-SwiftKey/final/"

#GERMAN
deBlogs <- scan(paste(path, "de_DE/de_DE.blogs.txt", sep=""), what="char", quote="", skipNul=TRUE)
deNews <- scan(paste(path, "de_DE/de_DE.news.txt", sep=""), what="char", quote="", skipNul=TRUE)
deTwitter <- scan(paste(path, "de_DE/de_DE.twitter.txt", sep=""), what="char", quote="", skipNul=TRUE)


#ENGLISH
enBlogs <- scan(paste(path, "en_US/en_US.blogs.txt", sep=""), what="char", quote="", skipNul=TRUE)
enNews <- scan(paste(path, "en_US/en_US.news.txt", sep=""), what="char", quote="", skipNul=TRUE)
enTwitter <- scan(paste(path, "en_US/en_US.twitter.txt", sep=""), what="char", quote="", skipNul=TRUE)

#Finnish
fiBlogs <- scan(paste(path, "fi_FI/fi_FI.blogs.txt", sep=""), what="char", quote="", skipNul=TRUE)
fiNews <- scan(paste(path, "fi_FI/fi_FI.news.txt", sep=""), what="char", quote="", skipNul=TRUE)
fiTwitter <- scan(paste(path, "fi_FI/fi_FI.twitter.txt", sep=""), what="char", quote="", skipNul=TRUE)

#Russian
ruBlogs <- scan(paste(path, "ru_RU/ru_RU.blogs.txt", sep=""), what="char", quote="", skipNul=TRUE, 
                encoding="UTF-8")
ruNews <- scan(paste(path, "ru_RU/ru_RU.news.txt", sep=""), what="char", quote="", skipNul=TRUE, 
               encoding="UTF-8")
ruNews <- scan(paste(path, "ru_RU/ru_RU.twitter.txt", sep=""), what="char", quote="", skipNul=TRUE, 
               encoding="UTF-8")