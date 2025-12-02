# STAT355 Project — Spotify Global Music Analysis  
**Author:** Colleen Li  
**Date:** December 2, 2025  

## Overview  
This project analyzes the **Spotify Global Music Dataset (2009–2025)** containing over 8,500 tracks.  
Using R, the project performs exploratory data analysis (EDA) and statistical testing to answer three research questions regarding track popularity, artist popularity, explicitness, and album type.

## Data  
The dataset (`spotify_data clean.csv`) includes:  
- **Track features:** popularity, explicitness, track number, etc.  
- **Artist features:** popularity, genres, followers  
- **Album features:** album type (album, single, compilation)

Data preparation included:  
- Checking for missing values  
- Removing incomplete rows  
- Extracting and cleaning genres  
- Removing extreme zeros and outliers where necessary for analysis

## Research Questions  
### **1. Do tracks with higher artist popularity tend to have higher track popularity?**  
- Methods: Correlation test and linear regression  
- Result: Weak positive correlation (r ≈ 0.38). There is some statistically significant relationship, but it is likely not linear.
- Interpretation: Popular artists tend to have popular tracks, but many other factors influence outcomes.

### **2. Is there a significant difference in popularity between explicit and non-explicit tracks?**  
- Method: Two-sample t-test  
- Result: Explicit tracks are significantly more popular (p < 2.2e-16).  
- Mean explicit > Mean non-explicit by ~5–7 points.  
- Note: Dataset has many more non-explicit tracks, which may influence results.

### **3. Do album tracks tend to be more popular than singles?**  
- Methods: ANOVA + Tukey HSD  
- Result: Album tracks are significantly more popular (p < 2e-16).  
- Album tracks have higher quartiles and mean popularity.  
- Limitation: Much larger proportion of album tracks in the dataset.

## Methods Used  
- Exploratory Data Analysis (EDA)  
- Histograms, boxplots, QQ plots
- Outlier detection using 1.5×IQR
- Correlation analysis  
- Linear regression (`lm`)  
- Two-sample t-tests  
- ANOVA + TukeyHSD  

## Conclusion  
The project finds that:  
- Artist popularity correlates weakly with track popularity. There is a significant relationship between the two factors but a linear model is not ideal.
- Explicit tracks tend to be more popular than non-explicit tracks, but there are limitations due to the frequency of explicitness in the data set.
- Album tracks tend to be more popular than singles, but there are limitations due to the frequency of album types in the data set.

These results highlight the influence of artist recognition, lyrical content, and album context on music performance. Future work could incorporate additional variables and modeling techniques to deepen insights.

## Reference  
Wardabilal. (2025). *Spotify Global Music Dataset (2009–2025)*. Kaggle.  

