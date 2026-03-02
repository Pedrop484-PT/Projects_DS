# 🚗 Used Car Price Prediction — Cars 4 You

**Machine Learning Project** | MSc Data Science & Advanced Analytics | NOVA IMS

## Overview

End-to-end machine learning pipeline for **automated used car valuation**, built for an online car resale platform. The system replaces costly manual inspections with a predictive model that estimates vehicle prices from listing attributes.

## Key Results

| Metric | Value |
|:-------|:------|
| Best Model | Random Forest |
| CV RMSE (log-scale) | 0.1189 |
| Cross-Validation | 5-Fold |
| Models Compared | 6 |
| Feature Selection | RF-based (Top 7) |
| Stability (Std Dev) | 0.0007 |

### Model Comparison

| Algorithm | Avg CV RMSE | Stability |
|:----------|:------------|:----------|
| **Random Forest** | **0.1189** | **0.0007** |
| ExtraTrees | 0.1266 | 0.0012 |
| KNN | 0.1287 | 0.0036 |
| Gradient Boosting | — | — |
| Lasso | — | — |

## Pipeline Architecture

### 1. Data Processing
- Custom `DataCleaner` class for reproducible cleaning
- Label standardization, numeric sanitization

### 2. Feature Engineering
- `CarFeatureEngineer` — Scikit-learn compatible transformer
- Domain-specific features from raw vehicle attributes
- Log-transformation of target variable

### 3. Preprocessing
- `ColumnTransformer` with automated column routing
- Separate pipelines for numeric/categorical features

### 4. Feature Selection
- Multiple strategies evaluated
- **Random Forest Selection (Top 7 features)** as optimal

### 5. Model Optimization
- `RandomizedSearchCV` with 100 iterations
- 5-Fold CV for robust estimation

### 6. Validation
- Residual analysis
- Ablation study (complexity vs. performance)

## Tech Stack

`Python` · `Scikit-learn` · `Pandas` · `NumPy` · `Matplotlib` · `Seaborn`

## Project Structure

```
├── EDA_Group34.ipynb                        # Exploratory Data Analysis
├── Feature_Selection_Analysis_Group34.ipynb  # Feature selection experiments
├── Final_Project_Group34.ipynb              # Full pipeline & final model
└── README.md
```
