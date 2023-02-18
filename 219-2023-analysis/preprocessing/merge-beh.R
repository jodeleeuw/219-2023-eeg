library(readr)
library(dplyr)
library(jsonlite)

all.beh.files <- list.files(path="data/raw/beh", pattern=".json", full.names = T)

all.beh.data <- lapply(all.beh.files, fromJSON) %>% bind_rows()

write_csv(all.beh.data, "data/preprocessed/behavioral.csv")
