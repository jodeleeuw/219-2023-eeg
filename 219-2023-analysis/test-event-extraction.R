library(edfReader)
library(purrr)
library(dplyr)

head <- readEdfHeader('data/eeg/subject-00-eeg_2023-02-06.bdf')
signals <- readEdfSignals(head, signals="Ordinary")


data <- map_df(signals, "signal")
data$sample_id <- 1:nrow(data)

events <- data %>% select(sample_id, TRIGGER) %>% dplyr::filter(TRIGGER > 0) %>% filter((sample_id > lag(sample_id)+1 | TRIGGER != lag(TRIGGER))) %>% mutate(time = sample_id/500)
