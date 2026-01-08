# Instagram Fake Account Detection

## Overview
This project focuses on identifying **fake Instagram accounts** using machine learning techniques based on profile-level attributes. The objective is to classify accounts as **genuine** or **fake** by leveraging indicators such as profile picture presence, username patterns, followers/following counts, and engagement-related features.

The project follows a structured **data science lifecycle**, including dependent variable definition, data cleaning, baseline modeling, feature engineering, model optimization, and performance evaluation. Emphasis is placed on both **accuracy** and **interpretability**.

---

## Dataset
The dataset consists of Instagram account-level information containing features related to:
- Profile picture availability
- Username characteristics
- Number of followers
- Number of accounts followed
- Social and behavioral indicators

The target variable represents whether an account is **fake (1)** or **genuine (0)**.

---

## Step 1: Dependent Variable Definition
- The dependent variable **`fake`** was used as the classification target.
- Values were encoded as:
  - `1` → Fake account  
  - `0` → Genuine account
- The variable was converted to numeric format to ensure compatibility with classification models.

---

## Step 2: Data Cleaning & Preprocessing
Several preprocessing steps were performed to prepare the data for modeling:

- Converted relevant variables to appropriate data types.
- Removed or treated outliers to reduce model distortion.
- Ensured consistency between training and testing datasets.
- Split the dataset into **training and testing sets** to evaluate generalization.

---

## Step 3: Baseline Models
Two baseline models were developed using the same set of predictors:

### Baseline Predictors
- `profile.pic`
- `nums.length.username`
- `X.followers`
- `X.follows`

### Baseline Models
- **Logistic Regression**
- **Decision Tree**

### Baseline Performance
- Logistic Regression achieved an accuracy of **0.9191**
- Decision Tree achieved an accuracy of **0.9133**

Both models demonstrated strong initial performance, with logistic regression slightly outperforming the decision tree.

---

## Step 4: Model Improvement

### Feature Engineering
To better capture suspicious behavior patterns, a new feature was introduced:
- **`follow_ratio`**: Ratio between followers and following  
  - Fake accounts often follow many users but have few followers.

### Probability Threshold Optimization
- Logistic regression probability thresholds were adjusted to improve classification performance.
- Accuracy improved from **0.9191** to **0.9249** after threshold tuning.

### Improved Decision Tree
- The decision tree model was refined through cleaning and feature enhancement.
- Final accuracy improved to **0.9306**, outperforming all baseline and improved logistic models.

---

## Model Evaluation & Comparison

| Model | Accuracy |
|-----|---------|
Baseline Logistic Regression | 0.9191 |
Baseline Decision Tree | 0.9133 |
Improved Logistic Regression | 0.9249 |
**Improved Decision Tree** | **0.9306** |

Additional evaluation metrics for the final model:
- **Accuracy:** 0.9306  
- **Sensitivity:** 0.9405  
- **Specificity:** 0.9213  
- **Precision:** 0.9186  

The improved decision tree demonstrated the best overall performance.

---

## Model Interpretation
- Fake accounts are strongly associated with abnormal follower/following behavior.
- Username structure and profile completeness play a significant role in detection.
- Decision trees outperform logistic regression due to their ability to capture **non-linear patterns**.

---

## Conclusion
The **improved decision tree model** is the most effective approach for detecting fake Instagram accounts in this dataset. Feature engineering and threshold optimization significantly enhanced performance, confirming that behavioral ratios and non-linear relationships are critical for fraud detection tasks.

---

## Limitations & Future Improvements

### Limitations
- Dataset is limited to profile-level features.
- Some genuine accounts may resemble fake accounts due to low activity.
- Logistic regression struggled with non-linear relationships.

### Future Improvements
- Incorporate text-based features from bios and captions.
- Explore ensemble models such as Random Forest or Gradient Boosting.
- Apply cross-validation for more robust evaluation.
- Integrate time-based behavioral features.

---

## Tools & Technologies
- **R** – Data preprocessing, modeling, and evaluation
- **Machine Learning** – Logistic Regression, Decision Trees
- **Git & GitHub** – Version control and documentation

---

## Author
**Abdul Bari Mohammed Abdul Kaleem**  
MSc Data Science & AI  
MISIS: M01087865
