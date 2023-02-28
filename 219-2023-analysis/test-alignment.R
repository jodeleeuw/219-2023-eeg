library(text.alignment)

a <- events.hands.only$TRIGGER
b <- hand.ids$sequence_id

a <- a[c(1:15,17:81)]

L <- c(LETTERS, letters)

aa <- L[a]
bb <- L[b]

aaa <- paste0(aa, collapse = "")
bbb <- paste0(bb, collapse = "")

zz <- text.alignment::smith_waterman(aaa,bbb,lower=FALSE)


# aaa has the extra event, need to figure out how to discard it

zz$a

a.z <- unlist(sapply(stringr::str_split(zz$a$alignment$text,"")[[1]], function(x){ 
  if(x=="#") { return(NA) } 
  return(which(L==x))
  }, simplify=TRUE))
b.z <- unlist(sapply(stringr::str_split(zz$b$alignment$text,"")[[1]], function(x){ 
  if(x=="#") { return(NA) } 
  return(which(L==x))
  }, simplify=TRUE))
