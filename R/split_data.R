#' Split Data into Training and Testing Sets
#'
#' Splits a dataset into training and testing sets based on a specified proportion.
#' It uses the 'id' column to ensure there is no data leakage (overlap) between the sets.
#'
#' @param data A data frame containing the data to split. Must contain an 'id' column.
#' @param prop A numeric value between 0 and 1 indicating the proportion of data for the training set. Default is 0.8.
#'
#' @return A list containing two data frames: `train` and `test`.
#' @export
#'
#' @examples
#' df <- data.frame(id = 1:10, value = rnorm(10))
#' split <- split_data(df, prop = 0.8)
#' split$train
#' split$test
split_data <- function(data, prop = 0.8) {
  
  if (!"id" %in% colnames(data)) {
    stop("The dataset must contain an 'id' column to perform the split.")
  }
  
  set.seed(310)

  train_data <- data %>% 
    dplyr::sample_frac(prop)
    
  test_data <- dplyr::anti_join(data, train_data, by = "id")
    
  return(list(train = train_data, test = test_data))
}
