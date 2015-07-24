ngramTailFinder1 <- function(x=char(), a=char()){
    input <- unlist(strsplit(x, split=a))
    tailword <- tail(input, 1)
    ngramTail <- paste(tailword)
    return(ngramTail)
}