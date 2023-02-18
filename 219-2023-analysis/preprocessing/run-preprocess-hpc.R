library(readr)

source("preprocess-eeg-functions.R")

args <- commandArgs(trailingOnly = TRUE)
subject <- args[1]

print(paste0("Working on ",subject))

eeg.file <- list.files('/scratch/jdeleeuw/219-2023-eeg/raw/eeg', pattern=paste0("subject-", SUBJECT), full.names = T)
beh.file <- paste0('/scratch/jdeleeuw/219-2023-eeg/raw/beh/219_2023_behavioral_', SUBJECT,'.json')

preprocessed.data <- preprocess_eeg(
  file = eeg.file, 
  beh.file = beh.file,
  subject_id = subject,
  sampling_rate = 500,
  filter_low = 0.1,
  filter_high = 70,
  notch_filter_low = 59,
  notch_filter_high = 61,
  segment_begin = -100,
  segment_end = 1000,
  segment_offset = 0,
  bad_segment_range = 200)

write_csv(preprocessed.data, file=paste0("/scratch/jdeleeuw/219-2023-eeg/preprocessed/subject-", subject,"-epochs.csv"))