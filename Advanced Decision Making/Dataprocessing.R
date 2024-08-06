# set the working directory to where the CSV file is located
setwd(dirname(file.choose()))
getwd()

# -------------------------------load library----------------------------#
library(dplyr)


















#------------ load the data sets to to data Preprocessing -----------------#

# load the CSV file using the read.csv() function
assesments <- read.csv("assessments.csv")
course <- read.csv("courses.csv")
std_asses <- read.csv("studentAssessment.csv")
std_info <- read.csv("studentInfo.csv")
std_regs <- read.csv("studentRegistration.csv")
std_Vle <- read.csv("studentVle.csv")
Vle <- read.csv("vle.csv")
# view the first few rows of the data to ensure it was loaded correctly
head(assesments)

# check for missing values using is.na() function
missing_values <- is.na(assesments)

# count the number of missing values in each column  and display missing values
col_missing <- colSums(missing_values)
col_missing[col_missing > 0]

# see the informations
str(assesments)
# convert id_assessment column to categorical 
assesments$id_assessment <- as.factor(assesments$id_assessment)
std_asses$id_assessment <- as.factor(std_asses$id_assessment)


#checking the weights of CMA, TMA and Exam 
filtered_data_CMA <- assesments %>% filter(assessment_type == "CMA")
filtered_data_CMA
filtered_data_TMA <- assesments %>% filter(assessment_type == "TMA")
filtered_data_TMA
filtered_data_Exam <- assesments %>% filter(assessment_type == "Exam")
filtered_data_Exam


# grouping the data by code_module and code_presentation
#and summarizing the weight column by summing it
grouped_data <- assesments %>% 
  group_by(code_module, code_presentation) %>% 
  summarize(total_weight = sum(weight))

#  for exam only calculate and group by
# select rows where assessment_type is "Exam", 
#group by code_module and code_presentation, 
#and summarize the weight column by summing it
grouped_data_exam <- assesments %>% 
  filter(assessment_type == "Exam") %>%
  group_by(code_module, code_presentation) %>% 
  summarize(total_weight = sum(weight))

# we saw that CCC has  2 exams from the group_data1 table
#for assesments only group by and aggregate
grouped_data_Ass <- assesments %>% 
  filter(assessment_type != "Exam") %>%
  group_by(code_module, code_presentation) %>% 
  summarize(total_weight = sum(weight))

grouped_data_Ass
# we saw GGG has 0 weights this explains this does not have any assignments
############## Again reorganizing to see from different perspectives ##########

grouped_data_GGG <- assesments %>% 
  filter(code_module == "GGG") %>%
  group_by(code_module, code_presentation, assessment_type) %>% 
  summarize(weight_by_type = sum(weight))
# values from this table shows that there is no assessments weights only exam weights are present
grouped_data_GGG

# filter the data to select only rows where the assessment_type is CMA or TMA and the weight is 0
#also exclude GGG as we know the result
filtered_data_CandT <- assesments %>% filter(assessment_type %in% c("CMA", "TMA"), weight == 0, code_module != "GGG")


##### To find the total number of assignment in GGG module
# filter the data to select only rows where the code_module is GGG
filtered_data_GGG <- assesments %>% filter(code_module == "GGG")

# group the data by code_module, code_presentation, assessment_type, and id_assessment, and count the number of occurrences of each id_assessment
grouped_data <- filtered_data_GGG %>% group_by(code_module, code_presentation, assessment_type, id_assessment) %>% summarize(count = n())

# count the total number of assignments in the GGG module by id_assessment
Count_GGG_assig <- grouped_data %>% group_by(id_assessment, code_module, code_presentation, assessment_type) %>% summarize(total = sum(count))
count_GG_ass_asstype <- Count_GGG_assig %>% group_by(assessment_type)
# view the total assignments
Count_GGG_assig


# --------------assigning the weight to TMA and CMA and GGG module-------------------#
assesments$weight[(assesments$code_module == 'GGG') & (assesments$assessment_type == 'TMA')] <- (100/3)
assesments$weight[(assesments$code_module == 'GGG') & (assesments$assessment_type == 'CMA')] <- (0)
assesments

#Checking for TMA assignment sums up to 100
assesments %>% 
  filter(code_module == "GGG") %>% 
  group_by(code_module, code_presentation, assessment_type) %>% 
  summarise(weight_by_type = sum(weight))


#checking that all assessments sums up to 200
assesments %>% 
  filter(code_module == "GGG") %>% 
  group_by(code_module, code_presentation) %>% 
  summarise(weight_by_type = sum(weight))

#-------------Check if Assessments information are  in Student Assessments table---------------#

# Subset the data and extract the "weight" column
column_CMA <- assesments[assesments$assessment_type == "CMA" & assesments$code_module != "GGG", "weight"]

counts <- table(column_CMA)
result_CMA <- as.data.frame(counts)
colnames(result_CMA) <- c("Weight", "Count")
result_CMA

column_TMA <- assesments[(assesments$assessment_type == "TMA") & (assesments$code_module != "GGG"), "weight"]
column_TMA

counts <- table(column_TMA)
result_TMA <- as.data.frame(counts)
colnames(result_TMA) <- c("Weight", "Count")
result_TMA

# From here we are going to calculate the shared value between
#two dataframe with the same column name


Comp_columns <- function(df1, df2) {
  # Get the names of the columns in each dataframe
  df1Columns <- colnames(df1)
  df2Columns <- colnames(df2)
  
  # Find the columns that are shared between the two dataframes
  diffList <- intersect(df1Columns, df2Columns)
  cat("Shared columns: ", diffList, "\n")
  
  # Check if the values in the shared columns match
  for(col in diffList) {
    x <- table(df1[,col] %in% df2[,col])
    cat("Check if values are present in both dataframes for column ", col, ":\n")
    print(x)
    cat("\n")
  }
}
# find the values present in one dataframe and not present not in the other

find_diff_values <- function(df1, df2, col) {
  # Find all unique values of col in df1 and df2
  df1_IDs <- unique(df1[[col]])
  df2_IDs <- unique(df2[[col]])
  
  # Find values in df1 that are not in df2
  diff <- setdiff(df1_IDs, df2_IDs)
  
  # Count how many are different
  numberDiff <- length(diff)
  
  # Print the results
  cat(paste("Values from df1 not in df2: ", toString(diff), "\n"))
  cat(paste("Number of missing values: ", numberDiff, "\n"))
}

# print values not ptrsent in second columns

print_diff_values <- function(df1, df2, col) {
  # Pull out all unique values of col
  df1_IDs <- unique(df1[[col]])
  df2_IDs <- unique(df2[[col]])
  
  # Compare the two lists
  # (a) Find what values are different
  diff <- setdiff(df1_IDs, df2_IDs)
  
  # Show information for all df1.col values not present in df2.col
  # (a) Make a list of missing values
  missingList <- as.list(diff)
  # (b) Find these IDs in df2
  missingDf <- df1[df1[[col]] %in% missingList,]
  
  return(missingDf)
}



Comp_columns(assesments, std_asses)
find_diff_values(assesments, std_asses, "id_assessment")
print_diff_values(assesments, std_asses, 'id_assessment')

# now we need to calculate which student ids are missing with the id_assessment missing we got 

# List of ids missing
missing_Lists <- c(30723, 1763, 34885, 15014, 37444, 14990, 30713, 37424, 15025, 34898, 37434, 40087, 34872, 40088, 15002, 1757, 30718, 34911)

# From assessments table find all the rows with weight 100
weight_with100 <- assesments[assesments$weight == 100, ]
# Get all unique assessment IDs
List_weight_with100 <- unique(weight_with100$id_assessment)

# Compare this list with the list of all assessment IDs missing from student assessment table
compare_value <- setdiff(List_weight_with100, missing_Lists)
number_Compare <- length(compare_value)

cat("100 weighted assessments in the student assessment able (that are not missing exams): ", compare_value, "\n")
cat("Number of 100 weighted assessments (that are not missing exams) in the studen assessment table: ", number_Compare, "\n")
# (a) Make a list of IDs to look 
matched_list <- c(24290, 25354, 24299, 25361, 25368, 25340)

# (b) Find these IDs in the Assessments table
matched_Df <- assesments[assesments$id_assessment %in% matched_list, ]
matched_Df

#This statement implies that it is not possible to conclude 
#that all final exams are absent from the results table based 
#on the analysis conducted above. It is only evident that certain exams are missing from the table.

##################################################################################


# STUDENT ASSESSMENT INFORMATIONS.
str(std_asses)

# convert id_assessment column to factors using as.factor() function
std_asses$id_assessment <- as.factor(std_asses$id_assessment)
std_asses$id_student <- as.factor(std_asses$id_student)

std_asses[is.na(std_asses$score),]
std_asses$score[is.na(std_asses$score)] <- 0
head(std_asses)

###############################################################################################

#STUDENT REGISTRATION TABLES
#We need to check if all the students id are in student result tables 
Comp_columns(std_regs, std_asses)
# 5847 students are missing

# we need to check if any student information  are missing from student assessment tables
Comp_columns(std_info, std_asses)
# 5847 students are also missing from student assessments tables too

# we need to check if these are same students

#calculate all the unique value
# Pull out all unique values id_assessments
id_regs <- unique(std_regs$id_student)
id_info <- unique(std_info$id_student)

# Compare the two lists
# (a) Find what assessment IDs are different
diff <- setdiff(id_regs, id_info)
# (b) Count how many are different
numberDiff <- length(diff)

numberDiff

# we found there are no same ids
Comp_columns(std_regs, std_info)

# these are same students

#checking student information not present in student assessments table

not_in_stdAss = print_diff_values(std_info, std_asses, 'id_student')
head(not_in_stdAss)

# What are their final results?
column <- not_in_stdAss$final_result

result_counts <- table(column)

result_counts

# we have got 2 students passed even though they are not recorded
#in student final assessment tables and student information table

# checking student registration not present in student assessments table
not_in_stdAss_from_StdReg = print_diff_values(std_regs, std_asses, 'id_student')
head(not_in_stdAss_from_StdReg)

#4594 students have unregistered
sum(!is.na(not_in_stdAss_from_StdReg$date_unregistration))

#calculating the 2 pass students date_unregistration status
# Show rows with passes
#take the columns with pass and pass it through not_instdAss list to get the 2 student ids
not_in_stdAss[not_in_stdAss$final_result == 'Pass', ]

#Then check indivisually those ids unregistration date 
not_in_stdAss_from_StdReg[not_in_stdAss_from_StdReg$id_student=='1336190',]
not_in_stdAss_from_StdReg[not_in_stdAss_from_StdReg$id_student=='1777834',]

#Result 1336190 and 1777834 both don't have date unregistration and 1777834 has no date registration too.
#It might be clerical error



#--------------------------VIRTUAL LEARNING ENVIRONMENT RESOURCES----------------------------#
#VLE RESOURCES


Vle_nunique <- sapply(Vle, function(x) n_distinct(x, na.rm = TRUE))
Vle_nunique
str(Vle)

Vle$id_site<- as.factor(Vle$id_site)
std_Vle$id_site<- as.factor(std_Vle$id_site)
std_Vle$id_student<- as.factor(std_Vle$id_student)
std_info$id_student<- as.factor(std_info$id_student)

#-----------------------   preparing tables integration    -------------------------------#
#FROM HERE WE ARE GOING TO TEST HYPOTHESIS 
#FOR THIS WE NEED TO PREPARE DATA AND JOIN VARIOUS TABLES


#There is a correlation between the activity 
#level of students (such as time spent on learning activities, 
#number of activities completed, etc.) and their final assessment scores.

#unique_activities <- unique(Vle$activity_type)
#unique_activities


#CHECKING IF activity_type present in studentVle from Vle table
Comp_columns(Vle, std_Vle)
diff_value_data<-print_diff_values(Vle, std_Vle, 'id_site')
# Inner join Vle and stdVle tables on id_site
ac_data <- inner_join(std_Vle, Vle, by = "id_site") %>%
  select(id_site, code_module.x, code_presentation.x, id_student, activity_type, date, sum_click)
head(ac_data)

# define the weightage for each activity type
activity_weights <- c(resource = 0.2,
                     oucontent = 0.3,
                     url = 0.1,
                     homepage = 0.1,
                     subpage = 0.1,
                     glossary = 0.1,
                     forumng = 0.1,
                     oucollaborate = 0.05,
                     dataplus = 0.05,
                     quiz = 0.2,
                     ouelluminate = 0.05,
                     sharedsubpage = 0.05,
                     questionnaire = 0.05,
                     page = 0.05,
                     externalquiz = 0.1,
                     ouwiki = 0.05,
                     dualpane = 0.05,
                     repeatactivity = 0.05,
                     folder = 0.05,
                     htmlactivity = 0.05)

#best way to calculate the activity_level
activity_level_data <- ac_data %>%
  group_by(code_module.x, code_presentation.x, id_student, activity_type) %>%
  summarize(sum_clicks = sum(sum_click)) %>%
  mutate(weight = activity_weights[activity_type]) %>%
  group_by(code_module.x, code_presentation.x, id_student) %>%
  summarize(activity_level_score = sum(sum_clicks * weight) / sum(weight),
            sum_clicks = sum(sum_clicks))
head(activity_level_data)
#Data integrations steps
#joining student registration student informations and courses tables together

Comp_columns(std_regs, course)

#join student registration and course table with inner join
std_reg_Andcourse <- inner_join(std_regs, course, by = c("code_module", "code_presentation"))

# view the resulting table

std_reg_Andcourse$id_student<- as.factor(std_reg_Andcourse$id_student)
#join the above table with student_info table
std_reg_Andcourse_Info <- inner_join(std_reg_Andcourse, std_info, by = c("code_module", "code_presentation", 'id_student'))

#now join Assessment table and student assessment result tables
Ass_StdAssResult<- inner_join(assesments, std_asses, by = c('id_assessment'))


# --------------------- calculating weighted score for final score---------------------#

# Make a copy of dataset
New_score_ass <- Ass_StdAssResult

# Count how many exams there are in Results for every module presentation
New_score_ass[New_score_ass$assessment_type == 'Exam', c('code_module', 'code_presentation', 'id_assessment')] %>%
  group_by(code_module, code_presentation) %>%
  summarise(n_exams = n_distinct(id_assessment))

str(New_score_ass)
New_score_ass$score <- as.integer(New_score_ass$score)


#helper columns
#  create acolumn by multiplying score and weight.
New_score_ass <- New_score_ass %>% mutate(weight_score = weight * score)

# Aggregate recorded weight*score per student per module presentation
sum_scores <- New_score_ass %>%
  group_by(id_student, code_module, code_presentation) %>%
  summarise(weightByScore = sum(weight_score)) %>%
  ungroup()

# Calculate total recorded weight of module
# Get total weight of modules
total_weight <- assesments %>%
  group_by(code_module, code_presentation) %>%
  summarise(total_weight = sum(weight)) %>%
  ungroup()

#  Subtract 100 to account for missing exams
total_weight$total_weight <- total_weight$total_weight - 100

#  Mark module DDD as having 200 credits 
total_weight$total_weight[total_weight$code_module == 'DDD'] <- 200

#-----------------Calculate weighted score--------------------#
#Merge sum_scores and total_weight tables
score_weights <- inner_join(sum_scores, total_weight, by = c("code_module", "code_presentation"))

# (b) Calculate weighted score
score_weights$weighted_score <- score_weights$weightByScore / score_weights$total_weight

# (c) Drop helper columns
score_weights <- score_weights %>% select(-c(weightByScore, total_weight))

head(score_weights)

#################################     calculation of late submission     ####################################

str(Ass_StdAssResult)
names(Ass_StdAssResult)
#need to convert char to integer for date column
Ass_StdAssResult$date <- as.integer(Ass_StdAssResult$date)
# Calculate the difference between the submission dates
late-Submission <- Ass_StdAssResult %>%
  mutate(submission_days = date_submitted - date)

# Make a column indicating if the submission was late or not 
lateSubmission <- lateSubmission %>%
  mutate(late_submission = submission_days > 0)

head(lateSubmission)

#late submission for exams 
lateSubmission[lateSubmission$assessment_type == 'Exam' & lateSubmission$late_submission == TRUE, ]

#----------------- per student per module presentation-------------------#
total_late_per_student <- lateSubmission %>%
  group_by(id_student, code_module, code_presentation) %>%
  summarize(total_late_submission = sum(late_submission))

# late submission per assessment per module per code presentation

lateSubmission <- lateSubmission %>%
  group_by(id_student, code_module, code_presentation, id_assessment) %>%
  summarise(total_late_submission = sum(late_submission))

total_count_assessments <- lateSubmission %>%
  group_by(id_student, code_module, code_presentation) %>%
  summarize(total_assessments = n()) %>%
  ungroup()
head(total_count_assessments)
# data merging

late_rate_per_student <- merge(total_late_per_student, total_count_assessments,
                               by=c('id_student', 'code_module', 'code_presentation'), all=TRUE)
late_rate_per_student$late_rate <- late_rate_per_student$total_late_submission / late_rate_per_student$total_assessments

late_rate_per_student <- late_rate_per_student[, !(names(late_rate_per_student) %in% c("total_late_submission", "total_assessments"))]
head(late_rate_per_student)


# pass fail rate calculations

passRate <- Ass_StdAssResult %>% mutate(fail = score < 40)


#aggregate per student per module

total_fails_per_student <- passRate %>%
  group_by(id_student, code_module, code_presentation) %>%
  summarize(total_fails = sum(fail, na.rm = TRUE)) %>%
  ungroup()

# Merge df with total fails and total count assessments
fail_rate_per_student <- merge(total_fails_per_student, total_count_assessments, by=c('id_student', 'code_module', 'code_presentation'))
# Make a new column with late submission rate
fail_rate_per_student$fail_rate <- fail_rate_per_student$total_fails / fail_rate_per_student$total_assessments
# Drop helper columns
fail_rate_per_student <- fail_rate_per_student[, !names(fail_rate_per_student) %in% c('total_fails', 'total_assessments')]


######### Merge all the above tables Ass_StdAssResult, weighted_score, late_submission_rate and fail_rate  #####


# Merge score_weights and late_rate_per_student data frames
Asses <- merge(score_weights, late_rate_per_student, by=c("id_student", "code_module", "code_presentation"))

# Merge fail_rate_per_student data frame with the above merged data frame
Asses <- merge(Asses, fail_rate_per_student, by=c("id_student", "code_module", "code_presentation"))

#Merge all the tables 
common_cols <- intersect(names(std_reg_Andcourse_Info), names(activity_level_data))
common_cols
final_merged_file1 <- merge(std_reg_Andcourse_Info, activity_level_data, by = c("id_student", "code_module", "code_presentation"), all.x = TRUE)
head(final_merged_file1)
final_merged_file2 <- merge(Asses, final_merged_file1, by = c("id_student", "code_module", "code_presentation"), all.x = TRUE)
head(final_merged_file2)
write.csv(final_merged_file2, file = "sampletable.csv", row.names = TRUE)


#------------------------ whole datasets -------------------------------#

Whole_final_data<- final_merged_file2
head(Whole_final_data)

#check for null values
sapply(Whole_final_data, function(x) sum(is.na(x)))

Whole_final_data$date_registration <- replace(Whole_final_data$date_registration, Whole_final_data$date_registration == "?", NA)
Whole_final_data$date_unregistration <- replace(Whole_final_data$date_unregistration, Whole_final_data$date_unregistration == "?", NA)
Whole_final_data$imd_band<- replace(Whole_final_data$imd_band,Whole_final_data$imd_band =="?", NA)


#data cleanings for further quality

sapply(train, function(x) sum(is.na(x)))
#sum_click, activity_level_score, weighted_score, late_rate,imb_band, date_registration, date_unregistration These have null values need to remove


#forimb_band
#find out the most frequent imb_band
# Find what is the most frequent band in each region
# Find the most frequent band in each region without missing values
regions_list <- unique(Whole_final_data$region)

for (i in regions_list) {
  result <- table(Whole_final_data[Whole_final_data$region == i & !is.na(Whole_final_data$imd_band), "imd_band"])
  max_band <- names(result[result == max(result)])
  print(paste(i, "IMD band: ", max_band))
}

# Replace all null values with respective most frequent imd_bands
regions_list <- unique(Whole_final_data[Whole_final_data$imd_band == "" | is.na(Whole_final_data$imd_band),]$region)
regions_list
for (i in regions_list) {
  mode_band <- names(which.max(table(Whole_final_data$imd_band[Whole_final_data$region == i])))
  Whole_final_data$imd_band[Whole_final_data$imd_band == "" & Whole_final_data$region == i] <- mode_band
  Whole_final_data$imd_band[is.na(Whole_final_data$imd_band) & Whole_final_data$region == i] <- mode_band
}
#checking null values in imb_band
sapply(train, function(x) sum(is.na(x)))

###########################################################################################################################################

# Make a new dataframe just with rows that have null values for the registration date
reg_date_nulls_in_reg <- Whole_final_data[Whole_final_data$date_registration %in% c("", "NA", "NULL"),]
reg_date_nulls_in_reg

# What are their final results?
column <- reg_date_nulls_in_reg$final_result

counts <- table(column)

counts
str(Whole_final_data$date_registration)
#chnage into numeric
Whole_final_data$date_registration <- as.integer(Whole_final_data$date_registration)
Whole_final_data$date_unregistration <- as.integer(Whole_final_data$date_unregistration)
median(Whole_final_data$date_registration, na.rm=TRUE)

# Replace NaN values with date_unreg minus the median (note, the median is negative)
Whole_final_data$date_registration <- ifelse(is.na(Whole_final_data$date_registration),
                                             Whole_final_data$date_unregistration + median(Whole_final_data$date_registration, na.rm = TRUE),
                                             Whole_final_data$date_registration)

# Replace remaining NaNs with -57
Whole_final_data$date_registration <- ifelse(is.na(Whole_final_data$date_registration),
                                  median(Whole_final_data$date_registration, na.rm = TRUE),
                                  Whole_final_data$date_registration)

###################### For sum_click ##########################
#replace with NaN value
Whole_final_data$sum_clicks[is.na(Whole_final_data$sum_clicks)] <- 0
Whole_final_data$weighted_score[is.na(Whole_final_data$weighted_score)] <- 0
Whole_final_data$late_rate[is.na(Whole_final_data$late_rate)] <- 0
Whole_final_data$fail_rate[is.na(Whole_final_data$fail_rate)] <- 0

##### For activity_level_score

# calculate the mean of the column
mean_val <- mean(Whole_final_data$activity_level_score, na.rm = TRUE)

# replace NaN values with the mean value
Whole_final_data$activity_level_score <- ifelse(is.na(Whole_final_data$activity_level_score), mean_val, Whole_final_data$activity_level_score)

########## For date_unregistrations

# calculate the mean of the column
mean_val_unreg <- mean(Whole_final_data$date_unregistration, na.rm = TRUE)

# replace NaN values with the mean value
Whole_final_data$date_unregistration <- ifelse(is.na(Whole_final_data$date_unregistration), mean_val_unreg, Whole_final_data$date_unregistration)

#checking null values in every columns
sapply(Whole_final_data, function(x) sum(is.na(x)))
write.csv(Whole_final_data, file = "Final_OLAD_dataset.csv", row.names = TRUE)








