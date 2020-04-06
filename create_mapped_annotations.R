## import libraries
library(reshape2)
library(dplyr)
library(plyr)
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


