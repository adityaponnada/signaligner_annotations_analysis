## Import libraries
library(rjson)
library(rlist)
library(jsonlite)


## Read in the play log file
playlog_path = "D:/Signaligner_Test_Datasets/Expert_labels/"
play_log_filename = "Exp2_labels/playlog"

## test read as a df
log_file <- read.fwf(file=paste0(playlog_path, play_log_filename), widths = 100000)
names(log_file) <- "LOG_JSON"
log_file$UPDATED_JSON <- paste0("[", log_file$LOG_JSON, "]")

log_file$UPDATED_JSON <- lapply(log_file$LOG_JSON, fromJSON)

res <- jsonlite::stream_in(textConnection(as.character(log_file$LOG_JSON)))
