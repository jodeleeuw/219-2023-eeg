library(readr)
library(dplyr)
library(jsonlite)
library(tidyr)

all.beh.files <- list.files(path="data/raw/beh", pattern=".json", full.names = T)

all.beh.data <- lapply(all.beh.files, fromJSON) %>% bind_rows() %>% filter(trial_type != "survey-number")

write_csv(all.beh.data, "data/preprocessed/behavioral.csv")
