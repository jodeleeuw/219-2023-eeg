library(readr)
library(dplyr)

all.eeg.epoch.files <- list.files(path="data/preprocessed", pattern=".csv", full.names = T)

all.eeg.epochs <- lapply(all.eeg.epoch.files, read_csv, col_types="iiicdddllc")

all.eeg.epochs.df <- bind_rows(all.eeg.epochs)

write_csv(all.eeg.epochs.df, "data/preprocessed/eeg.csv")
