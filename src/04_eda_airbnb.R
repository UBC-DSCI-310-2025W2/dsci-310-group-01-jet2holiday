# author: Jialin Zhang
# date: 2026-03-18
#
# This script performs Exploratory Data Analysis on the Airbnb dataset.
# It generates visualizations and summary statistics using the training data,
# and applies log transformation to both training and testing datasets.
#
# It outputs 3 figures and 1 table:
# - price_histogram.png: histogram of listing prices
# - log_price_histogram.png: histogram of log-transformed prices
# - boxplots.png: a combined plot of four boxplots
# - correlation_table.csv: correlation of log price with numeric predictors
#
# Usage:
# 04_eda_airbnb.R --train=<train> --test=<test> --out_dir=<out_dir>


library(tidyverse)
library(dplyr)
library(readr)
library(ggplot2)
library(tidyr)
library(docopt)
library(patchwork)

doc <- "Usage:
  04_eda_airbnb.R --train=<train> --test=<test> --out_dir=<out_dir>
"

opt <- docopt(doc)

main <- function() {
    
    train_path <- opt$train
    test_path <- opt$test
    out_dir <- opt$out_dir
    
    # Create output directory
    dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)
    
    # Read the data
    airbnb_train <- read_csv(train_path)
    airbnb_test <- read_csv(test_path)
    
    # Plot a histogram of 'price'
    p1 <- ggplot(airbnb_train, aes(x = price)) + 
      geom_histogram(bins = 40) + 
      labs(title = "Histogram of Airbnb Listing Price", 
           x = "Price (CAD $)", y = "Count", subtitle = "Plot 1")
    
    ggsave(file.path(out_dir, "price_histogram.png"), plot = p1, width = 6, height = 5)
    
    # Create a column called 'log_price'
    airbnb_train <- airbnb_train %>% 
        mutate(log_price = log(price))
    
    # Plot a histogram of 'log_price'
    p2 <- ggplot(airbnb_train, aes(x = log_price)) + 
      geom_histogram(bins = 40) + 
      labs(title = "Histogram of Log-transformed Airbnb Listing Price", 
           x = "Log Price (CAD)", y = "Count", subtitle = "Plot 2")
    
    ggsave(file.path(out_dir, "log_price_histogram.png"), plot = p2, width = 6, height = 5)
    
    # Also creating a log_price target variable for our test data
    airbnb_test <- airbnb_test %>% 
        mutate(log_price = log(price))
    
    # Select numeric variables
    numeric_vars <- airbnb_train %>%
      select(log_price, accommodates, bathrooms, bedrooms,
             review_scores_rating, reviews_per_month)
    
    # Compute the correlation between log_price and numeric predictors
    cor_table <- cor(numeric_vars, use = "complete.obs")["log_price", ] %>%
      enframe(name = "variable", value = "correlation") %>%
      filter(variable != "log_price") %>%
      arrange(desc(abs(correlation)))
    
    write_csv(cor_table, file.path(out_dir, "correlation_table.csv"))
    
    # Boxplot: Room Type vs. Log Price
    p3 <- ggplot(airbnb_train, aes(x = room_type, y = log_price, fill = room_type)) +
      geom_boxplot() +
      labs(title = "Log Price by Room Type",
           x = "Room Type",
           y = "Log Price (CAD)",
           fill = "Room Type",
           subtitle = "Plot 3")
    
    # Boxplot: Property Type vs. Log Price
    p4 <- ggplot(airbnb_train, aes(x = property_type, y = log_price, fill = property_type)) +
      geom_boxplot() +
      labs(title = "Log Price by Property Type",
           x = "Property Type",
           y = "Log Price (CAD)",
           fill = "Property Type",
           subtitle = "Plot 4") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    # Boxplot: Neighbourhood vs. Log Price
    p5 <- ggplot(airbnb_train, aes(x = neighbourhood, y = log_price, fill = neighbourhood)) +
      geom_boxplot() +
      labs(title = "Log Price by Neighbourhood",
           x = "Neighbourhood",
           y = "Log Price (CAD)",
           fill = "Neighbourhood",
           subtitle = "Plot 5") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    # Boxplot: Superhost Status vs. Log Price
    p6 <- ggplot(airbnb_train, aes(x = host_is_superhost, y = log_price, fill = host_is_superhost)) +
    geom_boxplot()
    
    combined_plot <- (p3 | p4) / (p5 | p6)
    
    ggsave(file.path(out_dir, "boxplots.png"),
    plot = combined_plot,
    width = 12, height = 10)
    
    print("EDA completed and outputs saved.")
}


main()