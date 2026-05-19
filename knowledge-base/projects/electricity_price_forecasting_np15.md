# Electricity Price Forecasting at NP-15 (Northern California)

## Short Summary

This project focused on forecasting electricity prices for the NP-15 pricing node in the California Independent System Operator (CAISO) market using a hybrid machine learning and time-series forecasting pipeline. The system was designed to predict electricity prices 1–15 days ahead by combining SARIMAX-based statistical forecasting with Gradient Boosting refinement techniques.

Electricity prices are highly volatile due to changing supply-demand conditions, renewable energy fluctuations, weather patterns, and transmission congestion. To address this, the project integrated historical electricity prices with external variables such as solar generation, wind generation, and temperature forecasts. The final hybrid model achieved a Mean Absolute Error (MAE) of 16.79, demonstrating that combining statistical forecasting with machine learning refinement can significantly improve prediction accuracy.

---

# Problem

Electricity markets are extremely dynamic and difficult to forecast because prices are influenced by multiple external factors, including:

* Demand fluctuations
* Renewable energy variability
* Transmission congestion
* Weather conditions
* Grid instability

Traditional forecasting methods often struggle to capture both long-term seasonality and short-term non-linear price spikes. The goal of this project was to build a more accurate forecasting pipeline capable of predicting NP-15 electricity prices 1–15 days into the future using both historical market data and external environmental variables.

---

# Architecture

```text
Historical Electricity Prices (NP-15)
                +
External Variables
(Solar, Wind, Temperature Forecasts)
                ↓
        Data Cleaning & Merging
                ↓
        Exploratory Data Analysis
                ↓
      SARIMAX Time-Series Model
                ↓
    Initial Electricity Forecasts
                ↓
    Gradient Boosting Regressor
                ↓
 Refined Final Price Predictions
                ↓
 Model Evaluation (MAE / MAPE)
```

The forecasting system used a two-stage hybrid pipeline:

1. SARIMAX captured seasonality, autoregressive patterns, and exogenous variable relationships.
2. Gradient Boosting refined SARIMAX residual errors and learned additional non-linear relationships.

---

# My Role

I worked on designing and implementing the forecasting pipeline, preprocessing and merging multiple datasets, performing exploratory data analysis, training the forecasting models, evaluating model performance, and analyzing forecasting accuracy.

I also contributed to:

* Time-series analysis and seasonality detection
* Model selection and comparison
* Hyperparameter tuning
* Forecast refinement using machine learning
* Performance evaluation using MAE and MAPE metrics
* Preparing the final research-style technical report and visualizations

---

# Tech Stack

## Machine Learning / Forecasting

* SARIMAX
* Gradient Boosting Regressor
* XGBoost
* Random Forest

## Programming / Data Tools

* Python
* pandas
* NumPy
* scikit-learn
* statsmodels
* matplotlib

## Dataset Sources

* CAISO electricity market data
* Solar generation forecasts
* Wind generation forecasts
* Temperature datasets

---

# Key Features

* Hybrid forecasting architecture combining statistical and ML models
* Electricity price prediction for 1–15 day forecasting windows
* Integration of exogenous variables including:

  * temperature
  * solar generation
  * wind generation
* Seasonal time-series modeling using SARIMAX
* Residual error correction using Gradient Boosting
* Model comparison against:

  * XGBoost
  * Random Forest
* Performance evaluation using MAE and MAPE
* Visualization of:

  * volatility
  * autocorrelation
  * partial autocorrelation
  * forecasting trends

---

# Important Design Decisions

The project used SARIMAX as the baseline forecasting model because electricity price data exhibits strong temporal dependencies and daily seasonality patterns. The SARIMAX configuration:

```text
SARIMAX(1,1,1)(1,1,1)₍₂₄₎
```

was specifically chosen to capture 24-hour seasonal cycles in hourly electricity price data.

Gradient Boosting was selected as the refinement model because it could learn non-linear residual relationships left behind by SARIMAX predictions. Although XGBoost achieved slightly lower MAPE values, Gradient Boosting achieved the best overall MAE ratio and therefore became the final refinement model.

The decision to combine statistical forecasting with machine learning refinement created a more robust hybrid architecture compared to relying solely on either approach individually.

---

# Challenges

Several real-world data engineering and modeling challenges were encountered during development:

* Limited future exogenous variable availability
* Aligning solar, wind, and temperature forecasts with future prediction windows
* Handling highly volatile electricity price spikes
* Cleaning and restructuring datasets with inconsistent formats
* Managing non-stationary time-series behavior
* Improving SARIMAX residual forecasting accuracy

To address these issues:

* datasets were carefully cleaned and merged
* future forecast variables were aligned with prediction windows
* Gradient Boosting was used to correct SARIMAX residual errors and improve final prediction quality

---

# Final Outcome

The final hybrid forecasting pipeline successfully combined SARIMAX and Gradient Boosting to improve electricity price prediction accuracy for the NP-15 node in the CAISO market.

The project achieved:

```text
MAE = 16.79
```

which demonstrated that combining time-series statistical forecasting with machine learning refinement can significantly improve prediction performance under constrained conditions without relying on deep learning methods.

The project also strengthened practical experience in:

* time-series forecasting
* feature engineering
* hybrid ML systems
* model evaluation
* sequential data analytics
* energy market prediction systems

GitHub Repository:

[Electricity Price Forecasting at NP-15 Repository](https://github.com/shubhamjoshi1303/Electricity-Price-Forecasting-at-NP-15-Northern-California-?utm_source=chatgpt.com)

---

# Interview Pitch

This project focused on forecasting electricity prices for the NP-15 node in the California electricity market using a hybrid machine learning pipeline. Electricity prices are highly volatile and influenced by factors like renewable energy generation, weather, and demand fluctuations, so the goal was to improve prediction accuracy using both statistical forecasting and machine learning refinement techniques.

I built a two-stage forecasting architecture where SARIMAX captured the underlying seasonal and temporal patterns in the electricity price data, while a Gradient Boosting model refined the SARIMAX predictions by learning residual errors and additional non-linear relationships. I worked on data preprocessing, exploratory analysis, model training, feature engineering, and performance evaluation using metrics like MAE and MAPE.

The final model achieved an MAE of 16.79 and demonstrated how combining traditional time-series forecasting with machine learning can improve prediction performance in highly dynamic systems like electricity markets.
