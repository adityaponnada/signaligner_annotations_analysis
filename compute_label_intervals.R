## Use this script to compute the label interval and summary statistics for different labels from the user annotations

# Import library
library(psych)
options(digits.secs=3)

## Read file
annotation_file <- read.csv(file="D:/Signaligner_Test_Datasets/Expert_labels/Ground_truth_labels/ground_truth_labels.csv", sep = ",", header = TRUE)

## Convert to date time object
annotation_file$START_TIME <- as.POSIXct(annotation_file$START_TIME, format="%Y-%m-%d %H:%M:%OS")
annotation_file$STOP_TIME <- as.POSIXct(annotation_file$STOP_TIME, format="%Y-%m-%d %H:%M:%OS")

# get time diff
#annotation_file$DIFF_TIMR <- difftime(annotation_file$STOP_TIME, annotation_file$START_TIME, units = "mins")
annotation_file$DIFF_TIMR <- as.numeric(annotation_file$STOP_TIME- annotation_file$START_TIME)/60

annotation_file$PREDICTION <- as.factor(annotation_file$PREDICTION)

### Get summary of the non-wear windows
non_wear_subset <- subset(annotation_file, annotation_file$PREDICTION == "Nonwear")

describe(non_wear_subset$DIFF_TIMR)
