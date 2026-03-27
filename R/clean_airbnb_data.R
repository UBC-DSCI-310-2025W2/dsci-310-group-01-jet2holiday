#' Clean raw Airbnb listing data for EDA and modelling in script 02_clean_airbnb_data.R
#'
#' Return a clean dataframe
#'
#' @param raw_airbnb A data frame or data frame extension (e.g. a tibble)
#'
#' @return A data frame object containing cleaned data of airbnb listings:
#'            - selected specific set of features for future EDA
#'            - filtered out entries (rows) with NA values
#'            - refactored certain char type features to categories
#' 
#' @export
#'
#' @examples
#' raw_airbnb <- data.frame(id = 1, host_is_superhost = TRUE, 
#'                          property_type = "House", neighbourhood_cleansed = "Downtown",
#'                          price = "$150", review_scores_rating = 4.5, 
#'                          reviews_per_month = 3, accommodates = 2, bedrooms = 1,
#'                          bathrooms = 1, room_type = "Entire")
#'                          
#' clean_airbnb_data(raw_airbnb)

clean_airbnb_data <- function(raw_airbnb) {
    
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

    return(airbnb)
}