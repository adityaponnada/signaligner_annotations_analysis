## Import libraries
library(rjson)
library(rlist)


## Read in the play log file
playlog_path = "D:/Signaligner_Test_Datasets/Expert_labels/"
play_log_filename = "Exp1_labels/playlog"

## test read as a df
log_file <- read.fwf(file=paste0(playlog_path, play_log_filename), widths = 1000)
names(log_file) <- "LOG_JSON"
log_file$UPDATED_JSON <- paste("[", log_file$LOG_JSON, "]")


