library(dplyr)
library(readr)
library(ggplot2)

eeg <- read_csv('data/preprocessed/eeg.csv')
behavioral <- read_csv('data/preprocessed/behavioral.csv')

grand.averages <- eeg %>% filter(electrode %in% c("Cz", "Fz")) %>%
  filter(good_segment==T) %>%
  group_by(subject, t, electrode) %>%
  summarize(m_subject = mean(v)) %>%
  group_by(t, electrode) %>%
  summarize(m=mean(m_subject), se=sd(m_subject)/sqrt(n()))

ggplot(grand.averages, aes(x=t,y=m, ymin=m-se, ymax=m+se, color=electrode, fill=electrode))+
  geom_ribbon(color=NA, alpha=0.1)+
  geom_line()+
  geom_hline(yintercept=0)+
  geom_vline(xintercept=0)+
  theme_minimal()+
  scale_y_reverse()

subject.eeg.counts <- eeg %>% filter(electrode %in% c("Cz", "Fz")) %>%
  filter(good_segment==T) %>%
  group_by(subject, hand_id, card_id) %>%
  summarize(n=n()) %>%
  group_by(subject) %>%
  summarize(n=n())


hand.data <- behavioral %>% 
  filter(phase=='test', task=='reveal') %>%
  mutate(subject = subject_id) %>%
  select(-subject_id) %>%
  group_by(subject) %>%
  mutate(hand_id = rep(1:80, each=5)) %>%
  select(subject, hand_id, card, card_value, wins_so_far, outcome)

rpe <- hand.data %>%
  mutate(wp_before = 1-pbinom(2-wins_so_far, 5-(card-1), 0.5), wp_after = 1-pbinom(2-(wins_so_far+card_value), 5-card, 0.5), rpe=wp_after-wp_before)

entropy <- function(p){
  return(ifelse(p == 0 | p == 1, 0, -p*log2(p) - (1-p)*log2(1-p)))
}

ipe <- rpe %>%
  mutate(wp_alternative = 1-pbinom(2-(wins_so_far+abs(1-card_value)), 5-card, 0.5)) %>%
  mutate(information = entropy(wp_before) - entropy(wp_after),
         information_expected = ((entropy(wp_before) - entropy(wp_after)) + (entropy(wp_before) - entropy(wp_alternative))) / 2,
         ipe = information - information_expected) %>%
  mutate(card_id = card)

eeg.plus.beh <- eeg %>% 
  filter(electrode %in% c("Cz", "Fz")) %>%
  filter(good_segment == TRUE) %>%
  left_join(ipe, by=c("subject", "hand_id", "card_id"))


eeg.rpe <- eeg.plus.beh %>%
  filter(rpe != 0) %>%
  mutate(rpe_positive = rpe > 0) %>%
  group_by(subject, t, electrode, rpe_positive) %>%
  summarize(m.subject = mean(v)) %>%
  group_by(t, electrode, rpe_positive) %>%
  summarize(m = mean(m.subject), se=sd(m.subject)/sqrt(n()))


ggplot(eeg.rpe, aes(x=t,y=m, ymin=m-se, ymax=m+se, color=rpe_positive, fill=rpe_positive))+
  geom_ribbon(color=NA, alpha=0.1)+
  geom_line()+
  geom_hline(yintercept=0)+
  geom_vline(xintercept=0)+
  theme_minimal()+
  facet_wrap(~electrode)+
  scale_y_reverse()

eeg.ipe <- eeg.plus.beh %>%
  filter(ipe != 0) %>%
  mutate(ipe_positive = ipe > 0) %>%
  group_by(subject, t, electrode, ipe_positive) %>%
  summarize(m.subject = mean(v)) %>%
  group_by(t, electrode, ipe_positive) %>%
  summarize(m = mean(m.subject), se=sd(m.subject)/sqrt(n()))


ggplot(eeg.ipe, aes(x=t,y=m, ymin=m-se, ymax=m+se, color=ipe_positive, fill=ipe_positive))+
  geom_ribbon(color=NA, alpha=0.1)+
  geom_line()+
  geom_hline(yintercept=0)+
  geom_vline(xintercept=0)+
  theme_minimal()+
  facet_wrap(~electrode)+
  scale_y_reverse()
