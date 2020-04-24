## import libraries
library(reshape2)
library(dplyr)
library(plyr)
library(irrCAC)
options(digits.secs = 3)

## Create a master time stamp list
start_time_stamp = as.POSIXct("2019-06-19 16:10:00.000", format = "%Y-%m-%d %H:%M:%OS")
end_time_stamp = as.POSIXct("2019-06-27 11:58:16.988", format = "%Y-%m-%d %H:%M:%OS")

## Create a one second window list
master_time_list = c(start_time_stamp)
del_time = difftime(end_time_stamp, start_time_stamp, units = "secs")

iterations = as.integer(del_time[[1]])

# for (i in 1:iterations){
#   next_time = start_time_stamp + i
#   master_time_list <- append(master_time_list, next_time)
# }

master_time_list <- seq.POSIXt(start_time_stamp, end_time_stamp, by=1)

# View(master_time_list)

data_label_master <- as.data.frame(master_time_list)

names(data_label_master) <- "TIME_STAMP"

user1_labels <- read.csv(file="D:/Signaligner_Test_Datasets/Expert_labels/Exp1_labels/Exp1_only_labels.csv", header = TRUE, sep = ",")

user2_labels <- read.csv(file="D:/Signaligner_Test_Datasets/Expert_labels/Exp2_labels/Exp2_only_labels.csv", header = TRUE, sep = ",")

## Create a gt file here
ground_truth_labels <- read.csv(file="D:/Signaligner_Test_Datasets/Expert_labels/Ground_truth_labels/ground_truth_labels.csv", header = TRUE, sep = ",")

user1_labels$START_TIME <- as.POSIXct(user1_labels$START_TIME, format = "%Y-%m-%d %H:%M:%OS")
user1_labels$STOP_TIME <- as.POSIXct(user1_labels$STOP_TIME, format = "%Y-%m-%d %H:%M:%OS")
user2_labels$START_TIME <- as.POSIXct(user2_labels$START_TIME, format = "%Y-%m-%d %H:%M:%OS")
user2_labels$STOP_TIME <- as.POSIXct(user2_labels$STOP_TIME, format = "%Y-%m-%d %H:%M:%OS")

ground_truth_labels$START_TIME <- as.POSIXct(ground_truth_labels$START_TIME, format = "%Y-%m-%d %H:%M:%OS")
ground_truth_labels$STOP_TIME <- as.POSIXct(ground_truth_labels$STOP_TIME, format = "%Y-%m-%d %H:%M:%OS")


## Get user 1 labels mapped to master time stamp list
data_label_master$EXP_1_LABELS <- NA
data_label_master$EXP_1_LABELS <- as.character(data_label_master$EXP_1_LABELS)

for (i in 1:nrow(data_label_master)){
  time_stamp <- data_label_master$TIME_STAMP[i]
  for (j in 1:nrow(user1_labels)){
    if (user1_labels$START_TIME[j] <= time_stamp && time_stamp < user1_labels$STOP_TIME[j]){
      # print("Condition met")
      data_label_master$EXP_1_LABELS[i] = as.character(user1_labels$PREDICTION[j])
      break
    }
  }
  
}

## Get user 2 labels mapped to master time stamp list
data_label_master$EXP_2_LABELS <- NA
data_label_master$EXP_2_LABELS <- as.character(data_label_master$EXP_2_LABELS)

for (i in 1:nrow(data_label_master)){
  time_stamp <- data_label_master$TIME_STAMP[i]
  for (j in 1:nrow(user2_labels)){
    if (user2_labels$START_TIME[j] <= time_stamp && time_stamp < user2_labels$STOP_TIME[j]){
      # print("Condition met")
      data_label_master$EXP_2_LABELS[i] = as.character(user2_labels$PREDICTION[j])
      break
    }
  }
  
}

### Get gt labels mapped to master time stamp list

# copy the code from above t create the mapped file
data_label_master$GROUND_TRUTH <- NA
data_label_master$GROUND_TRUTH <- as.character(data_label_master$GROUND_TRUTH)

for (i in 1:nrow(data_label_master)){
  time_stamp <- data_label_master$TIME_STAMP[i]
  for (j in 1:nrow(ground_truth_labels)){
    if (ground_truth_labels$START_TIME[j] <= time_stamp && time_stamp < ground_truth_labels$STOP_TIME[j]){
      # print("Condition met")
      data_label_master$GROUND_TRUTH[i] = as.character(ground_truth_labels$PREDICTION[j])
      break
    }
  }
  
}

### Get algo labels mapped to master time stamp list

# copy the code from above algo create the mapped file
data_label_master$OLD_SWAN <- NA
data_label_master$OLD_SWAN <- as.character(data_label_master$OLD_SWAN)

for (i in 1:nrow(data_label_master)){
  time_stamp <- data_label_master$TIME_STAMP[i]
  for (j in 1:nrow(algo_only_labels)){
    if (algo_only_labels$START_TIME[j] <= time_stamp && time_stamp < algo_only_labels$STOP_TIME[j]){
      # print("Condition met")
      data_label_master$OLD_SWAN[i] = as.character(algo_only_labels$PREDICTION[j])
      break
    }
  }
  
}

# Computing agreement between the annotators
label_set <- data_label_master[, -1]

stats_val <- krippen.alpha.raw(label_set, weights = "unweighted", categ.labels = c("Sleep", "Wear", "Nonwear"))

stats_val$est$coeff.val
## Agreement: 0.85(CI: 0.84, 0.87), p <0.001


## Create a subset with gt and exp1
gt_exp1_set <- data_label_master[, c("EXP_1_LABELS", "GROUND_TRUTH")]
stats_val_gt_exp1 <- krippen.alpha.raw(gt_exp1_set, weights = "unweighted", categ.labels = c("Sleep", "Wear", "Nonwear"))

stats_val_gt_exp1$est$coeff.val

## Create a subset with gt and exp2

## compute agreement between gt and exp2
gt_exp2_set <- data_label_master[, c("EXP_2_LABELS", "GROUND_TRUTH")]
stats_val_gt_exp2 <- krippen.alpha.raw(gt_exp2_set, weights = "unweighted", categ.labels = c("Sleep", "Wear", "Nonwear"))

stats_val_gt_exp2$est$coeff.val



## Compute labeling accuracy using confusion matrices



### Save the label_set file
write.csv(label_set, file = paste0(user_label_path, "label_set_file.csv"), row.names = FALSE, sep = ",")
write.csv(data_label_master, file = paste0(user_label_path, "data_label_master.csv"), row.names = FALSE, sep = ",")

