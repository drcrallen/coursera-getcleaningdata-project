coursera-getcleaningdata-project
================================

Coursera get and clean data project

QUICK USE:
source("run_analysis.R")

This will save a file called saveTable.txt in the current working directory.
The script assumes the data directory ./UCI HAR Dataset  can be found in the current working directory.

This script runs analysis on the [Human activity smartphone research](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones ) at UCI.

The original dataset can be downloaded in its entirety here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The run_analysis.R script takes the original data and transforms it into a tidy flat file. It also saves the data into the variable tidyData.

The data is filtered to only include the mean and standard deviation of various activities.

Example values are as follows:

subject_id|activity_name|variable|average
----------|-------------|--------|-------
1|LAYING|tBodyAcc.mean...X|0.22159824394
1|LAYING|tBodyAcc.mean...Y|-0.0405139534294
1|LAYING|tBodyAcc.mean...Z|-0.11320355358
1|LAYING|tBodyAcc.std...X|-0.9280564692
1|LAYING|tBodyAcc.std...Y|-0.83682740562
1|LAYING|tBodyAcc.std...Z|-0.826061401628

The potential values are as follows:

Column name|Type|Potential Values
-----------|----|----------------
subject_id|Integer|1..30
activity_name|String|c("LAYING","SITTING","STANDING","WALKING","WALKING_DOWNSTAIRS","WALKING_UPSTAIRS")
variable|String| ((see below))
average|Double| -1.0..1.0


#Notes on the origin of variable values
Train and test datasets will only be addressed as "train" for the purpose of this document. All train and test datasets are taken together to form one master dataset.
All references to train can have the letters "train" substituted verbatim for "test" to have the statement apply to the test dataset.
##subject_id
The subject ID is pulled directly from train/subject_train.txt in the appropriate train/test directory of the original dataset.
##activity_name
The activity name is acquired by pulling the activity type from train/y_train.txt and the label for the activity type from activity_labels.txt.
##variable
The variables are derived from the following core data sets:

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The labels themselves are for the mean or standard deviation and are formatted as follows:
* tBodyAcc.mean...X is the mean tBodyAcc measurement for the X asis
* tBodyAcc.std...X is the standard deviation of the tBodyAcc measurement for the X axis

More information on these can be found in features_info.txt

##average
The average value is the mean of the measurements for an activity for a particular subject for a particular variable. The original values were normalized to [-1,1]. There has been no attempt to re-normalize the mean values to have the same min/max as the original dataset.
