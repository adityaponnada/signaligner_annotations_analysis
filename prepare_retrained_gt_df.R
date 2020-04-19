# Import libraries
library(MASS)

## Read retrained SWAN file

retrained_swan_df <- read.csv(file="D:/Signaligner_Test_Datasets/MISC/IEEEvis_Datasets/results_v1/Signalignerdata_model/labeled_windows_file_prediction_signalignertrained_filtered.csv",
                              header = TRUE, sep = ",")



feature_filter_unknown_df <- subset(feature_file, feature_file$LABEL_CONSENSUS != "Unknown")

retrained_swan_df$NEW_SWAN[retrained_swan_df$PREDICTED_SMOOTH == 0] <- "Sleep"
retrained_swan_df$NEW_SWAN[retrained_swan_df$PREDICTED_SMOOTH == 1] <- "Wear"
retrained_swan_df$NEW_SWAN[retrained_swan_df$PREDICTED_SMOOTH == 2] <- "Nonwear"
