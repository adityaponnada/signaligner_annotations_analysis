## Import libraries
library(rjson)
library(rlist)
library(jsonlite)


## Read in the play log file
playlog_path = "D:/Signaligner_Test_Datasets/Expert_labels/"
play_log_filename = "Exp1_labels/playlog" ## Compute the playlog for gt here 

## test read as a df
log_file <- read.fwf(file=paste0(playlog_path, play_log_filename), widths = 100000)
names(log_file) <- "LOG_JSON"
# log_file$UPDATED_JSON <- paste0("[", log_file$LOG_JSON, "]")
# 
# log_file$UPDATED_JSON <- lapply(log_file$LOG_JSON, fromJSON)

res <- jsonlite::stream_in(textConnection(as.character(log_file$LOG_JSON)))

res <- subset(res, res$dataset == "LeftWrist_TAS1E23150023_2019_06_27_RAW")

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

## Compute time spent labeling
time_taken_labeling <- (res$time[nrow(res)] - res$time[1])/(1000*60)
## Exp 2 took 36.33 min to label in one session
## Exp 1 took 81.76 min to label in two sessions, 67.5 min in the first, 13.33 min in the second session


## Check session numbers for gt here 

## create subsets for run
res_session_1 <- subset(res, res$run == "QG9P77TCO5")
res_session_2 <- subset(res, res$run == "BE4QC1X7J9")

time_session_1 <- (res_session_1$time[nrow(res_session_1)] - res_session_1$time[1])/(1000*60)
time_session_2 <- (res_session_2$time[nrow(res_session_2)] - res_session_2$time[1])/(1000*60)


### Compute zoom access information for botht the experts

### include ticks only
res_tick <- subset(res, res$type == "tick")
zoom_list <- c()
for (i in 1:nrow(res_tick)){
  zoom_list <- c(zoom_list, res_tick$info$zoom[[i]][1])
}

min_zoom_accessed = min(zoom_list)
max_zoom_accessed = max(zoom_list)

table(zoom_list)

plot(table(zoom_list))

plot(zoom_list)

zoom_df <- as.data.frame(zoom_list)
zoom_df$seq <- c(1:nrow(zoom_df))

plot(zoom_df$zoom_list, zoom_df$seq)

hist(zoom_list)

barplot(zoom_df$zoom_list, xlab = "Event sequence", ylab = "Zoom level")

### Reverse the zoom orders
zoom_df$zoom_level <- max_zoom_accessed - zoom_df$zoom_list
## Add a time from begining column
zoom_df$time_from_start <- zoom_df$seq*10 - 10

## Plot the zoom sequence


# Exp 1 min zoom - 2, and max zoom 7
# Exp 2 min zoom - 1, and max zoom 7 
