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

new_swan_file$GROUND_TRUTH[new_swan_file$TRUE. == 0] <- "Wear"
new_swan_file$GROUND_TRUTH[new_swan_file$TRUE. == 1] <- "Sleep"
new_swan_file$GROUND_TRUTH[new_swan_file$TRUE. == 2] <- "Nonwear"

new_swan_file$OLD_SWAN[new_swan_file$PREDICTED_SMOOTH == 0] <- "Wear"
new_swan_file$OLD_SWAN[new_swan_file$PREDICTED_SMOOTH == 1] <- "Sleep"
new_swan_file$OLD_SWAN[new_swan_file$PREDICTED_SMOOTH == 2] <- "Nonwear"


## Convert columns to factors
old_swan_file$GROUND_TRUTH <- as.factor(old_swan_file$GROUND_TRUTH)
old_swan_file$OLD_SWAN <- as.factor(old_swan_file$OLD_SWAN)

new_swan_file$GROUND_TRUTH <- as.factor(new_swan_file$GROUND_TRUTH)
new_swan_file$OLD_SWAN <- as.factor(new_swan_file$OLD_SWAN)


### Generate confusion matrices

# 1. old swan vs ground truth
old_swan_matrix <- confusionMatrix(old_swan_file$OLD_SWAN, old_swan_file$GROUND_TRUTH, mode = "prec_recall")


# 2. new swan vs ground truth
new_swan_matrix <- confusionMatrix(new_swan_file$OLD_SWAN, new_swan_file$GROUND_TRUTH, mode = "prec_recall")


### Check consensus, R2, and R3 vs the OLD_SWAN labels

# first get the R2, R3. and consensus labels
user_labels_from_feature <- feature_file[, c("LABEL_CONSENSUS", "EXP_1_LABELS", "EXP_2_LABELS")] 

user_labels_from_feature$LABEL_CONSENSUS <- as.factor(user_labels_from_feature$LABEL_CONSENSUS)
user_labels_from_feature$EXP_1_LABELS <- as.factor(user_labels_from_feature$EXP_1_LABELS)
user_labels_from_feature$EXP_2_LABELS <- as.factor(user_labels_from_feature$EXP_2_LABELS)


old_swan_consensus <- confusionMatrix(old_swan_file$OLD_SWAN, user_labels_from_feature$LABEL_CONSENSUS, mode = "prec_recall")

old_swan_exp_1 <- confusionMatrix(old_swan_file$OLD_SWAN, user_labels_from_feature$EXP_1_LABELS, mode = "prec_recall")

old_swan_exp_2 <- confusionMatrix(old_swan_file$OLD_SWAN, user_labels_from_feature$EXP_2_LABELS, mode = "prec_recall")

user_labels_from_feature$GROUND_TRUTH <- feature_file$GROUND_TRUTH
user_labels_from_feature$GROUND_TRUTH <- as.factor(user_labels_from_feature$GROUND_TRUTH)

levels(user_labels_from_feature$GROUND_TRUTH) <- c(levels(user_labels_from_feature$GROUND_TRUTH), "Unknown")

## Compute labeling accuracy using confusion matirces

r1_gt_accuracy <- confusionMatrix(user_labels_from_feature$EXP_1_LABELS, user_labels_from_feature$GROUND_TRUTH, mode = "prec_recall")
r2_gt_accuracy <- confusionMatrix(user_labels_from_feature$EXP_2_LABELS, user_labels_from_feature$GROUND_TRUTH, mode = "prec_recall")
cons_gt_accuracy <- confusionMatrix(user_labels_from_feature$LABEL_CONSENSUS, user_labels_from_feature$GROUND_TRUTH, mode = "prec_recall")
