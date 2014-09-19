# require dplyr and tidyr to be loaded for processing of the datasets

require(dplyr)
require(tidyr)

###############################################################################
##1. Merges the training and the test sets to create one data set.           ##
###############################################################################
##Read the data, assuming the current working directory is "UCI HAR Dataset" ##
###############################################################################
#Read column names
feature_names <- read.csv("features.txt", sep="", header=F)

##Read training data
train_set <- read.csv("train/X_train.txt", sep="", header=F)
train_labels <- read.csv("train/y_train.txt", sep="", header=F)
train_subj <- read.csv("train/subject_train.txt", sep="", header=F)

##Read testing data
test_set <- read.csv("test/X_test.txt", sep="", header=F)
test_labels <- read.csv("test/y_test.txt", sep="", header=F)
test_subj <- read.csv("test/subject_test.txt", sep="", header=F)

##Label and combine data sets
colnames(train_subj) <- "Subject"
colnames(test_subj) <- "Subject"
colnames(train_labels) <- "ActivityLabel"
colnames(test_labels) <- "ActivityLabel"
colnames(train_set) <- feature_names$V2
colnames(test_set) <- feature_names$V2
train_combined <- cbind(train_labels, train_subj, train_set)
test_combined <- cbind(test_labels, test_subj, test_set)
combined_data <- rbind(train_combined, test_combined)

##We now have one data set which I'll make into a dplyr tbl_df
combined_data <- tbl_df(combined_data)

##Clean up extraneous interim data
rm(feature_names, train_set, train_labels, train_subj, test_set, test_labels, 
   test_subj, train_combined, test_combined)

###############################################################################
##2. Extracts only the measurements on the mean and standard deviation for   ##
##   each measurement.                                                       ##
###############################################################################

reduced_data <- select(combined_data, contains("Subject"), 
     contains("Activity"), contains("mean"), contains("std"))

###############################################################################
##3. Uses descriptive activity names to name the activities in the data set  ##
###############################################################################

##Read descriptive activity labels
activity_labels <- read.csv("activity_labels.txt", sep="", header = F)
colnames(activity_labels) <- c("ActivityLabel", "Activity")

##Replace Activity Label values with descriptive terms
join_activities <- inner_join(reduced_data, activity_labels)
reduced_data <- select(join_activities, Subject, Activity, 
     contains("tBodyAcc-mean"):contains("fBodyBodyGyroJerkMag-std"))

##Clean up extraneous interim data
rm(activity_labels, join_activities, combined_data)

###############################################################################
##4. Appropriately labels the data set with descriptive variable names.      ##
###############################################################################

##Remove parentheses
names(reduced_data) <- gsub('\\(|\\)',"",names(reduced_data))
##Change beginning f or t
names(reduced_data) <- gsub('^t',"TimeDomain.",names(reduced_data))
names(reduced_data) <- gsub('^f',"FrequencyDomain.",names(reduced_data))
##Change std to Std Deviation
names(reduced_data) <- gsub('\\-std',".Std Deviation.", names(reduced_data))
##Change mean
names(reduced_data) <- gsub('\\-mean',".Mean.", names(reduced_data))
## Change Gyro to Gyroscope
names(reduced_data) <- gsub('\\Gyro',".Gyroscope.", names(reduced_data))
names(reduced_data) <- gsub('\\Acc',".Accelerometer.", names(reduced_data))
##Change axis name
names(reduced_data) <- gsub('\\-X',".X-axis.", names(reduced_data))
names(reduced_data) <- gsub('\\-Y',".Y-axis.", names(reduced_data))
names(reduced_data) <- gsub('\\-Z',".Z-axis.", names(reduced_data))
##Remove extra periods
names(reduced_data) <- gsub('\\.\\.',".", names(reduced_data))

###############################################################################
##5. From the data set in step 4, creates a second, independent tidy data set## 
##   with the average of each variable for each activity and each subject.   ##
###############################################################################

##group_by activity, subject
grouped_data <- group_by(reduced_data, Activity, Subject)

#summarize with mean for each variable
mean_summarized_data <- summarise_each(grouped_data, funs(mean))

##write the table 
write.table(mean_summarized_data, "summarized_data.txt", row.name = F)