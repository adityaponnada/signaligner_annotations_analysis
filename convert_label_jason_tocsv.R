# Import libraries
library(rjson)
library(jsonlite)

## read the json file
## Use the first one to read the ground truth file
## label_json <- rjson::fromJSON(file="D:/Signaligner_Test_Datasets/Expert_labels/label_set_gt/labelsets/SignalignerData/DEFAULT/labels.latest.json")
label_json <- rjson::fromJSON(file="D:/Signaligner_Test_Datasets/Expert_labels/Exp2_labels_full_swan_v2/DEFAULT/labels.latest.json")

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

## If not converting the ground truth, save it using this path or else use the other path
write.csv(json_label_df, file = "D:/Signaligner_Test_Datasets/Expert_labels/Exp2_labels_full_swan_v2/LeftWrist_TAS1E23150023_2019_06_27_RAW.csv",
          row.names = FALSE, sep = ",")
## write.csv(final_label_df, file = "D:/Signaligner_Test_Datasets/Expert_labels/Ground_truth_labels/ground_truth_labels.csv", row.names = FALSE, sep = ",")



final_label_df$DIFF_TIME <- difftime(final_label_df$STOP_TIME, final_label_df$START_TIME, units = "secs")
final_gt_aggregate <- aggregate(final_label_df$DIFF_TIME, by=list(Category = final_label_df$PREDICTION), FUN = sum)
