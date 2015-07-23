ngramTailFinder <- function(x=char(), n=integer()){
    input <- unlist(strsplit(x, split=" "))
    tailwords <- tail(input, n)
    ngramTail <- paste(tailwords, collapse="_")
    return(ngramTail)
}