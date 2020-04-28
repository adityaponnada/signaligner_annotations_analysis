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


original_swan_file$GROUND_TRUTH <- as.factor(original_swan_file$GROUND_TRUTH)
original_swan_file$CORRECTED_SWAN <- as.factor(original_swan_file$CORRECTED_SWAN)
original_swan_file$ML_SWAN <- as.factor(original_swan_file$ML_SWAN)


