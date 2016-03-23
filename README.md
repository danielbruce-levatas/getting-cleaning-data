---
title: "README.md"
output: html_document
---

## Run Analysis 

The run_analysis.R file contains methods to merge, clean up and analyze the test and training sets from the following data set:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Below is a description of the key methods that load, clean up, merge and analyze the data. 

###getCombinedDataSet###

The getCombinedDataSet method is the core method of the analysis script. This method does the following:

1) Loads the activity name table from the "activity_labels.txt" file
2) Loads the feature descriptors and indices (just for the mean and std deviation features) from the "features.txt" file
3) Reads in both the test and training data sets using the **readDataSet** method
4) Returns the merged combination of the test and training data sets

###readDataSet###

The readDataSet method is used to read in and clean up a data set. It reads through each row of the specified X, Y, and Subject file names, accumulating
values for the specified features and merging the data into a single data frame in the form:

activityindex, subject, feature, value, activitydesc

###saveCombinedTidyDataSet###

The saveCombinedTidyDataSet method takes the combined data set (generated using the **getCombinedDataSet** method) and saves the data to a CSV file in the format:

id, subject, activitydesc, feature, value

###getGroupedSummary###

The getGroupedSummary method reads in a tidy data set (in the format: id, subject, activitydesc, feature, value) and generates a summarized data set 
summarizing the mean of each subject, activity, feature.

###generateTidyDataSets###

The generateTidyDataSets method generates the initial (ungrouped) tidy data set, and then generates the grouped summary data set and saves both to a CSV file. 

###Other Auxilliary Functions###

**getY(filename)** - reads a table of the Y values from a given Y value file

**getSubject(filename)** - reads a table of the Subject values from a given Subject file

**getFeatures()** - reads the set of all features from the features.txt file and returns a data frame in the format: index, description, func, coord, fullname

**getFriendlyNameFromFeature(st)** - gets the friendly name from a feature description in the format "1 tBodyAcc-mean()-X"

**getFunctionFromFeature(st)** - gets the function name from a feature description in the format "1 tBodyAcc-mean()-X"

**getCoordinateFromFeature(st)** - gets the coordinate name from a feature description in the format "1 tBodyAcc-mean()-X"

**getIndexFromFeature(st)** - gets the index from a feature description in the format "1 tBodyAcc-mean()-X"

**getDescriptionFromFeature(st)** - gets the friendly description from a feature description in the format "1 tBodyAcc-mean()-X"

**getRelevantFeatures()** - gets the subset of features with the functions mean() and std()

**getActivityNames()** - gets the set of all activity names from the activity_labels.txt file

**readTestDataSet()** - reads in the test data set

**readTrainDataSet()** - reads in the train data set

**saveDataSetCSV(filename, dataSet)** - saves the given dataset to a csv file

**loadTidyDataSet(filename)** - loads in a tidy data set in the format id, subject, activitydesc, feature, value 
