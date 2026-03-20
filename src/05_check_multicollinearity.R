# author: Jialin Zhang
# date: 2026-03-18
#
# This script checks multicollinearity among selected predictors using VIF.
# 
# It outputs a table of VIF values.
#
# Usage:
# 05_check_multicollinearity.R --train=<train> --out=<out>


library(dplyr)
library(readr)
library(car)
library(docopt)
library(tibble)


doc <- "Usage:
  05_check_multicollinearity.R --train=<train> --out=<out>
"

opt <- docopt(doc)

main <- function() {
    
    train_path <- opt$train
    out_path <- opt$out
    
    # Read the data
    airbnb_train <- read_csv(train_path)

    # Conduct log transformation to price
    airbnb_train <- airbnb_train %>%
      mutate(log_price = log(price))
    
    # Build a test model using accommodates, bedrooms, bathrooms, room_type and property_type for multicollinearity check
    model_vif <- lm(
      log_price ~ accommodates + bedrooms + bathrooms + room_type + property_type,
      data = airbnb_train
    )
    
    # Find out the VIF value for each variable
    vif_table <- vif(model_vif) %>%
      as.data.frame() %>%
      select(`GVIF^(1/(2*Df))`) %>%
      rename(VIF = `GVIF^(1/(2*Df))`) %>%
      tibble::rownames_to_column("Variable")
    
    # Create output directory
    dir.create(dirname(out_path), showWarnings = FALSE, recursive = TRUE)
    
    # Save output data
    write_csv(vif_table, out_path)
    
    print("VIF table saved successfully.")
}


main()