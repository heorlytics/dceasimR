## Script: prepare_canada_data.R
## Purpose: Prepare Canada income quintile HALE dataset
## Source: Statistics Canada, Health-Adjusted Life Expectancy by income quintile

library(tibble)
library(usethis)

# ---- canada_income_hale -----------------------------------------------------
# Proxy estimates based on Statistics Canada published tables.
# Income quintile 1 = lowest; 5 = highest.

canada_income_hale <- tibble(
  income_quintile = 1:5,
  group           = 1:5,
  quintile_label  = c("Q1 (lowest income)", "Q2", "Q3", "Q4",
                      "Q5 (highest income)"),
  group_label     = c("Q1 (lowest income)", "Q2", "Q3", "Q4",
                      "Q5 (highest income)"),
  mean_hale       = c(62.4, 65.1, 67.3, 69.4, 71.8),
  mean_hale_male  = c(60.8, 63.6, 65.9, 68.1, 70.5),
  mean_hale_female = c(64.0, 66.6, 68.7, 70.7, 73.1),
  se_hale         = c(0.38, 0.34, 0.31, 0.29, 0.27),
  pop_share       = rep(0.20, 5),
  cumulative_rank = c(0.10, 0.30, 0.50, 0.70, 0.90),
  year            = 2019L,
  source          = "Statistics Canada HALE by income quintile (proxy estimates)"
)

usethis::use_data(canada_income_hale, overwrite = TRUE)

message("Canada data prepared and saved to data/.")
