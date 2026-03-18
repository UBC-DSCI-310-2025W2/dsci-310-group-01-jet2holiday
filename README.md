# dsci-310-group-01-jet2holiday-

# Predicting Airbnb Nightly Prices

## Authors:
- Jialin Zhang
- Richard He
- Sean Holiday
- Eddi Xie

## Project Introduction
This repository is part of Milestone 1 of the DSCI 310 course project to perform a predictive analysis on a public dataset. We chose to conduct our analysis on the public Vancouver Airbnb data available from the link: "https://insideairbnb.com/get-the-data/" under "Vancouver, British Columbia, Canada 17 November, 2025". Using this data, we built a regression model to predict Airbnb listing nightly prices using the features available in the dataset such as room type, location, capacity, review scores, and host attributes.

The goal of this analysis is to see how well we can predict the nightly price of Airbnb listings in Vancouver, British Columbia using key hosting and property features.

## Analysis Findings

Our multiple linear regression model achieved a test RMSE of 0.46 and a test R-squared of 0.497, meaning the model explains approximately 49.7% of the variance in log-transformed nightly prices on unseen data. 

We identified the strongest predictors to nightly prices that was used in the predictive model:
- `accommodates` 
- `bedrooms` 
- `bathrooms` 
- `room_type`
-  `property_type` 

Tourists (airbnb customers) can get a reasonable estimate of whether a listing is fairly priced simply by looking at these features, without needing to dig into host history or review scores.

## How to Run the Analysis

### Using Docker

1. Clone the repository:
```
git clone https://github.com/UBC-DSCI-310-2025W2/dsci-310-group-01-jet2holiday.git
cd dsci-310-group-01-jet2holiday
```

2. Build the Docker image:
```
docker build -t airbnb-analysis .
```
3. Run the container:
```
docker run -p 8888:8888 airbnb-analysis
```
4. Open the Jupyter link provided in the terminal.

## Dependencies

The analysis uses an R environment managed by `renv` (see `renv.lock`), with:

- R 4.5.2
- tidyverse 2.0.0
- repr 1.1.7
- ggplot2 4.0.1
- dplyr 1.1.4
- readr 2.1.6
- stringr 1.6.0
- patchwork 1.3.2
- car 3.1-5
- broom 1.0.11

To install all required dependencies locally:

```sh
R -e "install.packages('renv')"
R -e "renv::restore()"
```

## License
This project uses the following licenses (see `LICENSE.md` for full text):

- MIT License (for code in this repository)
- Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0) (for project report and narrative content)
