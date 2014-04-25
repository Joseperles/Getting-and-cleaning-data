#Getting and cleaning data
#run_analysis.R peer review assignment
getwd()
#please, put your extracted data in your working directory
#please, don't change directory structure
# Read data test and training datasets.
datatest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
datatrain <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
#Task one: merges the training and the test sets to create one data set.
datall<- rbind(datatest, datatrain)
#Preparing data for task 3 (uses descriptive activity names to name the activities in data set)
# read subject column and put it into a vector
stest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
strain <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
s<- rbind(stest,strain)
colnames(s) <- c("subject")
s$subject <- as.factor(s$subject)
# read activity codes and put it into a vector
actytest <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
actytrain <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
activity <- rbind(actytest, actytrain)
colnames(activity) <- c("activity")
# read activity_labels and make activity a factor for easy analysis  
dummy <- scan("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", what = "character", sep=" ")
s1 <- seq(2, length(dummy), by= 2)
activity_labels <- dummy[s1]
activity$activity <-factor(activity$activity, labels = activity_labels)  
# read feature names
dummy <- scan("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt", what = "character", sep = " ")
s1 <- seq(2,length(dummy), by= 2)
features <- dummy[s1]
names(datall) <- features
# Task 3 and 4: add all labels to dataset 
datalabel <- cbind(subject, activity)
datanalysis <- cbind(datalabel, datall)
#Task 2: Extracts only the measurements on the mean and standard deviation for each measurement.
# select column variables with mean |and standard dev using grep function
means <- grep("[Mm][Ee][Aa][Nn]", names(datanalysis))  # select means
std <- grep("[Ss][Tt][Dd]", names(datanalysis))  # select standard deviation
vars <- append(means, std, after = length(means))
subact <- c(1,2)  # add subject and actvity
vars <- append(onetwo, vars, after = length(subact))
vars <- sort(vars)  
# create tidy data with only mean and standard deviation for each measure
tidy_data <- datanalysis[,vars]
# Task 5: install needed and extra libraries
library(plyr)
library(reshape)
library(reshape2)
# melt the data frame -using subject and activity as IDs -
mdata <- melt(tidy_data) 
msactivity <-cast(mdata, ... ~ variable, mean) #means for each subject's activities
# write the tidy data to a file
write.csv(msactivity, file= "tidy_data.txt", row.names=FALSE)
