library(readr)
source("preprocessing/preprocess-eeg-functions.R")

#subjects <- c("01", "02", "03", "04", "05", "08","09","10","11","12","13","14","15")
#subjects <- c("08","09","10","11","12","13","14","15")
subjects <- c("14","15")
for(subject in subjects){
  print(paste0("Working on ",subject))
  
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
  
}
