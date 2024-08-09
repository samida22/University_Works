# Project Title:  A Comparative Study of Genetic Algorithm-Based Ensemble Techniques for Vertebral Column Disorder Diagnosis.
Author:
Samidha Neupane

Date:
01/09/2023

## Project Overview
This project explores the application of machine learning, specifically ensemble techniques, for diagnosing vertebral column disorders such as disc hernia and spondylolisthesis. 
These disorders are significant contributors to lower-back pain, which affects a large proportion of the population and imposes substantial healthcare costs.


## Objective
The primary objective of this research was to enhance the accuracy of vertebral column disorder diagnosis by optimizing ensemble learning models using genetic algorithms.
By comparing various ensemble techniques, this study aimed to determine the most effective approach for classifying disorders based on biomechanical parameters.

## Dataset
The study utilized the Vertebral Column dataset from the UCI Machine Learning Repository.
This dataset includes six biomechanical parameters related to the pelvic and lumbar spine alignment, and it contains 310 samples categorized into three classes: disc hernia (DH), normal (NO), and spondylolisthesis (SL).

# Methodology
## Data Preprocessing
The dataset, derived from UCI's vertebral column dataset, included six biomechanical features crucial for diagnosing vertebral disorders. Initial preprocessing involved converting the ARFF file to CSV format and handling missing data and outliers to ensure model training consistency.
Feature scaling was also applied to standardize the dataset, given the variance in measurements like pelvic incidence and lumbar lordosis angle.

![image](https://github.com/user-attachments/assets/e13f2170-2145-4780-9397-9b2536c6573c)
 #### Figure: Missing values visualisations



![image](https://github.com/user-attachments/assets/019604dc-2ac9-429d-955b-9915f5848bde)
#### Figure: Class Imbalance problem in the dataset



![image](https://github.com/user-attachments/assets/339e5d99-29ab-4136-82a9-93265b5b6d56)
#### Figure: SMOTE-Tomek class imbalance technique



![image](https://github.com/user-attachments/assets/e2f32337-f5c3-4819-942f-c3e44800cda8)
#### Figure: SHAP value (impact on model output) based on Random Forest.


![image](https://github.com/user-attachments/assets/556e1245-0141-4d92-a4e9-b810f1aca85a)
#### Figure: Feature importance using catboostclassifier.




## Model Selection
A wide array of machine learning algorithms was explored, starting with basic classifiers such as Logistic Regression, Naive Bayes, K-Nearest Neighbors (KNN), and Support Vector Machines (SVM). The aim was to identify a model capable of effectively diagnosing vertebral column disorders by analyzing biomechanical data.

Logistic Regression was selected for its simplicity and effectiveness in binary classification tasks, particularly in medical diagnostics where the goal was to predict conditions such as disc hernia or spondylolisthesis.

Naive Bayes was chosen for its probabilistic approach, which, despite its assumption of feature independence, offered solid classification results.

K-Nearest Neighbors (KNN) was leveraged due to its ability to capture complex patterns based on proximity, which is essential for distinguishing between different types of vertebral disorders.

Support Vector Machines (SVM) were included due to their robustness in handling high-dimensional data and complex, non-linear relationships, making them particularly suitable for this medical dataset..

## Ensemble Techniques
To enhance predictive performance, ensemble techniques like Bagging, AdaBoost, and Stacking were implemented. These methods were selected for their ability to combine multiple models to reduce variance and improve overall accuracy.

Bagging was utilized with Decision Trees and SVM as base learners, leading to substantial performance improvements, particularly when optimized using Genetic Algorithms.

AdaBoost was used to focus on difficult-to-classify instances by assigning higher weights, which improved the model's sensitivity to minority classes.

Stacking involved combining multiple base learners (e.g., Random Forest, Decision Tree) with a meta-classifier, which significantly improved diagnostic accuracy, as demonstrated by the performance metrics obtained during validation.

## Optimization
To further refine the model's performance, Genetic Algorithms were applied for hyperparameter tuning. This approach was particularly effective in navigating the complex solution space associated with ensemble models, ensuring an optimal balance between bias and variance.
Genetic Algorithms were used to optimize parameters such as the number of estimators and maximum depth in Bagging classifiers. This approach led to the discovery of hyperparameters that maximized model performance, particularly in scenarios where traditional grid search methods were computationally prohibitive.
For example, the Bagging classifier with Decision Trees as a base learner showed improved accuracy and F1-scores after optimization, confirming the effectiveness of Genetic Algorithms in fine-tuning model parameters .


![image](https://github.com/user-attachments/assets/e0b15ce1-a1de-48d9-82d5-8d9c8c46a35c)
#### Figure: Optimizations of hyperparameters of Adaboost model (RF as base learner).

![image](https://github.com/user-attachments/assets/be6261d7-8f47-41b6-8ecc-e805b039eb5a)
#### Figure: Learning Curves for Best AdaBoost Model after optimising with genetic algorithm

## Evaluation Metrics
The models were rigorously evaluated using metrics including accuracy, precision, recall, and F1-score, with additional emphasis on computational efficiency.
Cross-validation was employed to ensure the robustness of the results, with findings indicating that the stacking models achieved the highest accuracy and balanced performance across metrics.
Stacking Model 2 demonstrated an accuracy rate of 85.48%, with well-balanced precision, recall, and F1-scores, further validated by a cross-validated score of 85.39%, underscoring the efficacy of the ensemble approach .




![image](https://github.com/user-attachments/assets/ccbcc76a-9601-44de-bcaa-fc2ebe15b134)
#### Figure 34: Comparative view of the models implemented for vertebral dataset for vertebral column disorder classifications.
## Conclusions
This project successfully demonstrated the effectiveness of various machine learning models, particularly ensemble techniques, in diagnosing vertebral column disorders using biomechanical data. Key findings include:

Ensemble Learning: Techniques like Bagging and Stacking proved to be highly effective in improving diagnostic accuracy, surpassing traditional single-model approaches.

Genetic Algorithms: The application of Genetic Algorithms for hyperparameter optimization significantly enhanced the performance of the ensemble models, confirming their utility in refining complex machine learning systems.

Robustness and Reliability: The combination of rigorous data preprocessing, careful model selection, and advanced optimization techniques led to robust models capable of reliable vertebral disorder diagnosis.


## Limitations
While the project yielded promising results, there are several limitations to consider:

Dataset Size: The relatively small size of the dataset may limit the generalizability of the findings. Larger, more diverse datasets would likely yield more robust models.

Model Complexity: Although ensemble models performed well, their complexity could hinder implementation in real-world clinical settings, where interpretability and computational efficiency are crucial.

Imbalance in Data: The dataset exhibited some class imbalance, which, despite the application of techniques like AdaBoost, may have affected the performance of the models, particularly in predicting minority classes.

Computational Resources: The optimization process, particularly the use of Genetic Algorithms, required significant computational resources, which could be a limitation for deployment in less resource-rich environments.


