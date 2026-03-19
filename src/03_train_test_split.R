# author: Jialin Zhang
# date: 2026-03-18
#
# This script splits the cleaned Airbnb dataset into training and testing sets.
# It outputs the training set and testing set. 
#
# Usage:
# 03_train_test_split.R --input=<input> --train=<train> --test=<test>


library(dplyr)
library(readr)
library(docopt)

doc <- "Usage:
  03_train_test_split.R --input=<input> --train=<train> --test=<test>
"

opt <- docopt(doc)

split_data <- function(airbnb) {
    
    # Set seed for reproducibility
    set.seed(310)

    # Conduct an 80-20 split
    airbnb_train <- airbnb %>% 
    sample_frac(0.8)
    
    airbnb_test <- anti_join(airbnb, airbnb_train, by = "id")
    
    return(list(train = airbnb_train, test = airbnb_test))
}


main <- function() {
    
    input <- opt$input
    train_path <- opt$train
    test_path <- opt$test
    
    # Read cleaned data
    airbnb <- read_csv(input)
    
    # Split the data
    split <- split_data(airbnb)
    airbnb_train <- split$train
    airbnb_test <- split$test
    
    # Create output directories
    dir.create(dirname(train_path), showWarnings = FALSE, recursive = TRUE)
    dir.create(dirname(test_path), showWarnings = FALSE, recursive = TRUE)
    
    # Save train and test sets
    write_csv(airbnb_train, train_path)
    write_csv(airbnb_test, test_path)
    
    # Print dimensions
    cat("Training Set Dimensions:", dim(airbnb_train), "\n")
    cat("Testing Set Dimensions:", dim(airbnb_test), "\n")
}


main()