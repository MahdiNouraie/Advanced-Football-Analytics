#### Predict features ####
# Load necessary packages, install if not present
packages <- c("maptree", "readr", "caret", "glmnet", "randomForest", "Metrics")
new_packages <- packages[!(packages %in% installed.packages()[, "Package"])]
if(length(new_packages)) install.packages(new_packages)

# Load libraries
lapply(packages, library, character.only = TRUE)

# Read and load data by URL
data_url <- "https://raw.githubusercontent.com/MahdiNouraie/Advanced-Football-Analytics-Paper/refs/heads/main/data_aggregated.csv"
data <- read.csv(data_url, header = TRUE, check.names = FALSE)

# Filter only for forwards
data <- data[data$Pos == 'FW',]

# Remove columns that didn't appear in the paper
cols_to_rem <- c('Player', 'Nation', 'Pos', 'Squad', 'Comp', 'Age', 'Born', 'MP',
                  'Starts', 'Min', '90s', 'G-PK', 'PKatt', 'CrdY', 'CrdR', 'G+A', 
                  'G+A-PK', 'npxG+xA', 'xG+xA', 'Sh', 'SoT', 'G-xG', 'Cmp', 'Att', 
                  'TotDist', 'PrgDist', 'Cmp.1', 'A-xA', 'Live', 'Dead', 'Press', 
                  'Ground', 'Low', 'High', 'Left', 'Right', 'TI', 'Off', 'SCA', 
                  'GCA', 'Tkl+Int', 'Touches', 'Def Pen', 'Carries', 'Targ', 'Rec', 
                  'Rec%', 'Prog.1', 'Mn/MP', 'Min%', 'Subs', 'unSub', '+/-', 
                  'xG+/-', '2CrdY', 'OG')
data <- data[, setdiff(names(data), cols_to_rem)]

# Scale the dataframe
data <- data.frame(scale(data), check.names = FALSE)

# Choosing predictor variables
predictor_variables_FW <- c('Gls', 'onxG', 'Recov', 'Lost', 'Sh/90', 'Sw', 'PPM')

# Choosing response variables
response_variables_FW <- setdiff(colnames(data), predictor_variables_FW)

# Excluded features due to poor performance
excluded_features <- c('Cmp%', 'SCA90', '+/-90')
response_variables_FW <- setdiff(response_variables_FW, excluded_features)

# Create a new dataframe to store regression models' MSE
df_mse <- data.frame(
  variable = response_variables_FW,
  linear_regression_mse = NA,
  ridge_regression_mse = NA,
  lasso_regression_mse = NA,
  random_forest_mse = NA
)

# Fill created dataframe with regression models' MSE
set.seed(42)  # Set seed for reproducibility
for (response_variable in response_variables_FW) {
  # Define the predictor and response variables
  X <- data[predictor_variables_FW]
  y <- data[[response_variable]]

  # Split the data into training and testing sets (80/20 split)
  train_index <- createDataPartition(y, p = 0.8, list = FALSE)
  X_train <- X[train_index, ]
  y_train <- y[train_index]
  X_test <- X[-train_index, ]
  y_test <- y[-train_index]

  # Fit the models
  model_lr <- lm(y_train ~ ., data = X_train)
  model_ridge <- glmnet(as.matrix(X_train), y_train, alpha = 0)
  model_lasso <- glmnet(as.matrix(X_train), y_train, alpha = 1)
  model_rf <- randomForest(x = X_train, y = y_train, ntree = 100)

  # Make predictions
  lr_pred <- predict(model_lr, newdata = X_test)
  ridge_pred <- predict(model_ridge, s = 1, newx = as.matrix(X_test))
  lasso_pred <- predict(model_lasso, s = 1, newx = as.matrix(X_test))
  rf_pred <- predict(model_rf, newdata = X_test)

  # Calculate MSE
  lr_mse <- mse(y_test, lr_pred)
  ridge_mse <- mse(y_test, ridge_pred)
  lasso_mse <- mse(y_test, lasso_pred)
  rf_mse <- mse(y_test, rf_pred)

  # Update df_mse with the results
  df_mse[df_mse$variable == response_variable, 'linear_regression_mse'] <- lr_mse
  df_mse[df_mse$variable == response_variable, 'ridge_regression_mse'] <- ridge_mse
  df_mse[df_mse$variable == response_variable, 'lasso_regression_mse'] <- lasso_mse
  df_mse[df_mse$variable == response_variable, 'random_forest_mse'] <- rf_mse
}

# Function to calculate statistics and create a new dataframe representing statistic summary
calculate_stats <- function(model) {
  min_mse <- min(df_mse[[model]], na.rm = TRUE)
  first_quantile_mse <- quantile(df_mse[[model]], 0.25, na.rm = TRUE)
  median_mse <- median(df_mse[[model]], na.rm = TRUE)
  mean_mse <- mean(df_mse[[model]], na.rm = TRUE)
  third_quantile_mse <- quantile(df_mse[[model]], 0.75, na.rm = TRUE)
  max_mse <- max(df_mse[[model]], na.rm = TRUE)

  return(data.frame(
    regression_model = model,
    min_mse = min_mse,
    first_quantile_mse = first_quantile_mse,
    median_mse = median_mse,
    mean_mse = mean_mse,
    third_quantile_mse = third_quantile_mse,
    max_mse = max_mse
  ))
}

# Calculate statistics for each regression model
models <- c('linear_regression_mse', 'ridge_regression_mse', 'lasso_regression_mse', 'random_forest_mse')
mse_stats_df <- do.call(rbind, lapply(models, calculate_stats))
# Remove rownames
rownames(mse_stats_df) <- NULL