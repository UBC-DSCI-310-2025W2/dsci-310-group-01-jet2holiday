# author: Jialin Zhang
# date: 2026-03-18
#
# This script evaluates the fitted model by generating a coefficient plot and a residual plot using the test dataset.
#
# It outputs 2 figures: "coefficient_plot.png" and "residual_plot.png".
#
# Usage:
# 07_model_evaluation.R --model=<model> --test=<test> --out_dir=<out_dir>


library(dplyr)
library(readr)
library(ggplot2)
library(docopt)
library(broom)


doc <- "Usage:
  07_model_evaluation.R --model=<model> --test=<test> --out_dir=<out_dir>
"

opt <- docopt(doc)

main <- function() {
    
    model_path <- opt$model
    test_path <- opt$test
    out_dir <- opt$out_dir
    
    # Create output directory
    dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)
    
    # Read model and data
    airbnb_model <- readRDS(model_path)
    airbnb_test <- read_csv(test_path)

    # Conduct log transformation to price in airbnb_test
    airbnb_test <- airbnb_test %>% 
        mutate(log_price = log(price))
    
    # Plot a Coefficient Plot of the model
    tidy_model <- tidy(airbnb_model, conf.int = TRUE)
    
    p7 <- ggplot(tidy_model %>% filter(term != "(Intercept)"),
           aes(x = estimate, y = reorder(term, estimate))) +
      geom_point() +
      geom_errorbar(aes(xmin = conf.low, xmax = conf.high), height = 0.2) +
      labs(title = "Regression Coefficient Estimates",
           x = "Coefficient Estimate",
           y = "Variables",
           subtitle = "Plot 7")
    
    ggsave(
        file.path(out_dir, "coefficient_plot.png"),
        plot = p7,
        width = 10,
        height = 8
    )
    
    # Conduct Predictions
    predictions <- predict(airbnb_model, newdata = airbnb_test)
    
    airbnb_residuals <- airbnb_test %>%
        select(log_price) %>%
        mutate(y_hat = predictions,
               residual = log_price - y_hat)
    
    # Plot a residual plot of the model
    p8 <- airbnb_residuals %>%
        ggplot(aes(x = y_hat, y = log_price)) +
        geom_point() +
        labs(title = "Predicted vs Actual Log Prices",
            x = "Predicted Log Price",
            y = "Actual Log Price",
            subtitle = "Plot 8")
    
    ggsave(
        file.path(out_dir, "residual_plot.png"),
        plot = p8,
        width = 8,
        height = 6
    )
    
    print("Model evaluation plots saved successfully.")
}


main()