##
# Assignment Info
#
# The purpose of this project is to demonstrate your ability to collect, 
# work with, and clean a data set. The goal is to prepare tidy data that 
# can be used for later analysis. You will be graded by your peers on a 
# series of yes/no questions related to the project. You will be required 
# to submit: 1) a tidy data set as described below, 2) a link to a Github 
# repository with your script for performing the analysis, and 3) a code 
# book that describes the variables, the data, and any transformations or 
# work that you performed to clean up the data called CodeBook.md. You 
# should also include a README.md in the repo with your scripts. This 
# repo explains how all of the scripts work and how they are connected.  

# You should create one R script called run_analysis.R that does the following. 

# 1 Merges the training and the test sets to create one data set.
# 2 Extracts only the measurements on the mean and standard deviation for 
#   each measurement. 
# 3 Uses descriptive activity names to name the activities in the data set
# 4 Appropriately labels the data set with descriptive variable names. 
# 5 From the data set in step 4, creates a second, independent tidy data set 
#   with the average of each variable for each activity and each subject.
##



# Load features list
features <- read.table("features.txt")

# Get locations of features for mean and std
mean_fields <- grep("mean", features[,2])
std_fields <- grep("std", features[,2])

# Combine the feature location lists and sort in ascending order
mean_std_fields <- sort(c(mean_fields, std_fields))



# Load train data
xtrain <- read.table("train/X_train.txt", col.names = features[,2])
ytrain <- read.table("train/y_train.txt", col.names = "activity")
subject_train <- read.table("train/subject_train.txt", col.names = "subject")

# From xtrain data get just columns for mean and std
xtrain <- xtrain[,mean_std_fields]

# Load activity labels
activity_labels <- read.table("activity_labels.txt")

# Change numerical values for activities to their text value
#y_activity_value_index <- match(ytrain$activity, activity_labels$V1)
#ytrain$activity <- activity_labels$V2[y_activity_value_index]

# Combine subject, ytrain, and xtrain data
subject_y_x_train <- cbind(subject_train, ytrain, xtrain)



# Load test data
xtest <- read.table("test/X_test.txt", col.names = features[,2])
ytest <- read.table("test/y_test.txt", col.names = "activity")
subject_test <- read.table("test/subject_test.txt", col.names = "subject")

# From xtest data get just columns for mean and std
xtest <- xtest[,mean_std_fields]

# Load activity labels
activity_labels <- read.table("activity_labels.txt")

# Change numerical values for activities to their text value
#y_activity_value_index <- match(ytest$activity, activity_labels$V1)
#ytest$activity <- activity_labels$V2[y_activity_value_index]

# Combine subject, ytest, and xtest data
subject_y_x_test <- cbind(subject_test, ytest, xtest)



# Combine the train and test data
data_combined <- rbind(subject_y_x_train, subject_y_x_test)


# Arrange data by subject and activity
data_combined <- arrange(data_combined, subject, activity)

# Get new data set with means for each column for each subject and activity
data_combined <- group_by(data_combined, subject, activity)
data_averaged <- data_combined %>% summarise_each(funs(mean))

# Write data out to working directory
write.table(data_averaged, file = "UCI_HAR_Dataset_averaged.txt", row.names = FALSE)



