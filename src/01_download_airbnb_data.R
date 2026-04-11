# author: Jialin Zhang
# date: 2026-03-18
#
# This script downloads Airbnb data from the InsideAirbnb website URL: 
# "https://data.insideairbnb.com/canada/bc/vancouver/2025-11-17/data/listings.csv.gz"
#
# If the script does not function correctly because of the url being invalid/outdated, 
# please obtain the most version by heading to the website URL:
# https://insideairbnb.com/get-the-data/
#
# It outputs a raw dataset. 
#
# Usage:
# 01_download_airbnb_data.R --url=<url> --out=<out>

library(readr)
library(docopt)


doc <- "Usage: 
    01_download_airbnb_data.R --url=<url> --out=<out>
"

opt <- docopt(doc)

# Download data from URL
download_data <- function(url) {
    raw_airbnb <- read_csv(url)
    return(raw_airbnb)
}


main <- function() {    
    url <- opt$url
    out <- opt$out

    # Read the data
    raw_airbnb <- download_data(url)

    # Create output directory
    dir.create(dirname(out), showWarnings = FALSE, recursive = TRUE)

    # Save raw data
    write_csv(raw_airbnb, out)

    print(paste("Data saved to", out))
}


main()