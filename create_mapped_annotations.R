## import libraries
library(reshape2)
library(dplyr)
library(plyr)
library(irrCAC)
options(digits.secs = 3)

## Create a master time stamp list
start_time_stamp = as.POSIXct("2019-06-03 00:15:00.000", format = "%Y-%m-%d %H:%M:%OS")
end_time_stamp = as.POSIXct("2019-06-05 16:35:30.000", format = "%Y-%m-%d %H:%M:%OS")

## Create a one second window list
master_time_list = c(start_time_stamp)
del_time = difftime(end_time_stamp, start_time_stamp, units = "secs")

iterations = del_time[[1]]

for (i in 1:iterations){
  next_time = start_time_stamp + i
  master_time_list <- append(master_time_list, next_time)
}

# View(master_time_list)

data_label_master <- as.data.frame(master_time_list)

names(data_label_master) <- "TIME_STAMP"

user1_labels <- read.csv(file="D:/Signaligner_Test_Datasets/Expert_labels/Exp1_labels/Exp1_only_labels.csv", header = TRUE, sep = ",")

user2_labels <- read.csv(file="D:/Signaligner_Test_Datasets/Expert_labels/Exp2_labels/Exp2_only_labels.csv", header = TRUE, sep = ",")

user1_labels$START_TIME <- as.POSIXct(user1_labels$START_TIME, format = "%Y-%m-%d %H:%M:%OS")
user1_labels$STOP_TIME <- as.POSIXct(user1_labels$STOP_TIME, format = "%Y-%m-%d %H:%M:%OS")
user2_labels$START_TIME <- as.POSIXct(user2_labels$START_TIME, format = "%Y-%m-%d %H:%M:%OS")
user2_labels$STOP_TIME <- as.POSIXct(user2_labels$STOP_TIME, format = "%Y-%m-%d %H:%M:%OS")


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

## Get user 1 labels mapped to master time stamp list
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

# Computing agreement between the annotators
label_set <- data_label_master[, -1]

stats_val <- krippen.alpha.raw(label_set, weights = "unweighted", categ.labels = c("Sleep", "Wear", "Nonwear"))

stats_val$est$coeff.val

### Save the label_set file
write.csv(label_set, file = paste0(user_label_path, "label_set_file.csv"), row.names = FALSE, sep = ",")

