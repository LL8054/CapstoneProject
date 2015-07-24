ngramTailFinder <- function(x=char(), n=integer(), a=char()){
    input <- unlist(strsplit(x, split=a))
    tailwords <- tail(input, n)
    ngramTail <- paste(tailwords, collapse="_")
    return(ngramTail)
}