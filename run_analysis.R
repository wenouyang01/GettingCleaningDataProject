## Getting and Cleaning Data
## Week 4 Project
## 
## ---------------------------
## Read in the data from files
## ---------------------------

install.packages("dplyr")
library(dplyr)

## Activity labels and features
activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")

## First part - test data
subject_test <- read.table("subject_test.txt")
x_test <- read.table("X_test.txt", col.names = features[,2])
y_test <- read.table("y_test.txt")

# 2nd part - train data
subject_train <- read.table("subject_train.txt")
x_train <- read.table("X_train.txt", col.names = features[,2])
y_train <- read.table("y_train.txt")

##
## 1. Merges the training and the test sets to create one data set.
##

## Merge test data and train data

test_data <- cbind(subject_test, y_test, x_test)
train_data <- cbind(subject_train, y_train, x_train)

all_data <- rbind(test_data, train_data)
colnames(all_data)[1] <- "subject"
colnames(all_data)[2] <- "activity"

## -------------------------------------------------------------
## 2. Extracts measurements on mean and standard deviation (std)
## -------------------------------------------------------------
mean_std_data <- all_data[grepl("mean|std", names(all_data))]
all_mean_std_data <- cbind(all_data[,1:2], mean_std_data)

## ----------------------------------------------------------------
## 3. Uses descriptive activity names to name the activities in the 
##    data set
## ----------------------------------------------------------------
all_mean_std_data$activity <- activity_labels[all_mean_std_data$activity, 2]

## -----------------------------------------------------
## 4. Appropriately labels the data set with descriptive 
##    variable names.
## -----------------------------------------------------

names(all_mean_std_data) <- gsub("^t", "time", names(all_mean_std_data))
names(all_mean_std_data) <- gsub("^f", "freq", names(all_mean_std_data))
names(all_mean_std_data) <- tolower(names(all_mean_std_data))

## -------------------------------------------------------------
## 5. From the data set in step 4, creates a second, independent
##    tidy data set with the average of each variable for each 
##    activity and each subject.
## -------------------------------------------------------------

mean_std_summary <- all_mean_std_data %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))

## Write the summary data to a file
write.table(mean_std_summary, "mean_std_summary.txt",row.name=FALSE)

## Build code book
write.table(names(mean_std_summary), "CodeBook.txt")









