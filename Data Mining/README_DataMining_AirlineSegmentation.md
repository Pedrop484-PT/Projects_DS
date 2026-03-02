# ✈️ 
Airline Customer Segmentation — AIAI Loyalty Program

**Data Mining Project** | MSc Data Science & Advanced Analytics | NOVA IMS

## Overview

Customer segmentation analysis for **Amazing International Airlines Inc. (AIAI)**, identifying actionable customer groups within the loyalty program to drive targeted marketing strategies. Applied the **CRISP-DM methodology** on a dataset of **16,735 customers** and their flight transaction history.

## Key Results

| Metric | Value |
|:-------|:------|
| Customers analyzed | 16,735 |
| Active customers clustered | 13,932 (83.3%) |
| Final segments identified | 5 |
| Optimal k (Silhouette) | 3 |
| Hopkins statistic | > 0.75 (strong clustering tendency) |

### Identified Segments

- **Engaged Redeemers** — High flight frequency + high redemption rate
- **Frequent Non-Redeemers** — High flights but low point redemption (44.2%)
- **Occasional Flyers** — Low frequency, low engagement
- **Churned** — Cancelled loyalty membership
- **Dormant** — No activity within observation period

## Methodology

### Data Preparation
- Merged Customer and Flight databases
- Handled duplicates, ghost flights, and missing values
- Engineered features: `Total_Flights`, `Redemption_Rate`, `Companion_Rate`, `Avg_Distance_per_Flight`, `Points_Balance`, `CLV`

### Feature Selection
- **VIF Analysis** to detect multicollinearity (excluded features with VIF > 10)
- Final clustering features: `Total_Flights` + `Redemption_Rate`

### Clustering
- **Hopkins Statistic** validation for clustering tendency
- **Multi-perspective evaluation**: Value-Based, Behavioral, Engagement, Loyalty Intensity
- **Algorithms**: K-Means, Hierarchical Clustering (Ward, Average), GMM
- **K selection**: Elbow + Silhouette (k=2 to k=7)

### Validation
- Per-cluster Silhouette analysis
- Kruskal-Wallis significance tests
- Robustness & sensitivity analysis

## Tech Stack

`Python` · `Pandas` · `NumPy` · `Scikit-learn` · `Matplotlib` · `Seaborn`

## Project Structure

```
├── Group31_DataPrep.ipynb              # Data cleaning & feature engineering
├── Group31_Clustering_Code.ipynb       # Main clustering analysis
├── Group31_Comprehensive_Analysis.ipynb # Extended validation & visualizations
└── README.md
```
