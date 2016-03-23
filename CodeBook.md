---
title: "CodeBook.md"
output: html_document
---

###Summary###

This code book describes the format of data in the tidy-data.txt and tidy-grouped-data.txt files

###Format of tidy-data.txt###

The tidy-data.txt file contains a tidy sub set of observations collected as part of the UCI Human Activity Recognition Using Smartphones Data Set. 

The fields of the data set are as follows:

Field Label: subject

* Variable Type: integer
* Notes: This field represents the id of the subject of the observation

Field Label: activitydesc

* Variable Type: character
* Allowable Values: "WALKING", "WALKING\_UPSTAIRS", "WALKING\_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"
* Notes: This field represents the friendly name of the activity being observed

Field Label: feature

* Variable Type: character
* Notes: This field represents the friendly name of the feature being observed

Field Label: value

* Variable Type: numeric
* Notes: This field represents the value of the observation


###Format of tidy-grouped-data.txt###

The tidy-data.txt file contains a tidy sub set of observations collected as part of the UCI Human Activity Recognition Using Smartphones Data Set. 

The fields of the data set are as follows:

Field Label: feature

* Variable Type: character
* Notes: This field represents the friendly name of the feature being observed

Field Label: activitydesc

* Variable Type: character
* Allowable Values: "WALKING", "WALKING\_UPSTAIRS", "WALKING\_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"
* Notes: This field represents the friendly name of the activity being observed

Field Label: subject

* Variable Type: integer
* Notes: This field represents the id of the subject of the observation

Field Label: mean(value)

* Variable Type: numeric
* Notes: This field represents the mean of all individual observations for the given feature, activity and subject


