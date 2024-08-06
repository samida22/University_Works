#------------------------------eda again--------------------------------------------------#
# set the working directory to where the CSV file is located
setwd(dirname(file.choose()))
getwd()

#------------Libraries -----------------#
library(tidyverse)
library(lubridate)
library(dplyr)
library(ggplot2)
library(caret)
library(corrplot)
library(e1071)
library(ROCR)
library(rpart)
library(rpart.plot)
library(glmnet)
library(naniar)
#import data 
olad<- read.csv("Few_variablesData.csv")

names(olad)
library(naniar)
gg_miss_var(olad) + ggtitle("Missingness Map for My Dataset")
# count missing values in each column
sapply(olad, function(x) sum(is.na(x)))
# Convert columns to numeric
olad$late_rate <- as.numeric(olad$late_rate)
olad$studied_credits <- as.numeric(olad$studied_credits)
olad$activity_level_score <- as.numeric(olad$activity_level_score)
olad$sum_clicks <- as.numeric(olad$sum_clicks)

#convert columns to factor
olad$final_result <- factor(olad$final_result)
olad$highest_education <- factor(olad$highest_education)
names(olad)
#--------------------------------Normalizations ------------------------------------------#

# Assign numerical values using as.numeric()
olad$highest_education_numeric <- as.numeric(olad$highest_education)
olad$final_numeric <- as.numeric(olad$final)

class(olad$final_numeric)

# Apply rank-based normalization to the numeric variables
olad[, c("weighted_score", "late_rate", "studied_credits", "activity_level_score", "sum_clicks")] <- apply(olad[, c("weighted_score", "late_rate", "studied_credits", "activity_level_score", "sum_clicks")], 2, function(x) (rank(x)-1)/(length(x)-1))

# Create a boxplot of the weighted_score variable
boxplot(olad$weighted_score, main="Weighted Score Boxplot", ylab="Weighted Score")
hist(olad$weighted_score)
#----------------------------- Correlation analysis --------------------------------------------#


# correlations matrix will all variables 
# create correlation matrix
corr <- cor(olad[,c("weighted_score", "activity_level_score", "studied_credits", "late_rate", "highest_education_numeric", "sum_clicks")
])
#for few variables
# plot correlation matrix
corrplot(corr, method = "color", type = "upper", tl.col = "black", tl.srt = 45, addCoef.col = "black", diag = FALSE)
corr


cor_matrix <- cor(olad)

# plot a heatmap of the correlation matrix
library(ggplot2)
ggplot(data = reshape2::melt(cor_matrix)) +
  geom_tile(aes(x = Var1, y = Var2, fill = value)) +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  labs(title = "Correlation Matrix Heatmap")


#-----------------------------------Scatter plot -------------------------------------------------#
pairs(olad[, c("weighted_score", "activity_level_score", "studied_credits","sum_clicks", "highest_education_numeric", "late_rate")])

model_data<- olad
names(olad)
model_data<- select(model_data, -id_student)
model_data<- select(model_data, -final_result, -highest_education, -id_student, -final_numeric, -highest_education_numeric, -studied_credits)
head(model_data)
str(model_data)


#------------------------------------------ Building model-------------------------------------#

# Split the data into training and testing sets
set.seed(123) # Set the seed for reproducibility
trainIndex <- createDataPartition(model_data$weighted_score, p = 0.8, list = FALSE)
data.train <- model_data[trainIndex, ]
data.test <- model_data[-trainIndex, ]
fitControl <- trainControl(method="cv", number=10)

#-------------------------- 1. Multiple LINEAR REGRESSION -------------------------------------#

# Build the model
model.lm <- lm(weighted_score ~ late_rate + sum_clicks + activity_level_score + highest_education_numeric + studied_credits + final_numeric , data = data.train)
print(model.lm)
# Make predictions on the test set
predictions <- predict(model.lm, newdata = data.test)
print(predictions)
# Evaluate the model performance
RMSE <- sqrt(mean((data.test$weighted_score - predictions)^2))
R_squared <- summary(model.lm)$r.squared
# calculate MAE
MAE <- mean(abs(test$actual - predictions))
# Print the model performance metrics
cat("RMSE:", RMSE, "\n")
cat("R-squared:", R_squared, "\n")
cat("MAE:", round(MAE, 2), "\n")



#---------------------- 2. Random Forest --------------------------------#
#training the random forest model
# 10 fold Cross-validation

model.rf <- train(weighted_score ~ ., 
                  data = data.train,
                  method = "rf",
                  trControl = fitControl)
print(model.rf)

# Make predictions on the test set
predictions1 <- predict(model.rf, newdata = data.test)

#test the random forest
preds1 <- predict(model.rf, data.test)
class(preds1)
class(data.test$weighted_score)


# visualizing the predicted and actual values in R
ggplot(data = data.frame(predictions1, data.test$weighted_score), aes(x = preds1, y = data.test$weighted_score)) + 
  geom_point() + 
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Predicted vs Actual Weighted Score", x = "Predicted Score", y = "Actual Score")


# Convert predictions to factor type
preds1_factor <- ifelse(predictions1 > 0.5, "1", "0")
preds1_factor <- factor(preds1_factor, levels = c("0", "1"))

# Convert test data to factor type
test_factor <- ifelse(data.test$weighted_score > 0.5, "1", "0")
test_factor <- factor(test_factor, levels = c("0", "1"))

# Create confusion matrix
confusion_mtx <- confusionMatrix(preds1_factor, test_factor)


# Print precision, recall, and F1-score
precision <- confusion_mtx$byClass['Pos Pred Value']
recall <- confusion_mtx$byClass['Sensitivity']
f1_score <- 2 * ((precision * recall) / (precision + recall))
cat("Precision:", precision, "\n")
cat("Recall:", recall, "\n")
cat("F1-score:", f1_score, "\n")

#------------------------------  3. Ridge Regression ----------------------------------#

model.rr <- train(weighted_score ~ ., data = train, method = "ridge", trControl = fitControl)
print(model.rr)

# compute predictions using the ridge regression model
preds <- predict(model.rr, test)

# compute mean absolute error (MAE)
mae <- mean(abs(test$weighted_score - preds))
print(paste0("MAE: ", mae))

# compute root mean squared error (RMSE)
rmse <- sqrt(mean((test$weighted_score - preds)^2))
print(paste0("RMSE: ", rmse))

# compute R-squared (R2)
r2 <- 1 - sum((test$weighted_score - preds)^2) / sum((test$weighted_score - mean(test$weighted_score))^2)
print(paste0("R-squared (R2): ", r2))


#---------------------------  4. SVM ------------------------------------------#

model <- svm(weighted_score ~ ., data = train)

# Create the SVM regression model
svmModel <- svm(weighted_score ~ late_rate + studied_credits + activity_level_score + highest_education_numeric +final_numeric+ sum_clicks,
                data = trainData,
                kernel = "radial",
                cost = 10,
                gamma = 1)


# Make predictions on the testing set
predictions <- predict(svmModel, testData)

# Evaluate the model performance
RMSE <- sqrt(mean((predictions - testData$weighted_score)^2))

R_squared <- cor(predictions, testData$weighted_score)^2

# Print the model performance metrics
cat(paste("RMSE: ", RMSE, "\n"))
cat(paste("R-squared: ", R_squared, "\n"))

# Convert predictions to factor type
predictions_factor <- ifelse(predictions > 0.5, "1", "0")
predictions_factor <- factor(predictions_factor, levels = c("0", "1"))

# Convert test data to factor type
test_factor <- ifelse(testData$weighted_score > 0.5, "1", "0")
test_factor <- factor(test_factor, levels = c("0", "1"))

# Create confusion matrix
confusion_mtx <- confusionMatrix(predictions_factor, test_factor)


# Calculate precision, recall, and F1-score
precision <- confusion_mtx$byClass['Pos Pred Value']
recall <- confusion_mtx$byClass['Sensitivity']
f1_score <- 2 * ((precision * recall) / (precision + recall))


# Print precision, recall, and F1-score
cat("Precision:", precision, "\n")
cat("Recall:", recall, "\n")
cat("F1-score:", f1_score, "\n")



#-------------------------- 6.Lasso Regression   ------------------------------------------#

# fit the Lasso regression model using glmnet
model.lasso <- train(
  weighted_score ~ .,
  data = train,
  method = "glmnet",
  trControl = trainControl(method = "cv", number = 10),
  tuneGrid = expand.grid(alpha = 1, lambda = seq(0.01, 1, length = 100))
)
print(model.lasso)
# print the model coefficients
coef(model.lasso$finalModel, s = model.lasso$bestTune$lambda)

# make predictions on the test set
preds <- predict(model.lasso, newdata = test)

# compute performance metrics
mae <- mean(abs(test$weighted_score - preds))
rmse <- sqrt(mean((test$weighted_score - preds)^2))
r2 <- 1 - sum((test$weighted_score - preds)^2) / sum((test$weighted_score - mean(test$weighted_score))^2)

# print the performance metrics
cat("MAE:", mae, "\n")
cat("RMSE:", rmse, "\n")
cat("R-squared (R2):", r2, "\n")

#---------------------------------------End-----------------------------------------------------#






















