library(dplyr)
library(stringr)

##reads the Y values from the specified file
getY <- function(filename) {
        yvals <- read.fwf(filename, c(2), header=FALSE)
        yvals
}

##reads the subject values from the specified file
getSubject <- function(filename) {
        subjects <- read.fwf(filename, c(2), header=FALSE)
        subjects
}

##reads the features.txt file and parses out the function, coordinate, index and description of each feature
getFeatures <- function() {
        features <- read.delim(".\\features.txt", header=FALSE, sep="\t", stringsAsFactors=FALSE)
        
        names(features)[1] <- "name"
        
        featureNames <- features$name
        
        friendlyNames <- sapply(featureNames, getFriendlyNameFromFeature)
        functions <- sapply(featureNames, getFunctionFromFeature)
        coordinates <- sapply(featureNames, getCoordinateFromFeature)
        indices <- sapply(featureNames, getIndexFromFeature)
        descriptions <- sapply(featureNames, getDescriptionFromFeature)
        
        ret <- data.frame(index=indices, description=descriptions, func=functions, coord=coordinates, fullname=friendlyNames, stringsAsFactors=FALSE)
        
        filter(ret, !is.na(index))
}
## helper function to get the friendly function from a feature description
getFriendlyNameFromFeature <- function(st) {
        spart <- strsplit(st, " ")
        spart[[1]][2]
}
## helper function to get the function from a feature description
getFunctionFromFeature <- function(st) {
        spart <- strsplit(st, " ")
        parts <- strsplit(spart[[1]][2],"-")
        parts[[1]][2]
}
## helper function to get the coordinate (if any) from a feature description
getCoordinateFromFeature <- function(st) {
        spart <- strsplit(st, " ")
        parts <- strsplit(spart[[1]][2],"-")
        parts[[1]][3]   
}
## helper function to get the index from a feature description
getIndexFromFeature <- function(st) {
        spart <- strsplit(st, " ")
        as.numeric(spart[[1]][1])
}
## helper function to get the description from a feature description
getDescriptionFromFeature <- function(st) {
        spart <- strsplit(st, " ")
        parts <- strsplit(spart[[1]][2],"-")
        parts[[1]][1]
}
## gets the subset of indices that include "mean" and "std deviation" data
getRelevantFeatures <- function() {
        f <- getFeatures() 
        
        filter(f, func == "mean()" | func == "std()")
}

## gets the index and friendly name of each activity from the activity_labels file
getActivityNames <- function() {
        r <- read.csv(".\\activity_labels.txt", header=FALSE, stringsAsFactors=FALSE)
        
        names(r)[1] <- "activity"
        
        indices <- sapply(r$activity, function(x) {strsplit(x, " ")[[1]][1]})
        descriptions <- sapply(r$activity, function(x) {strsplit(x, " ")[[1]][2]})
        
        data.frame(index=indices, activitydesc=descriptions, stringsAsFactors=FALSE)
}

## reads all data from a data set specified by a X, Y, and Subject files
## uses the friendly name of each activity
readDataSet <- function(features, activityNames, xFileName, yFileName, subjectFileName) {
           fCount <- nrow(features)
           
           ## read the y values from the specified y file name
           ys <- getY(yFileName)
           
           ## read the subject values from the specified subject file name
           subjects <- getSubject(subjectFileName)

           ## read in the x data file line by line
           con <- file(xFileName, open="r")
           lines <- readLines(con)
           len <- length(lines)
           
           ## preallocated vectors
           a <- numeric(len * fCount)
           s <- numeric(len * fCount)
           f <- character(len * fCount)
           v <- character(len * fCount)
           
           ## for each row in the file
           ## extract each feature (as defined by the features vector)
           ## and add a new row to our data frame for that feature value
           for (i in 1:len) {
                    
                   activity <- ys[i,]
                   subject <- subjects[i,]
                   currentLine <- lines[i]
                   
                   for (j in 1:fCount) {
                           feature <- features$fullname[j]
                           fIndex <- features$index[j]
                           start <- (fIndex-1)*16+1
                           stop <- (fIndex)*16
                           part <- substr(currentLine, start, stop)
                           
                           a[(i-1)*fCount+j] <- activity
                           s[(i-1)*fCount+j] <- subject
                           f[(i-1)*fCount+j] <- feature
                           v[(i-1)*fCount+j] <- part
                           
                   }
                   if (i %% 100 == 0) {
                        print(i)
                   }

           }
           close(con)
           
           ## create a combined data frame with the activity, subject, feature, value information
           retFrame <- data.frame(a, s, f, v)
           names(retFrame) <- c("activityindex", "subject", "feature", "value")
           
           ## merge in the friendly activity description
           ret <- merge(retFrame, activityNames, by.x="activityindex", by.y="index")
           
           ## return the result
           ret
           
}

## reads the test data set
readTestDataSet <- function(features, activityNames) {
        test <- readDataSet(features, activityNames, ".\\test\\X_test.txt", ".\\test\\Y_test.txt", ".\\test\\subject_test.txt")
        
        test
}

## reads the train data set
readTrainDataSet <- function(features, activityNames) {
        train <- readDataSet(features, activityNames, ".\\train\\X_train.txt", ".\\train\\Y_train.txt", ".\\train\\subject_train.txt")
        
        train
}

## returns the merge of the train and test data sets
getCombinedDataSet <- function() {
        aNames <- getActivityNames()
        fIndices <- getRelevantFeatures()

        ## read the train set
        train <- readTrainDataSet(fIndices, aNames)
        
        ## read the test set
        test <- readTestDataSet(fIndices, aNames)
        
        ## return the combined data set
        rbind(train, test)
}

## exports the combined data set to the specified file name
saveCombinedTidyDataSet <- function(outputFileName) {
        combinedSet <- getCombinedDataSet()
        
        subs <- select(combinedSet, subject, activitydesc, feature, value)
        
        subs$value <- str_trim(subs$value)
        
        saveDataSetCSV(outputFileName, subs)
}

## save the given data set to file name in CSV format
saveDataSetCSV <- function(fileName, dataSet) {
        ## delete the output file name if it already exists
        if (file.exists(fileName)) {
                file.remove(fileName)
        }
        
        write.csv(dataSet, file=fileName)   
}

## read in our tidy data set file
loadTidyDataSet <- function(fileName) {
        d <- read.csv(fileName)
}

## generate a grouped summary of our tidy data (grouped by feature, activity, subject)
getGroupedSummary <- function(tidyDataFileName) {
        d <- loadTidyDataSet(tidyDataFileName)
        
        g <- group_by(d, feature, activitydesc, subject)
        
        ret <- summarise(g, mean(value))
        
        ret
}

## generate our tidy data sets
generateTidyDataSets <- function() {
        tidyDataSetFile <- ".\\tidy-data.txt"
        groupedDataSetFile <- ".\\tidy-grouped-data.txt"
        
        saveCombinedTidyDataSet(tidyDataSetFile)
        
        g <- getGroupedSummary(tidyDataSetFile)
        
        saveDataSetCSV(groupedDataSetFile, g)
}
