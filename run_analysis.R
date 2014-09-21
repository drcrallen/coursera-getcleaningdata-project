################################################################################
##
## run_analysis.R
## Builds a tidy dataset of the UCI HAR Dataset
##
## Input:
##    rootDir    A path to the root directory to the dataset
##
## Output:
##    A tidy dataset containing the subject_id, activity_name, variable,
##    mean value
##
## Example:
##    > tidyData <- loadTidyData("./UCI HAR Dataset")
##    > head(tidyData)
##    subject_id activity_name          variable     average
##    1          1        LAYING tBodyAcc.mean...X  0.22159824
##    2          1        LAYING tBodyAcc.mean...Y -0.04051395
##    3          1        LAYING tBodyAcc.mean...Z -0.11320355
##    4          1        LAYING  tBodyAcc.std...X -0.92805647
##    5          1        LAYING  tBodyAcc.std...Y -0.83682741
##    6          1        LAYING  tBodyAcc.std...Z -0.82606140
##


##
## This is only used for debugging and should probably not be used during
## thr normal course of business
## setwd("~/Coursera/DataScientist/DataCleaning/Project")
##
library(reshape)
library(plyr)

# Simple read of features file
loadFeatures <- function(rootDir){
    feature_table_fname <- paste(rootDir,"/features.txt",sep="")
    read.table(feature_table_fname, header=FALSE,sep=" ",col.names=c("feature_column","feature_name"))
}

# Simple read of activity labels
loadActivityLabels <- function(rootDir){
    activity_table_fname <- paste(rootDir,"/activity_labels.txt",sep="")
    read.table(activity_table_fname, header=FALSE, col.names=c("activity_id", "activity_name"))
}

loadData <- function(testOrTrain, rootDir){
    # Build the file names
    xFname <- paste(rootDir,"/",testOrTrain,"/X_",testOrTrain,".txt",sep="")
    yFname <- paste(rootDir,"/",testOrTrain,"/y_",testOrTrain,".txt",sep="")
    subjectFname <- paste(rootDir,"/",testOrTrain,"/subject_",testOrTrain,".txt",sep="")
    
    # Read feature table
    feature_table <- loadFeatures(rootDir)
    
    # Join the activity table
    activity_table <- loadActivityLabels(rootDir)
    yData <- read.table(yFname, header=FALSE, col.names=c("activity_id"))
    yData_joined <- join(yData, activity_table, by="activity_id")
    
    # Load subjects
    subjects <- read.table(subjectFname, header=FALSE, col.names=c("subject_id"))
    
    # Read the bulk data
    xData <- read.table(xFname, header=FALSE, col.names= feature_table$feature_name)
    
    # Now add  the subject_id and activity name as appropriate
    subject_id <- subjects$subject_id
    activity_name <- yData_joined$activity_name
    
    # We only want to keep SOME of the feature data
    is_desired_feature <- grepl("mean()",feature_table$feature_name) | grepl("std()",feature_table$feature_name)
    
    # Bind all the relevant columns together
    cbind(subject_id, activity_name, xData[,is_desired_feature])
}

# Read in the test and train data
# Then rbind the melt of the two data sets
loadMelt <- function(rootDir){
    testData <- loadData("test",rootDir)
    trainData <- loadData("train",rootDir)
    rbind(melt(testData, id=c("subject_id","activity_name")),melt(trainData,id=c("subject_id","activity_name")))
}


# The main entry of the file
# Calls the function to load and melt the data, then runs ddply to make sure
# we group by subject_id, activity_name, variable and take the mean
loadTidyData <- function(rootDir){
    meltedData <- loadMelt(rootDir)
    ddply(.data = meltedData, .(subject_id,activity_name,variable), summarize, average=mean(value))
}

tidyData <- loadTidyData("./UCI HAR Dataset")
write.table(tidyData,file="saveTable.txt",row.names=FALSE)