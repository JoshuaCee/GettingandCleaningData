# GettingandCleaningData

## What this repository contains
* README.md : This file explains how run_analysis.R works.
* tidy_data.txt : This is the data set.
* CodeBook.txt : This is the code book that contains information about what the data are
* run_analysis.R : This is the R script used to generate tidy_data.txt

## How run_analysis.R works:
The script is broken down into 6 steps.  
### Step 1 
The dataset is downloaded and unzipped, if it is not present on your computer.

### Step 2
We gather the training data, using the data.table package for fast reading.  We combine the training set, activities, and the subject who performed those activities.  These are column bound.

### Step 3
Step 2 is repeated, but now for the testing set.

### Step 4
We now extract only the columns we are interested in (those that contain the mean or standard deviation).  This could have been done via the select command in dplyr, but we have chosen here to use the grep command.

### Step 5
We now give names to the activities column (which is called 'labels' in our data set).  This is done by using the labels in the activity_labels.txt file.

### Step 6
Some work is now performed to make the variable names more descriptive.

### Step 7
Finally, we use a few short dplyr commands to get the summaries we want.  This is then published.
