#' Create a boxplot function for Airbnb EDA in script 04_eda_airbnb.R
#'
#' Generate a boxplot of a categorical variable vs log_price
#'
#' @param data A data frame or tibble
#' @param x_var Unquoted categorical variable for the x-axis
#' @param title A character string specifying the plot title
#' @param subtitle Optional subtitle for the plot (default = NULL)
#' @param xlab Optional label for x-axis (default = variable name)
#' @param ylab Label for y-axis (default = "Log Price (CAD)")
#' @param fill_lab Optional fill legend label (default = xlab)
#' @param rotate_x Logical; whether to rotate x-axis labels (default = FALSE)
#'
#' @return A ggplot object representing the boxplot
#'
#' @examples
#' plot_boxplot(mtcars, cyl, "Example Plot")

plot_boxplot <- function(
    data,
    x_var,
    title,
    subtitle = NULL,
    xlab = NULL,
    ylab = "Log Price (CAD)",
    fill_lab = NULL,
    rotate_x = FALSE
) {

    # Check if the data input is a dataframe
    if (!is.data.frame(data)) {
        stop("data must be a dataframe")
    }
    
    # Check if the dataframe contains 'log_price'
    if (!"log_price" %in% colnames(data)) {
        stop("data must contain a 'log_price' column")
    }
  
    # Default x label
    if (is.null(xlab)) {
        xlab <- rlang::as_label(rlang::enquo(x_var))
    }
  
    # Default fill label
    if (is.null(fill_lab)) {
        fill_lab <- xlab
    }
    
    p <- ggplot(data, aes(x = {{x_var}}, y = log_price, fill = {{x_var}})) +
    geom_boxplot() +
    labs(
        title = title,
        x = xlab,
        y = ylab,
        fill = fill_lab,
        subtitle = subtitle
    )
  
    if (rotate_x) {
        p <- p + theme(axis.text.x = element_text(angle = 45, hjust = 1))
  }
  
    return(p)
}