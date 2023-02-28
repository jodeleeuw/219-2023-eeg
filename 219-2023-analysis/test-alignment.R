library(text.alignment)

eeg.hand.events <- events.hands.only$TRIGGER
jspsych.hand.sequence <- hand.ids$sequence_id

L <- c(LETTERS, letters)

eeg.hand.events.encoded  <- L[eeg.hand.events] %>% paste0(collapse="")
jspsych.hand.sequence.encoded <- L[jspsych.hand.sequence] %>% paste0(collapse="")

alignment.solution <- text.alignment::smith_waterman(eeg.hand.events.encoded, jspsych.hand.sequence.encoded, lower=FALSE)

a.z <- unlist(sapply(stringr::str_split(alignment.solution$a$alignment$text,"")[[1]], function(x){ 
  if(x=="#") { return(NA) } 
  return(which(L==x))
  }, simplify=TRUE))
b.z <- unlist(sapply(stringr::str_split(alignment.solution$b$alignment$text,"")[[1]], function(x){ 
  if(x=="#") { return(NA) } 
  return(which(L==x))
  }, simplify=TRUE))

aligned.hands <- rep(0, length(a))
event.loc <- 1
hand.id <- 1
for(i in 1:length(a.z)){
  if(is.na(b.z[i])) { 
    aligned.hands[event.loc] <- NA 
    event.loc <- event.loc + 1
    next
  } 
  if(is.na(a.z[i])) { 
    hand.id <- hand.id + 1
    next
  }
  if(a.z[i] == b.z[i]) { 
    aligned.hands[event.loc] <- hand.id 
    event.loc <- event.loc + 1
    hand.id <- hand.id + 1
    next
  }
}
  
