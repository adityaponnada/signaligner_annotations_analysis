# Import libraries
library(rjson)
library(jsonlite)

## read the json file
label_json <- fromJSON(file="C:/Users/Aditya/Documents/SignalignerData/labelsets/StephenRightWristWearNonwearSleep3/DEFAULT/labels.latest.json")

## Create a data frame of the following format

# START_TIME | STOP_TIME | PREDICTION (the actual label) | SOURCE (player vs algo) | LABELSET (DEFAULT)

json_label_df <- do.call(rbind.data.frame, label_json$labels)

## Get start and end times for the main data set
start_time_stamp = as.POSIXct("2019-06-19 16:10:00.000", format = "%Y-%m-%d %H:%M:%OS")
end_time_stamp = as.POSIXct("2019-06-27 11:58:16.988", format = "%Y-%m-%d %H:%M:%OS")

## Create the start and stop time columns
json_label_df$START_TIME <- start_time_stamp + (json_label_df$lo/80)
json_label_df$STOP_TIME <- start_time_stamp + (json_label_df$hi/80)

json_label_df$PREDICTION <- json_label_df$lname

json_label_df$SOURCE <- "Player"

json_label_df$LABELSET <- "DEFAULT"


## Only keep the relevant columns
final_label_df <- json_label_df[, c(4:8)]
