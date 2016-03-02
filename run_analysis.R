library(dplyr)
library(tidyr)
library(data.table)

#Read files
subjectTest <- read.table("test/subject_test.txt")
XTest <- read.table("test/X_test.txt")
YTest <- read.table("test/Y_test.txt")
features <- read.table("features.txt")

#Append train data to test data
X <- rbind(XTest, read.table("train/X_train.txt"))
Y <- rbind(YTest, read.table("train/y_train.txt"))
subject <- rbind(subjectTest, read.table("train/subject_train.txt"))

#Assign column names
head(features)
colnames(X) <- c(make.names(features$V2, unique = TRUE))

#Select mean and sd columns
mean_and_std <- select(X, contains("mean"), contains("std"))

#Label activities
activityLabel <- c(1:6)
activityName <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
activity = data.frame(activityLabel,activityName)

#Merge data
XY <- bind_cols(X,Y)
setnames(XY, "V1", "activityLabel")

#Add activity labels
XYActivity <- left_join(XY, activity)
XYSubject <- bind_cols(subject, XYActivity)

#Clean up the data, turn cols into values
tidyXYSubject <- gather(XYSubject, "feature", "value", 2:562)

#Summarize statistics by activity & statistical feature
tidyXYSubject2 <- tidyXYSubject %>% group_by(activityName, feature) %>% summarise(mean = mean(value))
