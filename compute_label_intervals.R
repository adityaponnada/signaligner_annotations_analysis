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
annotation_file$DIFF_TIMR <- as.numeric(difftime(annotation_file$STOP_TIME, annotation_file$START_TIME, units = "mins"))

annotation_file$PREDICTION <- as.factor(annotation_file$PREDICTION)

### Get summary of the non-wear windows
non_wear_subset <- subset(annotation_file, annotation_file$PREDICTION == "Nonwear")

describe(non_wear_subset$DIFF_TIMR)


## Get the subset data frame where with sleep labels and the ones within fifteen minute of sleep labels
sleep_non_wear_subset <- subset(annotation_file, annotation_file$PREDICTION == "Nonwear" | annotation_file$PREDICTION == "Sleep")

sleep_non_wear_subset$START_STOP_DIFF <- 0.0
for (i in 2:nrow(sleep_non_wear_subset)){
  sleep_non_wear_subset$START_STOP_DIFF[i] = as.numeric(difftime(sleep_non_wear_subset$START_TIME[i],sleep_non_wear_subset$STOP_TIME[i-1], units = "mins"))
}

sleep_non_wear_subset$NONWEAR_AFTER_SLEEP <- FALSE

for (i in 2:nrow(sleep_non_wear_subset)){
  if (sleep_non_wear_subset$PREDICTION[i] == "Nonwear" & sleep_non_wear_subset$PREDICTION[i-1] == "Sleep"){
    sleep_non_wear_subset$NONWEAR_AFTER_SLEEP[i] <- TRUE
  }
}


final_non_wear <- subset(sleep_non_wear_subset, sleep_non_wear_subset$PREDICTION == "Nonwear")

model_assumed_non_wear <- subset(final_non_wear, final_non_wear$DIFF_TIMR >= 15.0)

all_swan_assumptions_nonwear <- subset(final_non_wear, final_non_wear$DIFF_TIMR >= 15.0 & final_non_wear$START_STOP_DIFF >= 15.0)

# model_assumed_non_wear <- subset(final_non_wear, final_non_wear$DIFF_TIMR >= 15.0)

describeBy(final_non_wear$DIFF_TIMR, group = final_non_wear$NONWEAR_AFTER_SLEEP)

describeBy(model_assumed_non_wear$DIFF_TIMR, group=model_assumed_non_wear$NONWEAR_AFTER_SLEEP)

hist(non_wear_subset$DIFF_TIMR)

### In case of ground truth annotations

## GT window range: mean = 28.6 min (SD: 40.63 min, median = 16.28 min, max: 158 min)

## only 15 instances of non-wear in the data set from ground truth out of which only 10 were > 15 min. Those that were outsode of sleep time range were (0,0,0) which the model assumes to be invalid data

nrow(final_non_wear) - nrow(model_assumed_non_wear)




