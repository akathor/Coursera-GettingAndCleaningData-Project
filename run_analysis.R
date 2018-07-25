

### Downloading and unziping data ###

if (!file.exists("UCI HAR Dataset.zip")){
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(URL, "UCI HAR Dataset.zip" , method="curl")
}  
if (!file.exists("UCI HAR Dataset.zip")) { 
  unzip("UCI HAR Dataset.zip") 
}


###  Reading Data ###

# Activities, Features and Subjects
activities <- read.table("activity_labels.txt", header = FALSE)
names(activities) <- c("ID", "Activity")

ActivityTrain <- read.table("train/y_train.txt", header = FALSE, col.names = "IdAct")
ActivityTrain$Data_Origin = 'Train'
ActivityTest <- read.table("test/y_test.txt", header = FALSE, col.names = "IdAct")
ActivityTest$Data_Origin = 'Test'

Features <- read.table("features.txt", header = FALSE)
names(Features) <- c("ID", "Feat")

SubjectsTest <- read.table("test/subject_test.txt", header = FALSE, col.names = "SubjectID")
SubjectsTrain <- read.table("train/subject_train.txt", header = FALSE, col.names = "SubjectID")

Xtrain <- read.table("train/X_train.txt", header = FALSE, col.names = Features$Feat)
Xtest <- read.table("test/X_test.txt", header = FALSE, col.names = Features$Feat)


###  1.- Merges the training and the test sets to create one data set.   ###

ActivityTest <- merge(ActivityTest, activities, by.x = "IdAct", by.y = "ID", all = TRUE)
ActivityTrain <- merge(ActivityTrain, activities, by.x = "IdAct", by.y = "ID", all = TRUE)

train <- cbind(ActivityTrain, SubjectsTrain, Xtrain)
test <- cbind(ActivityTest, SubjectsTest, Xtest)

Data <- rbind(train, test)
rm(activities, test, train, ActivityTest, ActivityTrain, SubjectsTest, SubjectsTrain, Xtest, Xtrain)


###   2.- Extracts only the measurements on the mean and standard deviation for each measurement. ###

MeanStdMeasures <- grepl("^Data_Origin$|^Activity$|^SubjectID$|mean|std", names(Data))
Data <- Data[,MeanStdMeasures]
rm(Features, MeanStdMeasures)

###   3.- Uses descriptive activity names to name the activities in the data set  ###
 ## (Done in step 1)


###   4.- Appropriately labels the data set with descriptive variable names.

names(Data) <- gsub("^f", "Frequency_", names(Data))
names(Data) <- gsub("^t", "Time_", names(Data))
names(Data) <- gsub("Acc", "Acceleration", names(Data))
names(Data) <- gsub("Gyro", "Gyroscope", names(Data))
names(Data) <- gsub("Mag", "Magnitude", names(Data))
names(Data) <- gsub("BodyBody", "Body", names(Data))
names(Data) <- gsub("\\.\\.", "", names(Data))
names(Data) <- gsub("\\.", "-", names(Data))


### 5.- From the data set in step 4, creates a second, independent tidy data set with
###     the average of each variable for each activity and each subject.

library(reshape2)
levels <- names(Data)[2:3]
n = length(names(Data))
var <- names(Data)[4:n]

Data$Data_Origin <- as.factor(Data$Data_Origin)
Data$Activity <- as.factor(Data$Activity) 
Data$SubjectID <- as.factor(Data$SubjectID)

DataMelt <- melt(Data, id=levels, measure.vars = var )
TidyData <- dcast(DataMelt, Activity + SubjectID ~ variable, mean)

write.table(TidyData, "TidyData.txt", row.names = FALSE, quote = FALSE)