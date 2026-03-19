# author: Jialin Zhang
# date: 2026-03-18
#
# This script fits a multiple linear regression model and evaluates its performance on the test dataset. 
# 
# It outputs the model performance metrics and the trained model.
#
# Usage:
# 06_model_airbnb_price.R --train=<train> --test=<test> --metrics_out=<metrics_out> --model_out=<model_out>


library(dplyr)
library(readr)
library(docopt)


doc <- "Usage:
  06_model_airbnb_price.R --train=<train> --test=<test> --metrics_out=<metrics_out> --model_out=<model_out>
"

opt <- docopt(doc)

main <- function() {
    
    train_path <- opt$train
    test_path <- opt$test
    metrics_path <- opt$metrics_out
    model_path <- opt$model_out
    
    # Read the data
    airbnb_train <- read_csv(train_path)
    airbnb_test <- read_csv(test_path)

    # Conduct log transformation to price in airbnb_train
    airbnb_train <- airbnb_train %>%
      mutate(log_price = log(price))

    # Conduct log transformation to price in airbnb_test
    airbnb_test <- airbnb_test %>% 
        mutate(log_price = log(price))
    
    # Build the multiple linear regression model using accommodates, bedrooms, bathrooms, room_type and property_type
    airbnb_model <- lm(
        log_price ~ accommodates + bedrooms + bathrooms + room_type + property_type, 
        data = airbnb_train
    )
    
    # Conduct Prediction
    predictions <- predict(airbnb_model, newdata = airbnb_test)
    actuals <- airbnb_test$log_price
    
    # RMSE
    rmse <- sqrt(mean((predictions - actuals)^2))
    
    # r2
    ss_res <- sum((actuals - predictions)^2)
    ss_tot <- sum((actuals - mean(actuals))^2)
    r2_test <- 1 - (ss_res / ss_tot)
    
    # Save the metrics
    metrics <- tibble::tibble(
        Metric = c("RMSE", "R_squared"),
        Value = c(rmse, r2_test)
      )

    # Create output directory
    dir.create(dirname(metrics_path), showWarnings = FALSE, recursive = TRUE)
    write_csv(metrics, metrics_path)
    
    # Save the model
    dir.create(dirname(model_path), showWarnings = FALSE, recursive = TRUE)
    saveRDS(airbnb_model, model_path)
    
    print("Model and metrics saved successfully.")
}


main()