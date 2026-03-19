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

doc <- "Usage:
    02_clean_airbnb_data.R --input=<input> --out=<out>
"

opt <- docopt(doc)

# Define a data cleaning function
clean_airbnb_data <- function(raw_airbnb) {

    # Set a random seed to ensure reproducibility
    set.seed(310)

    # Keep the target variable and most relevant columns
    # Keep 'id' as a character variable
    # Remove rows where 'price' is empty, and transfer 'price' into a numeric variable
    airbnb <- raw_airbnb %>%
      select(
        id, host_is_superhost, neighbourhood_cleansed, property_type, room_type, 
        accommodates, bathrooms, bedrooms, price, review_scores_rating, reviews_per_month
      ) %>%
      mutate(id = as.character(id)) %>%
      filter(!is.na(price), price != "") %>%
      mutate(
        price = price %>%
          str_remove_all("[$,]") %>%
          as.numeric()
      ) %>%
      filter(!is.na(price)) %>%
      # Explicitly drop rows with missing values in your model's predictors
      drop_na(accommodates, bedrooms, bathrooms, room_type, property_type)

    # Refactor 'host_is_superhost' to 'Yes', 'No', "Unknown'
    airbnb <- airbnb %>%
      mutate(
        host_is_superhost = case_when(
          host_is_superhost == TRUE ~ "Yes",
          host_is_superhost == FALSE ~ "No",
          is.na(host_is_superhost) ~ "Unknown",
          TRUE ~ "Unknown"
        ),
        host_is_superhost = as.factor(host_is_superhost)
      )

    # Find out the 4 most frequent property types
    top4_property <- airbnb %>%
      count(property_type, sort = TRUE) %>%
      slice_head(n = 4) %>%
      pull(property_type)
    
    # Merge the remaining values into "Other"
    airbnb <- airbnb %>%
      mutate(property_type = ifelse(property_type %in% top4_property,
                                    property_type,
                                    "Other"),
             property_type = as.factor(property_type))

    # Find out the 4 most frequent neighbourhoods
    top4_neighbourhoods <- airbnb %>%
      count(neighbourhood_cleansed, sort = TRUE) %>%
      slice_head(n = 4) %>%
      pull(neighbourhood_cleansed)
    
    # Merge the remaining values into "Other" and rename the column
    airbnb <- airbnb %>%
      mutate(neighbourhood = ifelse(neighbourhood_cleansed %in% top4_neighbourhoods,
                                    neighbourhood_cleansed,
                                    "Other"),
             neighbourhood = as.factor(neighbourhood))
}


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