# Tests for model_evaluation_helpers.R

# --- calculate_rmse tests ---

test_that("calculate_rmse returns 0 for perfect predictions", {
  expect_equal(calculate_rmse(c(1, 2, 3), c(1, 2, 3)), 0, tolerance = 1e-10)
})

test_that("calculate_rmse returns correct known value", {
  # Each prediction is off by 1, so RMSE = sqrt(mean(1^2, 1^2, 1^2)) = 1
  expect_equal(calculate_rmse(c(2, 3, 4), c(1, 2, 3)), 1, tolerance = 1e-10)
})

test_that("calculate_rmse is symmetric", {
  a <- c(1, 2, 3, 4, 5)
  b <- c(1.5, 2.3, 2.7, 4.1, 5.5)
  expect_equal(calculate_rmse(a, b), calculate_rmse(b, a), tolerance = 1e-10)
})

test_that("calculate_rmse works with single element", {
  expect_equal(calculate_rmse(5, 3), 2, tolerance = 1e-10)
})

test_that("calculate_rmse errors on different lengths", {
  expect_error(calculate_rmse(c(1, 2), c(1, 2, 3)), "same length")
})

test_that("calculate_rmse errors on non-numeric input", {
  expect_error(calculate_rmse(c("a", "b"), c(1, 2)), "must be numeric")
})

test_that("calculate_rmse errors on NA values", {
  expect_error(calculate_rmse(c(1, NA), c(1, 2)), "must not contain NA")
})

# --- calculate_r_squared tests ---

test_that("calculate_r_squared returns 1 for perfect predictions", {
  expect_equal(calculate_r_squared(c(1, 2, 3), c(1, 2, 3)), 1, tolerance = 1e-10)
})

test_that("calculate_r_squared returns 0 when predicting the mean", {
  actual <- c(1, 2, 3, 4, 5)
  predicted <- rep(mean(actual), length(actual))
  expect_equal(calculate_r_squared(predicted, actual), 0, tolerance = 1e-10)
})

test_that("calculate_r_squared can be negative for bad predictions", {
  actual <- c(1, 2, 3)
  predicted <- c(10, 20, 30) # wildly off
  result <- calculate_r_squared(predicted, actual)
  expect_true(result < 0)
})

test_that("calculate_r_squared returns correct known value", {
  # Hand-calculated: actual = c(1,2,3), predicted = c(1.1, 1.9, 3.2)
  # ss_res = (1-1.1)^2 + (2-1.9)^2 + (3-3.2)^2 = 0.01 + 0.01 + 0.04 = 0.06
  # ss_tot = (1-2)^2 + (2-2)^2 + (3-2)^2 = 1 + 0 + 1 = 2
  # r2 = 1 - 0.06/2 = 0.97
  expect_equal(
    calculate_r_squared(c(1.1, 1.9, 3.2), c(1, 2, 3)),
    0.97,
    tolerance = 1e-10
  )
})

test_that("calculate_r_squared errors on different lengths", {
  expect_error(calculate_r_squared(c(1, 2), c(1, 2, 3)), "same length")
})

test_that("calculate_r_squared errors on constant actuals (division by zero)", {
  expect_error(
    calculate_r_squared(c(1, 2, 3), c(5, 5, 5)),
    "identical"
  )
})

test_that("calculate_r_squared errors on NA values", {
  expect_error(calculate_r_squared(c(1, 2), c(NA, 2)), "must not contain NA")
})
