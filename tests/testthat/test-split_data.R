library(testthat)
library(dplyr)

# Source your new function
source("../../R/split_data.R")

test_that("split_data returns a list with two dataframes named 'train' and 'test'", {
  set.seed(310)
  dummy_df <- data.frame(id = 1:10, val = runif(10))
  res <- split_data(dummy_df)
  
  expect_type(res, "list")
  expect_named(res, c("train", "test"))
  expect_s3_class(res$train, "data.frame")
  expect_s3_class(res$test, "data.frame")
})

test_that("split_data splits accurately based on the default 0.8 proportion", {
  set.seed(310)
  dummy_df <- data.frame(id = 1:100, val = runif(100))
  res <- split_data(dummy_df, prop = 0.8)
  
  expect_equal(nrow(res$train), 80)
  expect_equal(nrow(res$test), 20)
})

test_that("split_data handles the edge case of prop = 0 (100% test data)", {
  dummy_df <- data.frame(id = 1:10, val = runif(10))
  res <- split_data(dummy_df, prop = 0)
  
  expect_equal(nrow(res$train), 0)
  expect_equal(nrow(res$test), 10)
})

test_that("split_data throws a clear error if 'id' column is missing", {
  bad_df <- data.frame(price = 1:10, rooms = 1:10)
  
  # The test passes if the function correctly throws this exact error
  expect_error(split_data(bad_df), "must contain an 'id' column")
})
