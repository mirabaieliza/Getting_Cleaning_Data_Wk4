#######################################################################
COURSE: Getting and Cleaning Data: Week 4 Homework Assignment
PROJECT: Summarizing a Human Activity Recognition Using Smartphones Dataset
DATE: 2-20-2020 
NAME: Mirabai 
#######################################################################

#### BACKGROUND ####
Data was collected on 30 participants movement using an
accelerometer and gyroscope while they were doing various
exercises and movements, such as walking, sitting, and going up stairs.
The data was split into several files: test and train datasets, 
participant IDs, and exercise labels.

#### GOAL ####
Using the data sources, merge and tidy the files to create a 
clean, integrated dataset.  From this set, select a subset of relevant 
variables -- and create a summary of particpants exercise behaviors for
these measures.

#### STEPS #####

# CLEAN AND MERGE THE DATA
Import libraries; set working directory; download file and read in tables
Append feature names 
Append files training and test verions of the data, labels, participant info
Merge the three pieces together

# EXTRACT VARIABLES OF INTEREST
Define & Look at Column Names #
Identify the fields of interest by searching for terms in variable names #
Flag mean, standard dev variables; participant; exercise #  
Create a subset, querying on those fields that meet the title requirements (="true") #

# ADD IN EXERCISE NAME LABELS 
Merge the core data set with the exercise name files #

# CREATE DESCRIPTIVE ACTIVITY NAMES
I did this in the initial step, see "Clean and Merge Data"

# GENERATE A SUMMARY FILE BY PERSON, EXERCISE
Aggregate subset file by person and exercise.
Remove extraneous columns; rename vars  

# SAVE OUTFILE
write.table(data_subset_mean_sd_labeled_agg3, file = "tidy_exercise_data_summary.txt", row.name=FALSE)


