# author: Jialin Zhang
# date: 2026-03-18
#
# This script cleans the Airbnb dataset by selecting relevant variables, handling missing values, 
# and refactoring `host_is_superhost`, `property_type` and `neighbourhood` columns. 
# 
# It outputs cleaned data. 
#
# Usage:
# 02_clean_airbnb_data.R --input=<input> --out=<out>


library(dplyr)
library(readr)
library(stringr)
library(tidyr)
library(docopt)

# Library the package
library(airbnbtools)

doc <- "Usage:
    02_clean_airbnb_data.R --input=<input> --out=<out>
"

opt <- docopt(doc)

main <- function() {
    input <- opt$input
    out <- opt$out

    # Read the data
    raw_airbnb <- read_csv(input)

    # Clean the data using the function defined above
    airbnb <- clean_airbnb_data(raw_airbnb)

    # Create output directory
    dir.create(dirname(out), showWarnings = FALSE, recursive = TRUE)

    # Save cleaned data
    write_csv(airbnb, out)

    print(paste("Cleaned data saved to", out))
}

main()