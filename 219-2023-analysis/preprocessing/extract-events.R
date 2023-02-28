library(edfReader)
library(purrr)
library(dplyr)
library(jsonlite)

extract_events <- function(eeg.file, beh.file){
  
  # read in EEG data
  
  head <- readEdfHeader(eeg.file)
  signals <- readEdfSignals(head, signals="Ordinary")
  
  eeg.data <- map_df(signals, "signal")
  eeg.data$sample_id <- 1:nrow(eeg.data)
  
  ## read in behavioral data
  
  behavioral.data <- fromJSON(beh.file)
  
  card.reveals <- behavioral.data %>% dplyr::filter(task=="reveal") %>% select(eeg_event_id, card, color, participant_choice, card_value, wins_so_far, outcome, sequence_id)
  
  hand.ids <- card.reveals[seq(11,410,5),] %>%
    mutate(hand_id = 1:n())
  
  ## extract EEG events
  
  events <- eeg.data %>% 
    select(sample_id, TRIGGER) %>% 
    dplyr::filter(TRIGGER != lag(TRIGGER)) %>%
    dplyr::filter(TRIGGER > 0) %>%
    mutate(time = sample_id/500)
  
  events.hands.only <- events %>% 
    dplyr::filter(TRIGGER <= 32) %>% 
    mutate(hand_start_time = time) %>%
    mutate(hand_end_time = time + 17) %>%
    mutate(hand_id = NA) %>%
    select(-time)
  
  hand_counter <- 1
  eeg_event_counter <- 1
  
  # while(eeg_event_counter <= nrow(events.hands.only)){
  #   if(events.hands.only$TRIGGER[eeg_event_counter] == hand.ids$sequence_id[hand_counter]){
  #     events.hands.only$hand_id[eeg_event_counter] = hand.ids$hand_id[hand_counter]
  #     eeg_event_counter <- eeg_event_counter + 1
  #   } 
  #   hand_counter <- hand_counter + 1
  # }
  
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
  
  events.hands.only$hand_id <- aligned.hands
  
  events.hands.only <- events.hands.only %>% dplyr::filter(!is.na(hand_id))
  
  events.flips.only <- events %>% 
    dplyr::filter(TRIGGER == 65535)
  
  events.flips.with.hand.id <- events.flips.only %>%
    left_join(events.hands.only %>% select(hand_start_time, hand_end_time, hand_id), by=join_by(between(x$time, y$hand_start_time, y$hand_end_time)))
  
  event.flips.with.card.id <- events.flips.with.hand.id %>%
    mutate(offset_time = time - hand_start_time) %>%
    dplyr::filter(!is.na(offset_time)) %>%
    rowwise() %>%
    mutate(card_id = which.min(abs(offset_time - c(2,5,8,11,14)))) %>%
    ungroup()
  
  events <- event.flips.with.card.id %>% select(sample_id, hand_id, card_id)
  
  return(events)
}
