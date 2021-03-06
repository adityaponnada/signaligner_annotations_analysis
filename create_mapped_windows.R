## Include libraries

library(reshape2)
options(digits.secs = 3)

## Read the matched labels file

matched_file <- read.csv(file="D:/Signaligner_Test_Datasets/Expert_labels/data_label_master.csv", header = TRUE, sep = ",")

## Filter out the agreed labels - may change this when you have more than 2 annotators
agreed_labels <- subset(matched_file, matched_file$EXP_1_LABELS == matched_file$EXP_2_LABELS)

agreed_labels <- na.omit(agreed_labels)

## Compute data loss
diff_consensus = nrow(data_label_master) - nrow(agreed_labels)
data_loss = diff_consensus/(60*60)

## Read the combined feature file

feature_file <- read.csv(file="D:/Signaligner_Test_Datasets/MISC/IEEEvis_Datasets/STEPHEN_WRIST_DATA/combined_feature_file.csv", header = TRUE, sep = ",")

## Convert to date time objects
agreed_labels$TIME_STAMP <- as.POSIXct(agreed_labels$TIME_STAMP, format="%Y-%m-%d %H:%M:%OS")

feature_file$START_TIME <- as.POSIXct(feature_file$START_TIME, format="%Y-%m-%d %H:%M:%OS")
feature_file$STOP_TIME <- as.POSIXct(feature_file$STOP_TIME, format="%Y-%m-%d %H:%M:%OS")
feature_file$HEADER_TIME_STAMP <- as.POSIXct(feature_file$HEADER_TIME_STAMP, format="%Y-%m-%d %H:%M:%OS")


### Add mapped labels
feature_file$LABEL_CONSENSUS <- NA
feature_file$LABEL_INCL_TRANSITIONS <- NA

for (i in 1:nrow(feature_file)){
  temp_subset <- subset(agreed_labels, agreed_labels$TIME_STAMP >= feature_file$START_TIME[i] & agreed_labels$TIME_STAMP < feature_file$STOP_TIME[i])
  # feature_file$LABEL_CONSENSUS[i] <- as.character(tail(names(sort(table(temp_subset$EXP_1_LABELS))), 1))
  temp_subset$EXP_1_LABELS <- factor(temp_subset$EXP_1_LABELS)
  nlvl <- nlevels(temp_subset$EXP_1_LABELS)
  if (nrow(temp_subset) > 0){
    test_table <- table(temp_subset$EXP_1_LABELS)
    feature_file$LABEL_CONSENSUS[i] <- names(test_table)[test_table==max(test_table)]
    if (nlvl>1){
      feature_file$LABEL_INCL_TRANSITIONS[i] <- "Transition"
    } else {
      feature_file$LABEL_INCL_TRANSITIONS[i] <- feature_file$LABEL_CONSENSUS[i]
    }
     
  }
  else {
    feature_file$LABEL_CONSENSUS[i] <- "Unknown"
    feature_file$LABEL_INCL_TRANSITIONS[i] <- "Unkown"
  }
  
}

## Create a researcher specific label map
## Use data_label_master file to per second label

## Also add gt labels to it


# For exp 1:
### Add mapped labels
feature_file$EXP_1_LABELS <- NA
feature_file$EXP_2_LABELS <- NA
## Add gt labels here
# feature_file$GROUND_TRUTH <- NA
# feature_file$OLD_SWAN <- NA

for (i in 1:nrow(feature_file)){
  temp_subset <- subset(data_label_master, data_label_master$TIME_STAMP >= feature_file$START_TIME[i] & data_label_master$TIME_STAMP < feature_file$STOP_TIME[i])
  temp_subset$EXP_1_LABELS <- factor(temp_subset$EXP_1_LABELS)
  temp_subset$EXP_2_LABELS <- factor(temp_subset$EXP_2_LABELS)
  # temp_subset$GROUND_TRUTH <- factor(temp_subset$GROUND_TRUTH)
  # temp_subset$OLD_SWAN <- factor(temp_subset$OLD_SWAN)
  if (nrow(temp_subset) > 0){
    test_table_1 <- table(temp_subset$EXP_1_LABELS)
    feature_file$EXP_1_LABELS[i] <- names(test_table_1)[test_table_1==max(test_table_1)]
    test_table_2 <- table(temp_subset$EXP_2_LABELS)
    feature_file$EXP_2_LABELS[i] <- names(test_table_2)[test_table_2==max(test_table_2)]
    # test_table_gt <- table(temp_subset$GROUND_TRUTH)
    # feature_file$GROUND_TRUTH[i] <- names(test_table_gt)[test_table_gt==max(test_table_gt)]
    # test_table_old_swan <- table(temp_subset$OLD_SWAN)
    # feature_file$OLD_SWAN[i] <- names(test_table_old_swan)[test_table_old_swan==max(test_table_old_swan)]
    
  }
  else {
    feature_file$EXP_1_LABELS[i] <- "Unknown"
    feature_file$EXP_2_LABELS[i] <- "Unknown"
    # feature_file$GROUND_TRUTH[i] <- "Unknown"
    # feature_file$OLD_SWAN[i] <- "Unknown"
  }
  
}


write.csv(feature_file, file = "D:/Signaligner_Test_Datasets/MISC/IEEEvis_Datasets/STEPHEN_WRIST_DATA/labeled_windows_file.csv", row.names = FALSE, sep = ",")





