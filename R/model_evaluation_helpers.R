# Model Evaluation Helper Functions
#
# Functions extracted from src/06_model_airbnb_price.R for reuse
# across the Airbnb price prediction analysis pipeline.

#' Calculate Root Mean Squared Error
#'
#' Computes RMSE between vectors of predicted and actual values.
#' RMSE measures the average magnitude of prediction errors.
#'
#' @param predicted A numeric vector of predicted values.
#' @param actual A numeric vector of actual (observed) values.
#'
#' @return A single numeric value representing the RMSE.
#'
#' @examples
#' calculate_rmse(c(1, 2, 3), c(1.1, 2.2, 2.8))
calculate_rmse <- function(predicted, actual) {
  if (!is.numeric(predicted) || !is.numeric(actual)) {
    stop("Both `predicted` and `actual` must be numeric vectors.")
  }
  if (length(predicted) != length(actual)) {
    stop("`predicted` and `actual` must have the same length.")
  }
  if (any(is.na(predicted)) || any(is.na(actual))) {
    stop("`predicted` and `actual` must not contain NA values.")
  }

  rmse <- sqrt(mean((predicted - actual)^2))
  return(rmse)
}

#' Calculate R-squared (Coefficient of Determination)
#'
#' Computes R-squared from predicted and actual values using the formula:
#' 1 - SS_res / SS_tot. Suitable for evaluating model performance on test
#' data where summary(model)$r.squared is not applicable.
#'
#' @param predicted A numeric vector of predicted values.
#' @param actual A numeric vector of actual (observed) values.
#'
#' @return A single numeric value representing R-squared.
#'
#' @examples
#' calculate_r_squared(c(1, 2, 3), c(1.1, 1.9, 3.2))
calculate_r_squared <- function(predicted, actual) {
  if (!is.numeric(predicted) || !is.numeric(actual)) {
    stop("Both `predicted` and `actual` must be numeric vectors.")
  }
  if (length(predicted) != length(actual)) {
    stop("`predicted` and `actual` must have the same length.")
  }
  if (any(is.na(predicted)) || any(is.na(actual))) {
    stop("`predicted` and `actual` must not contain NA values.")
  }

  ss_res <- sum((actual - predicted)^2)
  ss_tot <- sum((actual - mean(actual))^2)

  if (ss_tot == 0) {
    stop("All actual values are identical; R-squared is undefined (division by zero).")
  }

  r_squared <- 1 - (ss_res / ss_tot)
  return(r_squared)
}
