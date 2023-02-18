SUBJECT <- "03"
eeg.file <- list.files('data/eeg', pattern=paste0("subject-", SUBJECT), full.names = T)
beh.file <- paste0('data/behavior/219_2023_behavioral_', SUBJECT,'.json')

source('preprocessing/preprocess-eeg-functions.R')

result <- preprocess_eeg(eeg.file, beh.file, SUBJECT)


library(ggplot2)

segment.eeg <- result %>% filter(hand_id == 50, card_id == 4, electrode == 'Fp1')

ggplot(segment.eeg, aes(x=t, y=v)) +
  geom_hline(yintercept=0)+
  geom_vline(xintercept=0)+
  geom_line() +
  theme_bw()

blinks <- result %>% filter(eyeblink == TRUE, electrode == 'Fp1')

ggplot(blinks, aes(x=t, y=v))+
  facet_wrap(vars(hand_id, card_id))+
  geom_line()+
  theme_bw()
