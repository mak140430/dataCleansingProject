setwd('C:/Users/Maga/Desktop/UCI HAR Dataset/')




# Load activity labels + features
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt"); 
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation
featuresNeeded <- grep(".*mean.*|.*std.*", features[,2])
featuresNeeded.names <- features[featuresNeeded,2]
featuresNeeded.names = gsub('-mean', 'Mean', featuresNeeded.names)
featuresNeeded.names = gsub('-std', 'Std', featuresNeeded.names)
featuresNeeded.names <- gsub('[-()]', '', featuresNeeded.names)

# Load the datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresNeeded]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresNeeded]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)


# Combine training and test data to create a final data set
finalData <- rbind(train,test)
colnames(finalData) <- c("subject", "activity", featuresNeeded.names)

# convert activities & subjects into factors

finalData$activity <- factor(finalData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
finalData$subject <- as.factor(finalData$subject)


finalData.melted <- melt(finalData, id = c("subject", "activity"))
finalData.mean <- dcast(finalData.melted, subject + activity ~ variable, mean)

write.table(finalData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)


