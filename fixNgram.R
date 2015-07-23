fixNgram <- function(x, n=integer()) {
    a <- as.character()
    for (i in 1:length(x)) {
        if(length(unlist(strsplit(x[i], split="_"))) > (n-1)) {
            a <- c(a,x[i])
        }
    }
    return(a)
}


