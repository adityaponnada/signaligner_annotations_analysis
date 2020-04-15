## Include libraries

library(reshape2)
options(digits.secs = 3)

## Read the matched labels file

matched_file <- read.csv(file="D:/Signaligner_Test_Datasets/Expert_labels/data_label_master.csv", header = TRUE, sep = ",")

## Filter out the agreed labels
agreed_labels <- subset(matched_file, matched_file$EXP_1_LABELS == matched_file$EXP_2_LABELS)

agreed_labels <- na.omit(agreed_labels)

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

# For exp 1:
### Add mapped labels
feature_file$EXP_1_LABELS <- NA
feature_file$EXP_2_LABELS <- NA

for (i in 1:nrow(feature_file)){
  temp_subset <- subset(data_label_master, data_label_master$TIME_STAMP >= feature_file$START_TIME[i] & data_label_master$TIME_STAMP < feature_file$STOP_TIME[i])
  temp_subset$EXP_1_LABELS <- factor(temp_subset$EXP_1_LABELS)
  temp_subset$EXP_2_LABELS <- factor(temp_subset$EXP_2_LABELS)
  if (nrow(temp_subset) > 0){
    test_table_1 <- table(temp_subset$EXP_1_LABELS)
    feature_file$EXP_1_LABELS[i] <- names(test_table_1)[test_table_1==max(test_table_1)]
    test_table_2 <- table(temp_subset$EXP_2_LABELS)
    feature_file$EXP_2_LABELS[i] <- names(test_table_2)[test_table_2==max(test_table_2)]
    
  }
  else {
    feature_file$EXP_1_LABELS[i] <- "Unknown"
    feature_file$EXP_2_LABELS[i] <- "Unkown"
  }
  
}


write.csv(feature_file, file = "D:/Signaligner_Test_Datasets/MISC/IEEEvis_Datasets/STEPHEN_WRIST_DATA/labeled_windows_file.csv", row.names = FALSE, sep = ",")





