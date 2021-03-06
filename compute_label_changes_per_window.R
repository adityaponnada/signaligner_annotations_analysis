### Use this script to compute the total changes in label windows from the algorithm to user labels

### Read the original SWaN file
original_swan_file <- read.csv(file="D:/Signaligner_Test_Datasets/MISC/IEEEvis_Datasets/results_v2/results_groundtruth/Original_model/labeled_windows_file_incl_ground_truth_prediction_filtered.csv", 
                               sep = ",", header = TRUE)


## Convert the true (gt), corrected SWaN, and ML-only SWaN into string labels
original_swan_file$GROUND_TRUTH[original_swan_file$TRUE. == 0] <- "Wear"
original_swan_file$GROUND_TRUTH[original_swan_file$TRUE. == 1] <- "Sleep"
original_swan_file$GROUND_TRUTH[original_swan_file$TRUE. == 2] <- "Nonwear"

original_swan_file$CORRECTED_SWAN[original_swan_file$PREDICTED_SMOOTH == 0] <- "Wear"
original_swan_file$CORRECTED_SWAN[original_swan_file$PREDICTED_SMOOTH == 1] <- "Sleep"
original_swan_file$CORRECTED_SWAN[original_swan_file$PREDICTED_SMOOTH == 2] <- "Nonwear"

original_swan_file$ML_SWAN[original_swan_file$PREDICTED == 0] <- "Wear"
original_swan_file$ML_SWAN[original_swan_file$PREDICTED == 1] <- "Sleep"
original_swan_file$ML_SWAN[original_swan_file$PREDICTED == 2] <- "Nonwear"


# original_swan_file$GROUND_TRUTH <- as.factor(original_swan_file$GROUND_TRUTH)
# original_swan_file$CORRECTED_SWAN <- as.factor(original_swan_file$CORRECTED_SWAN)
# original_swan_file$ML_SWAN <- as.factor(original_swan_file$ML_SWAN)

## Read the feature file with old R2 and R3 labels - labeling with the corrected SWAN
expert_labels_corr_swan <- read.csv(file="D:/Signaligner_Test_Datasets/MISC/IEEEvis_Datasets/STEPHEN_WRIST_DATA/labeled_windows_file_incl_consensus_exp_gt_swan.csv", 
                                    sep = ",", header = TRUE)


## Read the feature file with new R2 and R3 labels - labeling with the ML SWAN
expert_labels_ml_swan <- read.csv(file="D:/Signaligner_Test_Datasets/MISC/IEEEvis_Datasets/STEPHEN_WRIST_DATA/labeled_windows_file.csv", 
                                    sep = ",", header = TRUE)



# ### Rename expert label column names to corr and ml
# colnames(expert_labels_corr_swan)[which(names(expert_labels_corr_swan) == "EXP_1_LABELS")] <- "EXP_1_CORR_LABELS"
# colnames(expert_labels_corr_swan)[which(names(expert_labels_corr_swan) == "EXP_2_LABELS")] <- "EXP_2_CORR_LABELS"
# colnames(expert_labels_ml_swan)[which(names(expert_labels_ml_swan) == "EXP_1_LABELS")] <- "EXP_1_ML_LABELS"
# colnames(expert_labels_ml_swan)[which(names(expert_labels_ml_swan) == "EXP_2_LABELS")] <- "EXP_2_ML_LABELS"

### Create a mapped data frame of all the labels
mapped_annotation_windows <- original_swan_file[, c("GROUND_TRUTH", "CORRECTED_SWAN", "ML_SWAN")]
mapped_annotation_windows$EXP_1_CORR_LABELS <- expert_labels_corr_swan$EXP_1_LABELS
mapped_annotation_windows$EXP_2_CORR_LABELS <- expert_labels_corr_swan$EXP_2_LABELS
mapped_annotation_windows$EXP_1_ML_LABELS <- expert_labels_ml_swan$EXP_1_LABELS
mapped_annotation_windows$EXP_2_ML_LABELS <- expert_labels_ml_swan$EXP_2_LABELS

## Match levels
# levels(mapped_annotation_windows$CORRECTED_SWAN) <- levels(mapped_annotation_windows$EXP_1_CORR_LABELS)

## Corrected SWaN to correct R2 and R3
unmatched_corr_exp1 <- subset(mapped_annotation_windows, mapped_annotation_windows$CORRECTED_SWAN != mapped_annotation_windows$EXP_1_CORR_LABELS)
unmatched_corr_exp2 <- subset(mapped_annotation_windows, mapped_annotation_windows$CORRECTED_SWAN != mapped_annotation_windows$EXP_2_CORR_LABELS)

## Group by table
table(unmatched_corr_exp1$CORRECTED_SWAN, unmatched_corr_exp1$EXP_1_CORR_LABELS)
table(unmatched_corr_exp2$CORRECTED_SWAN, unmatched_corr_exp2$EXP_2_CORR_LABELS)

## ML SWaN to ML R2 and R3
unmatched_ml_exp1 <- subset(mapped_annotation_windows, mapped_annotation_windows$ML_SWAN != mapped_annotation_windows$EXP_1_ML_LABELS)
unmatched_ml_exp2 <- subset(mapped_annotation_windows, mapped_annotation_windows$ML_SWAN != mapped_annotation_windows$EXP_2_ML_LABELS)

## Group by table
table(unmatched_ml_exp1$ML_SWAN, unmatched_ml_exp1$EXP_1_ML_LABELS)
table(unmatched_ml_exp2$ML_SWAN, unmatched_ml_exp2$EXP_2_ML_LABELS)

table(mapped_annotation_windows$ML_SWAN)
table(original_swan_file$PREDICTED)

original_swan_file$ML_SWAN <- as.factor(original_swan_file$ML_SWAN)
original_swan_file$GROUND_TRUTH <- as.factor(original_swan_file$GROUND_TRUTH)

confusionMatrix(original_swan_file$ML_SWAN, original_swan_file$GROUND_TRUTH, mode = "prec_recall")
