# File Name: run_analysis.R

# Import library for groupby in step 5
library(dplyr)

# 1) Download the data and unzip it to a local directory

#Download and unzip the data
if(!file.exists("./getting_and_cleaning_data_assignment")){dir.create("./getting_and_cleaning_data_assignment")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./getting_and_cleaning_data_assignment/Dataset.zip")
unzip(zipfile="./getting_and_cleaning_data_assignment/Dataset.zip",exdir="./getting_and_cleaning_data_assignment")

# 2) Extract the data to two data tables, assign column names and merge the training and the test sets to create one data set.

#Read the various unzipped data tables

#Read train data (no not for a neural net / ML :P):
x_train <- read.table("./getting_and_cleaning_data_assignment/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./getting_and_cleaning_data_assignment/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./getting_and_cleaning_data_assignment/UCI HAR Dataset/train/subject_train.txt")

#Read test data (no not for a neural net :P / ML):
x_test <- read.table("./getting_and_cleaning_data_assignment/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./getting_and_cleaning_data_assignment/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./getting_and_cleaning_data_assignment/UCI HAR Dataset/test/subject_test.txt")

#Read Labels
#Read features:
features <- read.table('./getting_and_cleaning_data_assignment/UCI HAR Dataset/features.txt')
#Read activity_labels:
activitylabels = read.table('./getting_and_cleaning_data_assignment/UCI HAR Dataset/activity_labels.txt')

#Assign Labels to Data because they currently have none
#train
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
#test
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
#labels
colnames(activitylabels) <- c('activityId','activityName')

# Merge tables together
train <- cbind(y_train, subject_train, x_train)
test <- cbind(y_test, subject_test, x_test)
combined_tables <- rbind(train, test)

# 3) Extract only the measurements on the mean and standard deviation for each measurement from the data set.

cols <- colnames(combined_tables)
col_filter <- (grepl("activityId" , cols) | 
                   grepl("subjectId" , cols) | 
                   grepl("mean.." , cols) | 
                   grepl("std.." , cols) 
)
#Apply the filter
subset_combined_tables <- combined_tables[ ,col_filter]

# 4) Merge activity names to Id's to be more descriptiv and use pattern matching and replacing to rename variables with more descriptive variable names.

#Expand the activity labels with a merge
subset_combined_tables_labeled <- merge(subset_combined_tables, activitylabels,
                              by='activityId',
                              all.x=TRUE)
#Replace confusing portions of variable names with easier to understand names
names(subset_combined_tables_labeled)<-gsub("^t", "Time", names(subset_combined_tables_labeled))
names(subset_combined_tables_labeled)<-gsub("^f", "Frequency", names(subset_combined_tables_labeled))
names(subset_combined_tables_labeled)<-gsub("Acc", "Accelerometer", names(subset_combined_tables_labeled))
names(subset_combined_tables_labeled)<-gsub("angle", "Angle", names(subset_combined_tables_labeled))
names(subset_combined_tables_labeled)<-gsub("BodyBody", "Body", names(subset_combined_tables_labeled))
names(subset_combined_tables_labeled)<-gsub("-freq()", "Frequency", names(subset_combined_tables_labeled), ignore.case = TRUE)
names(subset_combined_tables_labeled)<-gsub("gravity", "Gravity", names(subset_combined_tables_labeled))
names(subset_combined_tables_labeled)<-gsub("Gyro", "Gyroscope", names(subset_combined_tables_labeled))
names(subset_combined_tables_labeled)<-gsub("Mag", "Magnitude", names(subset_combined_tables_labeled))
names(subset_combined_tables_labeled)<-gsub("-mean()", "Mean", names(subset_combined_tables_labeled), ignore.case = TRUE)
names(subset_combined_tables_labeled)<-gsub("-std()", "STD", names(subset_combined_tables_labeled), ignore.case = TRUE)
names(subset_combined_tables_labeled)<-gsub("tBody", "TimeBody", names(subset_combined_tables_labeled))

# 5) Group the data by activity and subject and then take the mean at that level of detail for each variable.

group_data <- group_by(subset_combined_tables_labeled, subjectId, activityName)
group_summary <- summarise_all(group_data, list(mean))

# 6) Store the data to the "tidydata.txt" file.

write.table(group_summary, "tidydata.txt", row.name=FALSE)
