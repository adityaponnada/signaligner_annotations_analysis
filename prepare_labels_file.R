## Import libraries
library(psych)
library(MASS)
library(reshape2)
library(dplyr)
library(plyr)

## Import labels file
user_label_path = "D:/Signaligner_Test_Datasets/Expert_labels/"

folder_name = "Exp2_labels_full_swan_v2/" # get the ground truth labels file read here

label_file_name = "LeftWrist_TAS1E23150023_2019_06_27_RAW.csv"

user_labels <- read.csv(file = paste0(user_label_path, folder_name, label_file_name), header = TRUE, sep = ",")

## Split the file into user vs algo and save as two diferent files

user_only_labels <- subset(user_labels, user_labels$SOURCE == "Player")
algo_only_labels <- subset(user_labels, user_labels$SOURCE == "Algo")

## Save the files
write.csv(user_only_labels, file = paste0(user_label_path, folder_name, "Exp2_only_labels.csv"), row.names = FALSE, sep = ",") # Save the ground truth file here
write.csv(algo_only_labels, file = paste0(user_label_path, folder_name, "Algo2_only_labels.csv"), row.names = FALSE, sep = ",")
