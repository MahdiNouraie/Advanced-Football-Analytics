---

# Advanced Football Analytics: Predicting Player Features

This repository contains the supporting code and data for the paper titled **"Advanced Football Analytics; Predicting Player Features through Hierarchical Clustering and Representative Feature Selection"**. The code is written entirely in **R** and reflects the methodologies described in the paper.

## Repository Contents

### 1. `Preprocessing.R`
This script performs the **data cleaning and preparation** procedures, as detailed in the paper. It processes raw football player statistics, transforming them into a format suitable for subsequent analysis.

### 2. `Clustering_and_Leader_Finding.R`
This script implements the **hierarchical clustering algorithm** and includes the function used to identify **leaders (representative features)** of the clusters, following the methodology presented in the paper.

### 3. `Bootstrapping.R`
This script applies **bootstrapping** to the clustering results, enabling an evaluation of the **stability** of the clustering outcomes when subject to data perturbations.

### 4. `Evaluation.R`
This script applies four different regression models with represetative features as input and remaining features as output to predict the remaining variables.

### 5. `fbref_outfield_player_stats_combined_latest.csv`
This file contains the raw data set used for this research.

### 6. `data_aggregated.csv`
This file contains the final, cleaned data set produced by the `Preprocessing.R` script, which is subsequently used in the next analyses.

---
