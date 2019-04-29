## Import Package
library(dplyr)

## Read data
#getwd()
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("label", "activity"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("feature", "functions"))  
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "label")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "label")


## 1. Merges the training and the test sets to create one data set.
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
merged <- cbind(subject, x, y)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
clean_data <- merged %>% select(subject, label, contains("mean"), contains("std"))


## 3. Uses descriptive activity names to name the activities in the data set
clean_data$label <- activity_labels[clean_data$label, 2]


## 4. Appropriately labels the data set with descriptive variable names.
#names(clean_data)
names(clean_data)[2] = "activity"
names(clean_data)<-gsub("...X", "-X", names(clean_data))
names(clean_data)<-gsub("...Y", "-Y", names(clean_data))
names(clean_data)<-gsub("...Z", "-Z", names(clean_data))


## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data <- clean_data %>%
  group_by(subject, activity) %>%
  summarise_all(.funs = mean)
write.table(tidy_data, "tidy_data.txt", row.name=FALSE)

