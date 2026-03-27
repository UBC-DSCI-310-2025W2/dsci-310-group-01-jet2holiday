#function input and output for `clean_airbnb_data` function tests

# ── Raw input data frames ──────────────────────────────────────────
one_raw_instance_obs <- data.frame(id = 1,
                               listing_url = "test_url",
                               name = "test_name",
                               description = "test_description",
                               host_is_superhost = TRUE,
                               property_type = "House",
                               neighbourhood_cleansed = "Downtown",
                               price = "$150",
                               review_scores_rating = 4.5,
                               reviews_per_month = 3,
                               accommodates = 2,
                               bedrooms = 1,
                               bathrooms = 1,
                               room_type = "Entire")

zero_na_obs <- one_raw_instance_obs

price_na_obs <- data.frame(id = 1,
                              host_is_superhost = TRUE,
                              property_type = "House",
                              neighbourhood_cleansed = "Downtown",
                              price = NA,
                              review_scores_rating = 4.5,
                              reviews_per_month = 3,
                              accommodates = 2,
                              bedrooms = 1,
                              bathrooms = 1,
                              room_type = "Entire")

all_na_except_one_obs <- data.frame(id = 1:7,
                                    host_is_superhost = c(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE),
                                    property_type = c(NA, "House", "House", "House", "House", "House", "House"),
                                    neighbourhood_cleansed = c("Kits", "Kits", "Kits", "Kits", "Kits", "Kits", "Kits"),
                                    price = c("$75", NA, "$75", "$75", "$75", "$75", "$75"),
                                    review_scores_rating = c(4.5, 4.5, 4.5, 4.5, 4.5, 4.5, 4.5),
                                    reviews_per_month = c(1, 1, 1, 1, 1, 1, 1),
                                    accommodates = c(2, 2, NA, 2, 2, 2, 2),
                                    bedrooms = c(1, 1, 1, NA, 1, 1, 1),
                                    bathrooms = c(1, 1, 1, 1, NA, 1, 1),
                                    room_type = c("Entire", "Entire", "Entire", "Entire", "Entire", NA, "Entire"))

superhost_obs <- data.frame(id = 1:3,
                            host_is_superhost = c(TRUE, FALSE, NA),
                            property_type = c("House", "House", "House"),
                            neighbourhood_cleansed = c("Kits", "Kits", "Kits"),
                            price = c("$75", "$75", "$75"),
                            review_scores_rating = c(4.5, 4.5, 4.5),
                            reviews_per_month = c(1, 1, 1),
                            accommodates = c(2, 2, 2),
                            bedrooms = c(1, 1, 1),
                            bathrooms = c(1, 1, 1),
                            room_type = c("Entire", "Entire", "Entire"))

top_four_prop_type_obs <- data.frame(id = 1:10,
                          property_type = c("A", "A", "B", "C", "C", "D", "D", "E", "F", "F"),
                          host_is_superhost = TRUE,
                          neighbourhood_cleansed = "Downtown",
                          price = "$100",
                          accommodates = 2, 
                          bathrooms = 1, 
                          bedrooms = 1, 
                          room_type = "Entire",
                          review_scores_rating = 5, 
                          reviews_per_month = 1)

top_four_neighbour_obs <- data.frame(id = 1:10,
                                    neighbourhood_cleansed = c("N1", "N2", "N2", "N3", "N3", "N4", "N4", "N5", "N5", "N6"),
                                    property_type = "House",
                                    host_is_superhost = TRUE,
                                    price = "$100",
                                    accommodates = 2, bathrooms = 1, bedrooms = 1, room_type = "Entire",
                                    review_scores_rating = 5, reviews_per_month = 1)

# ── Expected output data frames ────────────────────────────────────
one_clean_instance_exp <- data.frame(id = "1",
                               host_is_superhost = factor("Yes", levels = c("No", "Unknown", "Yes")),
                               neighbourhood_cleansed = "Downtown",
                               property_type = factor("House", levels = c("House", "Other")),
                               room_type = "Entire",
                               accommodates = 2,
                               bathrooms = 1,
                               bedrooms = 1,
                               price = 150,
                               review_scores_rating = 4.5,
                               reviews_per_month = 3,
                               neighbourhood = factor("Downtown", levels = c("Downtown", "Other")))

zero_na_exp <- one_clean_instance_exp

price_na_exp <- data.frame(id = character(),
                           host_is_superhost = factor(levels = c("No", "Unknown", "Yes")),
                           neighbourhood_cleansed = character(),
                           property_type = factor(levels = c("Other")), # or whatever your levels are
                           room_type = character(),
                           accommodates = numeric(),
                           bathrooms = numeric(),
                           bedrooms = numeric(),
                           price = numeric(),
                           review_scores_rating = numeric(),
                           reviews_per_month = numeric(),
                           neighbourhood = factor()
)


all_na_except_one_exp <- data.frame(id = "7",
                                    host_is_superhost = factor("Yes", levels = c("No", "Unknown", "Yes")),
                                    neighbourhood_cleansed = "Kits",
                                    property_type = factor("House", levels = c("House", "Other")),
                                    room_type = "Entire",
                                    accommodates = 2,
                                    bathrooms = 1,
                                    bedrooms = 1,
                                    price = 75,
                                    review_scores_rating = 4.5,
                                    reviews_per_month = 1,
                                    neighbourhood = factor("Kits", levels = c("Kits", "Other")))

superhost_exp <- data.frame(id = c("1", "2", "3"),
                            host_is_superhost = factor(c("Yes", "No", "Unknown"), levels = c("No", "Unknown", "Yes")),
                            neighbourhood_cleansed = c("Kits", "Kits", "Kits"),
                            property_type = factor(c("House", "House", "House"), levels = c("House", "Other")),
                            room_type = c("Entire", "Entire", "Entire"), 
                            accommodates = c(2, 2, 2),
                            bathrooms = c(1, 1, 1),
                            bedrooms = c(1, 1, 1),
                            price = c(75, 75, 75),
                            review_scores_rating = c(4.5, 4.5, 4.5),
                            reviews_per_month = c(1, 1, 1),
                            neighbourhood = factor(c("Kits", "Kits", "Kits"), levels = c("Kits", "Other")))

expected_prop_type_levels <- c("A", "C", "D", "F", "Other")

expected_neighbourhood_levels <- c("N2", "N3", "N4", "N5", "Other")

