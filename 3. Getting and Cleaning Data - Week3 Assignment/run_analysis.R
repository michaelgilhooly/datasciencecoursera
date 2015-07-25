### Assignment: Getting and Cleaning Data
## Steps that need to be completed for the assignment:
################################################

## Setup and load all data

library(dplyr)

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

activities_data <- read.table("UCI HAR Dataset/activity_labels.txt")

################################################
# 1. Merges the training and the test sets to create one data set.
################################################

x_raw_data <- rbind(x_train, x_test)
y_raw_data <- rbind(y_train, y_test)
subject_raw_data <- rbind(subject_train, subject_test)

################################################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
################################################

features_data <- read.table("UCI HAR Dataset/features.txt")

mean_and_std_features <- grep("-(mean|std)\\(\\)", features_data[, 2])
x_raw_data <- x_raw_data[, mean_and_std_features]
names(x_raw_data) <- features_data[mean_and_std_features, 2]

################################################
# 3. Uses descriptive activity names to name the activities in the data set
################################################

y_raw_data[, 1] <- activities_data[y_raw_data[, 1], 2]
names(y_raw_data) <- "activity"

################################################
# 4. Appropriately labels the data set with descriptive variable names. 
################################################

names(subject_raw_data) <- "subject"
all_data <- cbind(x_raw_data, y_raw_data, subject_raw_data)

################################################
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
################################################

tidy_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(tidy_data, "tidy_data.txt", row.name=FALSE)
