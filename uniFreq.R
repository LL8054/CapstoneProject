library(quanteda)
grams <- readRDS("~/datasciencecoursera/Courses/Capstone/Subsets/Unigrams.rds")
gramsFreq <- topfeatures(grams, n = nfeature(grams))
saveRDS(gramsFreq, file="~/datasciencecoursera/Courses/Capstone/Subsets/uniFreq.rds")
uniFreq <- readRDS("~/datasciencecoursera/Courses/Capstone/Subsets/uniFreq.rds")

#create data.frame of words and counts
uniFreqDF <- data.frame(word = names(uniFreq), count = uniFreq[1:length(uniFreq)], 
                stringsAsFactors = FALSE, row.names = 1:length(uniFreq))
saveRDS(uniFreqDF, file="~/datasciencecoursera/Courses/Capstone/Subsets/uniFreqDF.rds")
uniFreqDF <- readRDS("~/datasciencecoursera/Courses/Capstone/Subsets/uniFreqDF.rds")

#to find words in uniFreqDF use ....
a <- grep("lawrence", uniFreqDF$word)
uniFreqDF[a,1]