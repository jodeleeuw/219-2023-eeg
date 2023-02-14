SUBJECT <- "03"
eeg.file <- list.files('data/eeg', pattern=paste0("subject-", SUBJECT), full.names = T)
beh.file <- paste0('data/behavior/219_2023_behavioral_', SUBJECT,'.json')

source('preprocessing/preprocess-eeg-functions.R')

result <- preprocess_eeg(eeg.file, beh.file, SUBJECT)


library(ggplot2)

grand.average <- dd %>% group_by(electrode, t) %>%
  dplyr::filter(good_segment==TRUE) %>%
  summarize(mv = mean(v))

ggplot(grand.average,aes(x=t, y=mv, color=electrode)) + 
  geom_hline(yintercept=0)+
  geom_vline(xintercept=0)+
  geom_line() +
  annotate("rect",xmin=200,xmax=350,ymin=-4,ymax=12,fill="blue", alpha=0.05)+
  coord_cartesian(ylim=c(12,-4), expand = FALSE)+
  theme_bw()
