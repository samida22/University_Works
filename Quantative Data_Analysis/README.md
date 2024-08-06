Abstract

The analysis uses R and various statistical packages to explore relationships between socio-economic variables and COVID-19 death rates. The study focuses on demographic factors like age, gender, and activity levels, seeking to understand how these variables correlate with COVID-19 mortality.

Introduction

The dataset contains information on COVID-19 deaths, and the goal is to explore relationships among various factors through exploratory data analysis (EDA). The study employs statistical methods, including linear and multiple regressions, and hypothesis testing techniques like t-tests, Chi-squared tests, and ANOVA.


Data Set and Variables

Age Groups: Includes categories such as Children, Young, Adults, and Pensioners.
Gender: Data split by male and female populations.
Activity Levels: Categorized as "limited a lot," "limited little," and "not limited."
Dependent Variable: Total COVID-19 deaths.

Independent Variables: Age, gender, and activity levels, with the specific breakdowns provided above.


![image](https://github.com/user-attachments/assets/b0a24bfd-0f8f-4a2d-8875-5d1399dae7b3)




Data Pre-processing and Cleaning

The data underwent an essential cleaning process to ensure consistency and accuracy:

Data Merging: Multiple datasets were joined based on geographic codes and other relevant identifiers. The merging process was handled using SQLite, an efficient database management tool. This step was crucial because the data from different sources did not initially align perfectly in terms of geography codes and the number of rows.

Data Cleaning: Post-joining, the dataset was scrutinized for missing values, inconsistencies, and discrepancies. The data was generally clean, with no missing values reported. The cleaned dataset was then exported as a new CSV file for further analysis.


![image](https://github.com/user-attachments/assets/20066614-eb4a-4e34-ac28-6a72b2c12b93)




Data Analysis in R

Normality Checks

Graphical Methods: Used histograms and Q-Q plots to visually assess the normality of the distribution of variables.
Statistical Tests: Employed the Kolmogorov-Smirnov test to statistically verify normality, particularly for the dependent variable (Total COVID-19 deaths).
Handling Outliers: Detected outliers using boxplots. For normalization, log transformations were applied where necessary to stabilize variance and make the data more normally distributed.

Significance Testing: Conducted hypothesis testing to determine if the data distributions could be considered normal. The null hypothesis, suggesting normal distribution, was not rejected based on the p-values from the Kolmogorov-Smirnov test.

Analysis

Correlation analysis with pearson method

![image](https://github.com/user-attachments/assets/5ade23d6-c328-40ea-9f45-d00f5a0b7369)


![image](https://github.com/user-attachments/assets/4e0f7a31-96be-419c-8995-27ac9dad810d)


Correlation analysis Using Spearman’s method

![image](https://github.com/user-attachments/assets/4cc7e634-e227-4c22-aea8-2e1d205e22a1)



Age Groups: Children, Young, Adults, Pensioners: Explored the correlation between these age groups and COVID-19 deaths. Weak or negative correlations were found, suggesting no strong statistical relationship with the dependent variable.

Gender: Analyzed the correlation between gender (male and female populations) and COVID-19 death rates. There were some notable correlations, indicating potential gender-related differences in COVID-19 mortality.

Activity Levels: Significant correlations were identified between activity levels and COVID-19 deaths:

Limited a lot: Positive correlation with COVID-19 deaths, indicating higher mortality among those with severely limited activities.

Not limited: Negative correlation, indicating lower mortality among more active individuals.

Multivariate Analysis

A subset analysis focused on activity levels was performed to explore the relationships between these variables using both Pearson and Spearman correlation methods. The results confirmed the earlier findings, showing a significant negative correlation between active lifestyles and COVID-19 deaths, and a positive correlation between limited activity and increased mortality.


Conclusions

The analysis highlighted key factors associated with COVID-19 mortality. Particularly, limited day-to-day activities emerged as a significant predictor of higher COVID-19 death rates, possibly reflecting underlying health conditions or socio-economic factors. This insight can guide public health interventions and policies aimed at mitigating the impact of pandemics on vulnerable populations.
