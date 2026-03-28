library(testthat)
library(dplyr)
library(readr)
library(stringr)
library(tidyr)
library(docopt)
source("../../R/clean_airbnb_data.R")

test_that("`clean_airbnb_data` should throw an error if input is not a data frame", {
  expect_error(clean_airbnb_data("not_a_dataframe"), "data must be a dataframe")
  expect_error(clean_airbnb_data(123), "data must be a dataframe")
  expect_error(clean_airbnb_data(list(a = 1)), "data must be a dataframe")
})

test_that("`clean_airbnb_data` should throw an error if input data frame is missing specific columns", {
  expect_error(clean_airbnb_data(missing_col_obs), "missing required columns")
  expect_error(clean_airbnb_data(mtcars), "missing required columns")
})

test_that("`clean_airbnb_data` should return a data frame", {
  clean_df <- clean_airbnb_data(one_raw_instance_obs)
  expect_s3_class(clean_df, "data.frame")
})

test_that("`clean_airbnb_data` should return a data frame with 12 columns", {
  clean_df <- clean_airbnb_data(one_raw_instance_obs)
  expect_equal(ncol(clean_df), 12)
})

test_that("`clean_airbnb_data` should return correct column types", {
  clean_df <- clean_airbnb_data(one_raw_instance_obs)
  expect_type(clean_df$id, "character")
  expect_s3_class(clean_df$host_is_superhost, "factor")
  expect_s3_class(clean_df$property_type, "factor")
  expect_s3_class(clean_df$neighbourhood, "factor")
  expect_type(clean_df$price, "double")
})

test_that("`clean_airbnb_data` should return the correct cleaned output", {
  clean_df <- clean_airbnb_data(one_raw_instance_obs)
  expect_equal(clean_df$id, "1")
  expect_equal(as.character(clean_df$host_is_superhost), "Yes")
  expect_equal(as.character(clean_df$property_type), "House")
  expect_equal(clean_df$price, 150)
  expect_equal(as.character(clean_df$neighbourhood), "Downtown")
})

test_that("`clean_airbnb_data` should return 1 row when input has no NA values", {
  clean_df <- clean_airbnb_data(zero_na_obs)
  expect_equal(nrow(clean_df), 1)
})

test_that("`clean_airbnb_data` should return 0 rows when price is NA", {
  clean_df <- clean_airbnb_data(price_na_obs)
  expect_equal(nrow(clean_df), 0)
})

test_that("`clean_airbnb_data` should remove all rows with NA values and return only complete cases", {
  clean_df <- clean_airbnb_data(all_na_except_one_obs)
  expect_equal(nrow(clean_df), 1)
  expect_false(any(is.na(clean_df)))
})

test_that("`clean_airbnb_data` should correctly refactor `host_is_superhost` to Yes, No, or Unknown", {

   clean_df <- clean_airbnb_data(superhost_obs)

   expect_equivalent(clean_df, superhost_exp)
   expect_equal(clean_df$host_is_superhost, factor(c("Yes", "No", "Unknown"), 
                                                  levels = c("No", "Unknown", "Yes")))
})

test_that("`clean_airbnb_data` should only retain the top four most frequent property types and merge the rest into Other", {
   
   clean_df <- clean_airbnb_data(top_four_prop_type_obs)
   
   # expect_setequal checks if the items match, regardless of order
   expect_setequal(levels(clean_df$property_type), expected_prop_type_levels)
   
   # Check that there are 5 unique levels (Top 4 + Other)
   expect_equal(length(levels(clean_df$property_type)), 5)
   
   # We check indices 3 and 8 specifically:
   expect_true(all(clean_df$property_type[c(3, 8)] == "Other"))
   
   # We can also verify that the others did NOT become "Other"
   expect_false(any(clean_df$property_type[c(1, 2, 4, 5, 6, 7, 9, 10)] == "Other"))
})

test_that("`clean_airbnb_data` should only retain the top four most frequent neighbourhoods and merge the rest into Other", {
  clean_df <- clean_airbnb_data(top_four_neighbour_obs)
   
   # expect_setequal checks if the items match, regardless of order
   expect_setequal(levels(clean_df$neighbourhood), expected_neighbourhood_levels)
   
   # Check that there are 5 unique levels (Top 4 + Other)
   expect_equal(length(levels(clean_df$neighbourhood)), 5)
   
   # We check indices 3 and 8 specifically:
   expect_true(all(clean_df$neighbourhood[c(1, 10)] == "Other"))
   
   # We can also verify that the others did NOT become "Other"
   expect_false(any(clean_df$neighbourhood[c(2, 3, 4, 5, 6, 7, 8, 9)] == "Other"))
})

