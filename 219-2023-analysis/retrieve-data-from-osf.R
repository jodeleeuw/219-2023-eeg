library(osfr)
library(dplyr)

raw_data_component <- osf_retrieve_node("v8tgz")

files <- osf_ls_files(raw_data_component)

eeg.files <- files %>% dplyr::filter(name=="EEG") %>% osf_ls_files(n_max=Inf)
beh.files <- files %>% dplyr::filter(name=="Behavioral") %>% osf_ls_files(n_max=Inf)

osf_download(beh.files, path="data/raw/beh", conflicts = "skip")
osf_download(eeg.files, path="data/raw/eeg", conflicts = "skip")
