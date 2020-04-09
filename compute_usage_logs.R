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
# log_file$UPDATED_JSON <- paste0("[", log_file$LOG_JSON, "]")
# 
# log_file$UPDATED_JSON <- lapply(log_file$LOG_JSON, fromJSON)

res <- jsonlite::stream_in(textConnection(as.character(log_file$LOG_JSON)))

### Exp 2 took 36.33 min to label

### Compute change in labels
head(user_labels)

head(user_only_labels)

head(algo_only_labels)

## Compute time diff
user_only_labels$START_TIME <- as.POSIXct(user_only_labels$START_TIME, format = "%Y-%m-%d %H:%M:%OS")
user_only_labels$STOP_TIME <- as.POSIXct(user_only_labels$STOP_TIME, format = "%Y-%m-%d %H:%M:%OS")
algo_only_labels$START_TIME <- as.POSIXct(algo_only_labels$START_TIME, format = "%Y-%m-%d %H:%M:%OS")
algo_only_labels$STOP_TIME <- as.POSIXct(algo_only_labels$STOP_TIME, format = "%Y-%m-%d %H:%M:%OS")

### Compute amount of sleep, wear, non-wear from algo
user_only_labels$DIFF_TIME <- difftime(user_only_labels$STOP_TIME, user_only_labels$START_TIME, units = "secs")
algo_only_labels$DIFF_TIME <- difftime(algo_only_labels$STOP_TIME, algo_only_labels$START_TIME, units = "secs")

### Label diff computing
algo_aggregate <- aggregate(algo_only_labels$DIFF_TIME, by=list(Category = algo_only_labels$PREDICTION), FUN = sum)
user_aggregate <- aggregate(user_only_labels$DIFF_TIME, by=list(Category = user_only_labels$PREDICTION), FUN = sum)

## User vs algo diff
nonwear_dff = user_aggregate$x[user_aggregate$Category == "Nonwear"][[1]] - algo_aggregate$x[algo_aggregate$Category == "Nonwear"][[1]]
sleep_dff = user_aggregate$x[user_aggregate$Category == "Sleep"][[1]] - algo_aggregate$x[algo_aggregate$Category == "Sleep"][[1]]
wear_diff = user_aggregate$x[user_aggregate$Category == "Wear"][[1]] - algo_aggregate$x[algo_aggregate$Category == "Wear"][[1]]

## Results
## Exp 1 added 18656.2 secs of non-wear, reduced (-56695.2 secs) of sleep labels, and added 38850 secs of wear labels
## Exp 2 added 8760.15 secsof non-wear, reduced -83345.4 secs of sleep labels, and added 74508.4 secs of wear labels


