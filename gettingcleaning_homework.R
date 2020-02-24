######### GETTING AND CLEANING DATA - WK 4 HMWK ###########
# DATE: 2-20-2020 #
# NAME: MIRABAI #
# GOAL: USING ACTIVITY/EXERCISE DATA FROM 30 SUBJECTS, MERGE #
# CLEAN, AND SUMMARIZE THE DATA #.
##########################################################

#################### SET LIBRAIRIES ######################
library(tidyr)
library(dplyr)

################# Q1: CREATE A TIDY DATA SET ################
# OUTPUT FILE: data_tot #
#############################################################

############## 1a: READ IN TRAINING AND TEST SET ############
# Set Working Directory #
setwd("C:/Users/mirabai/Desktop/Data_Science/UCI HAR Dataset")


# Downloading File # 
exerciseurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
exercisefile <- ("Exercise_Data.zip")
download.file(exerciseurl, exercisefile, method="curl")
unzip(exercisefile)

# CHECK #
# Does file exist? what's inside?  You can see the files and subfolders  #
file.exists(exercisefile)
list.files("C:/Users/mirabai/Desktop/Data_Science/UCI HAR Dataset")


# Bringing in Files #
training_subject<- read.table(file = "train/subject_train.txt")
training_data   <- read.table(file = "train/X_train.txt")
training_labels <- read.table(file = "train/y_train.txt")
test_subject    <- read.table(file = "test/subject_test.txt")
test_data       <- read.table(file = "test/X_test.txt")
test_labels     <- read.table(file = "test/y_test.txt")
features        <- read.table(file = "features.txt")
activity_labels <- read.table(file = "activity_labels.txt" )

# File Notes #
# subjects - denote the subject in study; 1-30 individuals #
# data - data from gyroscope and accelerometer, broken into test/train #
# labels - flag what activity was happening (1-walking, 2-running etc) for training and test data #
# activity labels - 1 = "walking" 2 = "running" etc #
# features - variable names for the data, both train and test #

################# 1b: ADDING VARIABLE NAMES ###################

# Variable names to data files #
names(training_data)    <- features$V2
names(test_data)        <- features$V2

# Variable Names for exercise type in activity file #
names(training_labels)  <- "exercise"
names(test_labels)      <- "exercise"

# Variable name for the exercise labels file #
names(activity_labels)  <- c("exercise_num", "exercise_name")

# Variable name for participants #
names(training_subject) <- "participant"
names(test_subject)     <- "participant"

# CHECK #
# Do I see column names? Yes, sir. #
str(training_data)
str(test_data)
str(training_labels)
str(test_labels)
str(test_subject)
str(training_subject)
str(activity_labels)

########### 1c: MERGE TRAINING AND TEST DATA ##############

# First, append the test to the training data #
activity_tot    <- rbind(training_data, test_data)

# Second, append the training and test exercise column #
labels_tot      <- rbind(training_labels, test_labels)

# Third, append the training and test participant column #
participant_tot <- rbind(training_subject, test_subject)

# Putting it all together, merge the three test-train ingredients #
data_tot        <- cbind(participant_tot, activity_tot, labels_tot)

# CHECK #
# Do I see the correct columns and no of records? #
# Yes: 10299 obs. of  563 variables; which reflects what #
# the appended and merged totals should be. Woo hoo hoo  #
str(data_tot)


################# Q2: EXTRACT MEAN - ST DEV ##################
# OUTPUT FILE: data_subset_mean_sd #
##############################################################

# Define & Look at Column Names #
varnames = colnames(data_tot)


# Identify the fields of interest by searching for terms in variable names #
# Vars: activity data pared to mean, standard dev variables; participant; exercise #  
data_mean_sdev = (grepl("participant", varnames) | 
                  grepl("exercise",    varnames) | 
                  grepl("mean.." ,     varnames) | 
                  grepl("std.." ,      varnames))

# Create a subset, querying on those fields that meet the title requirements (="true") #
data_subset_mean_sd <- data_tot[ , data_mean_sdev == TRUE]

# CHECK #
# There are 563 vars overall; 81 in subset #
varnames
table(data_mean_sdev)
str(data_subset_mean_sd)


################# Q3: ADD IN EXERCISE LABELS #################
# OUTPUT: data_subset_mean_sd_labeled #
##############################################################

# Merge the core data set with the exercise name files #
data_subset_mean_sd_labeled <- merge(data_subset_mean_sd, activity_labels,
                                     by.x = "exercise",
                                     by.y = "exercise_num")

# CHECK #
# Did it work to append the names? Yes #
table(data_subset_mean_sd_labeled$exercise_name)

########### Q4: CREATE DESCRIPTIVE ACTIVITY NAMES #############
# OUTPUT FILE: data_tot #
###############################################################
# Note: I did this above in the Q1: The Merge section #


####### Q5: GENERATE A SUMMARY FILE BY PERSON, EXERCISE ########
# OUTPUT FILE: data_subset_mean_sd_labeled_agg #
################################################################

# New tidy set has to be created 
data_subset_mean_sd_labeled_agg <- aggregate(x= data_subset_mean_sd_labeled,
                                             by= list(data_subset_mean_sd_labeled$participant,
                                                      data_subset_mean_sd_labeled$exercise_name), 
                                             FUN = "mean")
# CHECK #
str(data_subset_mean_sd_labeled_agg)

# Remove Redundant Variables #
data_subset_mean_sd_labeled_agg2 <- select(data_subset_mean_sd_labeled_agg, -exercise_name, -Group.1)

# Rename Variables#
data_subset_mean_sd_labeled_agg3 <- rename(data_subset_mean_sd_labeled_agg2, exercise_name = Group.2)



######################### SAVE OUTFILE  #######################
# OUTPUT FILE: 
###############################################################
write.table(data_subset_mean_sd_labeled_agg3, file = "tidy_exercise_data_summary.txt", row.name=FALSE)


