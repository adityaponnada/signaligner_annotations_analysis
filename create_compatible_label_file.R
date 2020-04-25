## This script is to be used when creating a label file compatible with Signaligner Pro import-label feature

## import libraries
library(reshape2)

## read the feature file
feature_file_timestamps <- read.csv(file="D:/Signaligner_Test_Datasets/MISC/IEEEvis_Datasets/STEPHEN_WRIST_DATA/labeled_windows_file_incl_consensus_exp_gt_swan.csv",
                                    header = TRUE, sep = ",")

## read the old swan file
swan_first_pass_predictions <- read.csv(file="D:/Signaligner_Test_Datasets/MISC/IEEEvis_Datasets/results_v2/results_groundtruth/Original_model/labeled_windows_file_incl_ground_truth_prediction_filtered.csv",
                                        header = TRUE, sep = ",")

## COnvert start and stop times to date time objects if required


## Create a mapped file of start time, end time, label, and other column requirements for Signaligner Pro

export_labels_file <- feature_file[, c("START_TIME", "STOP_TIME")]

## COnvert prediction column to character
swan_first_pass_predictions$PREDICTED_TEXT[swan_first_pass_predictions$PREDICTED == 0] <- "Wear"
swan_first_pass_predictions$PREDICTED_TEXT[swan_first_pass_predictions$PREDICTED == 1] <- "Sleep"
swan_first_pass_predictions$PREDICTED_TEXT[swan_first_pass_predictions$PREDICTED == 2] <- "Nonwear"

export_labels_file$PREDICTION <- swan_first_pass_predictions$PREDICTED_TEXT

export_labels_file$LABELSET <- "SWaN_first_pass"
export_labels_file$SOURCE <- "Algo"

## Write the file as a csv
write.csv(export_labels_file, file="D:/Signaligner_Test_Datasets/MISC/IEEEvis_Datasets/STEPHEN_WRIST_DATA/first_pass_swan_labels.csv",
          row.names = FALSE, sep = ",")
