library(readr)
library(dplyr)
library(jsonlite)
library(tidyr)

all.beh.files <- list.files(path="data/raw/beh", pattern=".json", full.names = T)

all.beh.data <- lapply(all.beh.files, fromJSON) %>% bind_rows() %>% 
  dplyr::filter(trial_type != "survey-number") %>%
  rename(subject=subject_id, card_id=card) %>%
  mutate(outcome = case_when(
    outcome == 0 ~ "win",
    outcome == 1 ~ "loss",
    .default = NA))

write_csv(all.beh.data, "data/preprocessed/behavioral.csv")
