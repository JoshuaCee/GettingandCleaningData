#Set Working Directory
setwd("C:/Google Drive/Career/Machine Learning/R course/Getting and Cleaning Data")

###############################
#Step 1: Download and Unzip file
###############################


#Declare URL and filename
urlname <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <- "UCI HAR Dataset.zip"

if (!file.exists(filename)) {
  download.file(urlname, filename)
}

# Unzip the file
if (!file.exists("UCI HAR Dataset")) {
  unzip(filename)
}

###############################
#Step 2: Gather the training data
###############################

#Use this package to speed up reading in files.
library(data.table)

#First, let's get the feature names.
featurenames <- fread('UCI HAR Dataset/features.txt')
featurenames <- make.names(as.matrix(featurenames[,2]))
featurenames <- tolower(featurenames)

#Now, let's get the training data
trainset <- fread('UCI HAR Dataset/train/X_train.txt')
trainlabels <- fread('UCI HAR Dataset/train/y_train.txt')
trainsubject <- fread('UCI HAR Dataset/train/subject_train.txt')

#Relabel training names
names(trainset) <- featurenames
names(trainlabels) <- 'labels'
names(trainsubject) <- 'subject'

train <- cbind(trainlabels,trainsubject, trainset)

###############################
#Step 2: Gather the test data
###############################

#Now, let's get the test data
testset <- fread('UCI HAR Dataset/test/X_test.txt')
testlabels <- fread('UCI HAR Dataset/test/y_test.txt')
testsubject <- fread('UCI HAR Dataset/test/subject_test.txt')

#Relabel training names
names(testset) <- featurenames
names(testlabels) <- 'labels'
names(testsubject) <- 'subject'

test <- cbind(testlabels,testsubject, testset)

###############################
#Step 3: We can combine the data now!
###############################

fullset <- rbind(train, test)
fullset <- as.data.frame(fullset)
fullset$subject <- as.factor(fullset$subject) #This is a factor variable

###############################
#Step 4: Get mean and standard deviation for each measurement
###############################

#All columns with the word 'mean' or 'std' in it
ind <- grep('mean|std',names(fullset))

#Extracted set
extracted <- fullset[c(1,2,ind)]

###############################
#Step 5: Descriptive activity names
###############################

#Get the activity labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt",stringsAsFactors = F)
extracted$labels <- as.factor(extracted$labels)

extracted$labels <- factor(extracted$labels, levels = activityLabels[,1], labels = activityLabels[,2])

###############################
#Step 6: Label data set with appropriate descriptive names
###############################

colnames(extracted) <- gsub('(^f|freq)','frequency_',colnames(extracted))
colnames(extracted) <- gsub('^t','time_',colnames(extracted))
colnames(extracted) <- gsub('^angle','angle_',colnames(extracted))

colnames(extracted) <- gsub('accjerk','linearjerk',colnames(extracted))
colnames(extracted) <- gsub('gyrojerk','angularjerk',colnames(extracted))

colnames(extracted) <- gsub('gyro','gyroscope_',colnames(extracted))
colnames(extracted) <- gsub('acc','acceleration',colnames(extracted))
colnames(extracted) <- gsub('mag','magnitude',colnames(extracted))
colnames(extracted) <- gsub('bodybody','body',colnames(extracted))
colnames(extracted) <- gsub('gravitymean','_gravitymean',colnames(extracted))

colnames(extracted) <- gsub('\\.mean','_mean',colnames(extracted))
colnames(extracted) <- gsub('std','_std',colnames(extracted))
colnames(extracted) <- gsub("\\.", "", colnames(extracted))

colnames(extracted) <- gsub("x$","_x",colnames(extracted))
colnames(extracted) <- gsub("y$","_y",colnames(extracted))
colnames(extracted) <- gsub("z$","_z",colnames(extracted))
colnames(extracted) <- gsub("__","_",colnames(extracted))
colnames(extracted) <- gsub("_$","",colnames(extracted))


colnames(extracted)

###############################
#Step 7: Clean and Publish
###############################

library(dplyr)

# Find the average of each variable for each activity and each subject.
tidy <- extracted %>% 
  group_by(subject, labels) %>%
  summarise_all(mean)

# Publish finally!
write.table(tidy, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)