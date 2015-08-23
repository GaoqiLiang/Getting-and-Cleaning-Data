setwd("/Users/c3179782/Desktop/R/Coursera/Getting_and_Cleaning_Data_Lecture2_Project")

## download files
library (httr)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file <- "original.zip"
if(!file.exists(file)){
  download.file(url, file)
}

#unzip and create folders (if those ain't exist)
datafolder <- "UCI HAR Dataset"
if(!file.exists(datafolder)){
  unzip(file, list = FALSE, overwrite = TRUE)
}

library(plyr)

# Step 1
# Merge the training and test sets to create one data set
###############################################################################

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# create 'x' data set
x_data <- rbind(x_train, x_test)

# create 'y' data set
y_data <- rbind(y_train, y_test)

# create 'subject' data set
subject_data <- rbind(subject_train, subject_test)

# merge them into one 
x_y_data <- cbind(x_data, y_data)
subject_x_y_data <- cbind(subject_data, x_y_data)

# Step 2
# Extract only the measurements on the mean and standard deviation for each measurement
###############################################################################

features <- read.table("UCI HAR Dataset/features.txt")

# get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
x_data <- x_data[, mean_and_std_features]

# correct the column names
names(x_data) <- features[mean_and_std_features, 2]


# Step 3
# Use descriptive activity names to name the activities in the data set
###############################################################################

activities <- read.table("UCI HAR Dataset/activity_labels.txt")

# update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# correct column name
names(y_data) <- "activity"

# Step 4
# Appropriately label the data set with descriptive variable names
###############################################################################

# correct column name
names(subject_data) <- "subject"

# bind all the data in a single data set
all_data <- cbind(x_data, y_data, subject_data)


# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################

# columns but last two (activity & subject)
tidy_data_averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(tidy_data_averages_data, "tidy_data_averages_data.txt", row.name=FALSE)
