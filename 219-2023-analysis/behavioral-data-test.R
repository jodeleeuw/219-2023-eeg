library(jsonlite)
library(dplyr)

df <- fromJSON('data/behavior/219_2023_behavioral_01.json')

card_reveals <- df %>% filter(task=="reveal") %>% select(eeg_event_id, card, color, participant_choice, card_value, wins_so_far, outcome, sequence_id)

beh_hands <- card_reveals[seq(11,410,5),]
