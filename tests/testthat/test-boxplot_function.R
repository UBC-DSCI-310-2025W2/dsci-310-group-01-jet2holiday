library(testthat)
library(ggplot2)

source("../../R/boxplot_function.R")


# Expected case
test_that("plot_boxplot returns a ggplot object for valid input", {
    df <- mtcars
    df$log_price <- log(df$mpg)
    p <- plot_boxplot(df, cyl, "Test Plot")
    # Check output, should be a ggplot
    expect_s3_class(p, "ggplot")
})


# Default fill label test
test_that("plot_boxplot uses x variable name as the default fill label", {
    df <- mtcars
    df$log_price <- log(df$mpg)
    p <- plot_boxplot(df, cyl, "Test Plot")
    # Check default fill label, should be "cyl"
    expect_equal(p$labels$fill, "cyl")
})


# Custom fill label test
test_that("plot_boxplot correctly uses custom fill label", {
    df <- mtcars
    df$log_price <- log(df$mpg)
    p <- plot_boxplot(
        df,
        cyl,
        "Test Plot",
        fill_lab = "Custom Label"
    )
    # Check custom fill label, should be "Custom Label"
    expect_equal(p$labels$fill, "Custom Label")
})


# X lab test
test_that("plot_boxplot uses default xlab correctly", {
    df <- mtcars
    df$log_price <- log(df$mpg)
    p <- plot_boxplot(df, cyl, "Test Plot")
    # Check default x label, should be "cyl"
    expect_equal(p$labels$x, "cyl")
})


# Edge case
test_that("plot_boxplot works with empty dataframe", {
    df <- mtcars[0, ]
    df$log_price <- numeric(0)
    p <- plot_boxplot(df, cyl, "Empty Plot")
    # Check output when input data is an empty dataframe, should be a ggplot
    expect_s3_class(p, "ggplot")
})
