# Import libraries
library(MASS)
library(caret)
library(e1071)

## Read retrained SWAN file

retrained_swan_df <- read.csv(file="D:/Signaligner_Test_Datasets/MISC/IEEEvis_Datasets/results_v1/Signalignerdata_model/labeled_windows_file_prediction_signalignertrained_filtered.csv",
                              header = TRUE, sep = ",")



feature_filter_unknown_df <- subset(feature_file, feature_file$LABEL_CONSENSUS != "Unknown")

retrained_swan_df$NEW_SWAN[retrained_swan_df$PREDICTED_SMOOTH == 0] <- "Wear"
retrained_swan_df$NEW_SWAN[retrained_swan_df$PREDICTED_SMOOTH == 1] <- "Sleep"
retrained_swan_df$NEW_SWAN[retrained_swan_df$PREDICTED_SMOOTH == 2] <- "Nonwear"

labels_combined_df <- feature_filter_unknown_df[, c("LABEL_CONSENSUS", "EXP_1_LABELS", "EXP_2_LABELS", "GROUND_TRUTH", "OLD_SWAN")]

labels_combined_df$NEW_SWAN <- retrained_swan_df$NEW_SWAN

# Convert characters to factors
labels_combined_df$OLD_SWAN <- as.factor(labels_combined_df$OLD_SWAN)
labels_combined_df$NEW_SWAN <- as.factor(labels_combined_df$NEW_SWAN)
labels_combined_df$GROUND_TRUTH <- as.factor(labels_combined_df$GROUND_TRUTH)

## Generate normalized confusion matrices 1. OLD_SWAN vs GT 2. NEW_SWAN vs GT
cm_old_swan <- confusionMatrix(labels_combined_df$OLD_SWAN, labels_combined_df$GROUND_TRUTH)

cm_new_swan <- confusionMatrix(labels_combined_df$NEW_SWAN, labels_combined_df$GROUND_TRUTH)


