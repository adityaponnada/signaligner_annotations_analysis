## This script is to compute confusion matrices directly from the original feature files and get the accuracy values for old and new swan algorithms

## Import libraries

library(caret)
library(e1071)
library(ggplot2)

## Read the feature_prediction files

old_swan_file <- read.csv(file="D:/Signaligner_Test_Datasets/MISC/IEEEvis_Datasets/results_v2/results_groundtruth/Original_model/labeled_windows_file_incl_ground_truth_prediction_filtered.csv",
                          sep = ",", header = TRUE)
new_swan_file <- read.csv(file="D:/Signaligner_Test_Datasets/MISC/IEEEvis_Datasets/results_v2/results_groundtruth/Signalignerdata_model/labeled_windows_file_incl_ground_truth_prediction_signalignertrained_filtered.csv", 
                          sep = ",", header = TRUE)


## Convert the true and predicted to respective labels
old_swan_file$GROUND_TRUTH[old_swan_file$TRUE. == 0] <- "Wear"
old_swan_file$GROUND_TRUTH[old_swan_file$TRUE. == 1] <- "Sleep"
old_swan_file$GROUND_TRUTH[old_swan_file$TRUE. == 2] <- "Nonwear"

old_swan_file$OLD_SWAN[old_swan_file$PREDICTED_SMOOTH == 0] <- "Wear"
old_swan_file$OLD_SWAN[old_swan_file$PREDICTED_SMOOTH == 1] <- "Sleep"
old_swan_file$OLD_SWAN[old_swan_file$PREDICTED_SMOOTH == 2] <- "Nonwear"
