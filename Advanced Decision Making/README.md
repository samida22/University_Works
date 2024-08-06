# Using Learning Analytics to Improve Student Performance: Predicting Weighted Scores Based on Engagement and Timeliness

## Abstract
This study investigates factors influencing students' weighted scores, focusing on engagement, timely assignment submission, and prior educational experience. The analysis finds that higher engagement and timely submissions correlate with better academic performance, with the Random Forest model demonstrating the highest predictive accuracy.

## Introduction
The project aims to use learning analytics to explore how various student factors, such as demographic information and engagement with course materials, affect their performance. The dataset includes demographic characteristics, academic background, engagement metrics, and final grades. Techniques like regression analysis and clustering are applied to predict performance and identify patterns.

## Data Set and Variables
The dataset, sourced from the Open University Learning Analytics repository, comprises several components:
Dataset link: https://archive.ics.uci.edu/ml/datasets/Open+University+Learning+Analytics+dataset. (analyse.kmi.open.ac.uk, n.d.)

Assessments: Course and assessment criteria.
Courses: Information about course offerings.
Student Assessment: Scores and submission details.
Student Information: Demographics and academic background.
Student Registration: Enrollment data.
Student VLE (Virtual Learning Environment): Interaction data.

## Data Pre-processing and Cleaning
Data preparation involved handling missing values, duplicates, and data format inconsistencies. Specific steps included:

Assessment Data: Addressed inconsistencies in assessment weights and IDs.
Student Assessments: Managed missing scores and inconsistent records.
Student Information and Registration: Reconciled discrepancies in student withdrawal data.
VLE Data: Processed interaction data, ensuring accurate counts of student engagement.

![image](https://github.com/user-attachments/assets/8efb967b-dd1b-4669-8987-9f702bf2adca)
  #### Fig (1.1): Assessments data set

![image](https://github.com/user-attachments/assets/14581bb5-b5c9-46ee-b40a-35b46faae9a1)
  #### Fig (1.2): Showing the NaN values in the score column.


![image](https://github.com/user-attachments/assets/5e755349-2c23-43a6-b727-81f0d43e104f)
  #### Table (1.1): Activity_level_score calculations

![image](https://github.com/user-attachments/assets/b696e725-6838-463e-b762-f5d98da3988b)
  #### Table (1.2): Weighted_score per module, per presentations and per student

![image](https://github.com/user-attachments/assets/851e6c78-25db-4b16-bb8b-683d9474dfb7)
  #### Fig (1.3): Final data after integration.


# Data Analysis and Exploration

## 1. Data Explorations (Exploratory Data Analysis):
Summary statistics, scatter plots, and correlation matrices were used to explore the relationships between variables. Normalization techniques, such as rank-based normalization, were applied to address skewed distributions and outliers. The Kolmogorov-Smirnov test was used to assess the normality of variables.
Normalization: Implemented rank-based normalization and KS-test to ensure normality of variables.
Correlation Analysis: Identified significant relationships between the dependent variable (weighted score) and independent variables like activity level and late submission rate.

![image](https://github.com/user-attachments/assets/524fd58e-5c7c-4fab-967a-4c15a1338570)
  #### Table (1.3): Summary statistics for train dataset
  

![image](https://github.com/user-attachments/assets/3f1cd5d6-3e9d-4171-a3b1-5b2cb5f18399)
   #### Fig (1.4): Scatter plot of dependent and independent variables.
   

![image](https://github.com/user-attachments/assets/8e40718d-a974-4c16-92b0-e94a42a74eec)
  #### Table (1.4): KS-test for normality check for variables
  


![image](https://github.com/user-attachments/assets/b4ca0d01-e65c-4b0f-a58c-c690559f62ed)
  #### Fig (1.5): correlation heatmap of every variable from dataset
  


![image](https://github.com/user-attachments/assets/a3ab77d1-ee6b-4b24-9168-d42f01a611c8)
  #### Fig (1.6): Correlation matrix of variables independent variable with dependent variable.
  

  

## 2. Hypothesis Definitions:
  The study hypothesized that the weighted score is influenced by factors such as activity level, prior educational experience, course module, studied credits, and late submission rates. These relationships were explored to predict the weighted score based on various combinations of independent variables.

## 3. Model Development and Evaluation:
Various regression models were developed and evaluated:

Multiple Linear Regression: Showed low accuracy and R-squared value, indicating limited suitability.
Random Forest Model: Demonstrated the highest accuracy (0.78) and R-squared value, making it the most effective model.
Ridge Regression: Addressed multicollinearity with moderate performance.
Lasso Regression: Similar to Ridge Regression but with lower precision.
Support Vector Machine (SVM): Provided a slightly lower MAE and RMSE than Ridge Regression, indicating better predictive capabilities.

![image](https://github.com/user-attachments/assets/a93feb1e-cb55-4610-a05a-1ebc018ffb40)
  #### Table (1.5): Metrics comparison of 5 different models.
  

## 4. Metric Analysis and Discussion:
The analysis revealed that student engagement and timely submissions significantly influence weighted scores. The Random Forest model outperformed other models, while the Linear Regression model was the least effective. The study highlights the importance of these factors in predicting academic performance, suggesting that targeted interventions could improve student outcomes.

## 5. Limitations:
The study faced limitations such as the inability to use the entire dataset due to computational constraints and the lack of advanced techniques like cross-validation and hyperparameter tuning, which could enhance model performance.

# Conclusion:
The study concludes that learning analytics can effectively identify key factors influencing student performance. The findings underscore the importance of student engagement and timeliness in achieving higher weighted scores. Educational institutions can leverage these insights to optimize teaching strategies and provide better support to students, ultimately enhancing academic achievement.

















