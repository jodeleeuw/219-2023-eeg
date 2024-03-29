library(readr)
library(stringr)
source("preprocessing/preprocess-eeg-functions.R")

subjects <- list.files('data/raw/beh') %>% str_sub(start = 21, end=22)

for(subject in subjects){
  
  final.path <- paste0("data/preprocessed/subject-", subject,"-epochs.csv")
  print(paste0("Working on ",subject))
  if(file.exists(final.path)){
    print(paste0("epochs.csv already exists - skipping"))
    next
  }
  tryCatch({
  eeg.file <- list.files('data/raw/eeg', pattern=paste0("subject-", subject), full.names = T)
  beh.file <- paste0('data/raw/beh/219_2023_behavioral_', subject,'.json')
  
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
  
  write_csv(preprocessed.data, file=paste0("data/preprocessed/subject-", subject,"-epochs.csv"))
  },
  error = function(cond){
    message(cond)
  },
  warning = function(cond){
    message(cond)
  })
}
