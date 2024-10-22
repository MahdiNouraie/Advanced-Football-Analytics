---

# Advanced Football Analytics: Predicting Player Features

This repository contains the supporting code for the paper titled "Advanced Football Analytics: Predicting Player Features through Hierarchical Clustering and Representative Feature Selection". The code is written entirely in **R** and reflects the methodologies described in the paper.

## Repository Contents

### 1. `Preprocessing.R`
This script performs the **data cleaning and preparation** procedures, as detailed in the paper. It processes raw football player statistics, transforming them into a format suitable for subsequent analysis.

### 2. `Clustering_and_Leader_Finding.R`
This script implements the **hierarchical clustering algorithm** and includes the function used to identify **leaders (representative features)** of the clusters, following the methodology presented in the paper.

### 3. `Bootstrapping.R`
This script applies **bootstrapping** to the clustering results, enabling an evaluation of the **stability** of the clustering outcomes when subject to data perturbations.

### 4. `data_aggregated.csv`
This file contains the final, cleaned data set produced by the `Preprocessing.R` script, which is subsequently used in the clustering and bootstrapping analyses.

---
