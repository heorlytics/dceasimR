## Script: prepare_who_data.R
## Purpose: Prepare WHO regional HALE data and example CEA datasets
## Source: WHO Global Health Observatory; hypothetical CEA for examples

library(tibble)
library(usethis)

# ---- who_regions_hale -------------------------------------------------------
who_regions_hale <- tibble(
  who_region      = c("AFR", "AMR", "SEAR", "EUR", "EMR", "WPR"),
  region_label    = c("African Region", "Region of the Americas",
                      "South-East Asia Region", "European Region",
                      "Eastern Mediterranean Region",
                      "Western Pacific Region"),
  group           = 1:6,
  group_label     = c("African Region", "Region of the Americas",
                      "South-East Asia Region", "European Region",
                      "Eastern Mediterranean Region",
                      "Western Pacific Region"),
  mean_hale       = c(53.8, 66.1, 60.3, 68.9, 59.4, 68.3),
  se_hale         = c(1.2, 0.8, 0.9, 0.6, 1.0, 0.7),
  pop_share       = c(0.163, 0.130, 0.271, 0.147, 0.088, 0.201),
  cumulative_rank = c(0.082, 0.228, 0.479, 0.690, 0.832, 0.965),
  year            = 2019L,
  source          = "WHO Global Health Observatory (GHO) 2019"
)

usethis::use_data(who_regions_hale, overwrite = TRUE)

# ---- example_cea_output -----------------------------------------------------
set.seed(42)
n_psa <- 1000

example_cea_output <- list(
  deterministic = tibble(
    strategy    = c("New treatment", "Standard of care"),
    total_qaly  = c(12.45, 11.95),
    total_cost  = c(48500, 36000),
    inc_qaly    = c(0.50, NA_real_),
    inc_cost    = c(12500, NA_real_),
    icer        = c(25000, NA_real_),
    nhb_at_20k  = c(-0.125, NA_real_),
    nhb_at_30k  = c(0.083, NA_real_)
  ),
  psa = tibble(
    inc_qaly = rnorm(n_psa, mean = 0.50, sd = 0.12),
    inc_cost = rnorm(n_psa, mean = 12500, sd = 2500)
  )
)

usethis::use_data(example_cea_output, overwrite = TRUE)

# ---- nsclc_dcea_example -----------------------------------------------------
nsclc_dcea_example <- list(
  subgroup_cea = tibble(
    group        = 1:5,
    group_label  = paste("IMD Q", 1:5),
    inc_qaly     = c(0.28, 0.36, 0.44, 0.51, 0.57),
    inc_cost     = c(13200, 12800, 12400, 12000, 11600),
    pop_share    = c(0.28, 0.24, 0.20, 0.16, 0.12),
    icer         = c(13200, 12800, 12400, 12000, 11600) /
                   c(0.28, 0.36, 0.44, 0.51, 0.57)
  ),
  baseline = tibble(
    group        = 1:5,
    group_label  = paste("IMD Q", 1:5),
    mean_hale    = c(48.2, 52.1, 56.3, 59.8, 63.2),
    se_hale      = c(0.55, 0.48, 0.42, 0.38, 0.34),
    pop_share    = c(0.28, 0.24, 0.20, 0.16, 0.12),
    cumulative_rank = c(0.14, 0.40, 0.62, 0.80, 0.94),
    year         = 2019L,
    source       = "NSCLC-specific PHE estimates (illustrative)"
  ),
  staircase = tibble(
    step        = rep(1:5, each = 5),
    step_label  = rep(c("1. Prevalence", "2. Eligibility", "3. Uptake",
                        "4. Clinical effect", "5. Net benefit"), each = 5),
    group       = rep(1:5, 5),
    group_label = rep(paste("IMD Q", 1:5), 5),
    value       = c(
      c(0.08, 0.07, 0.06, 0.05, 0.04),   # prevalence
      c(0.70, 0.72, 0.74, 0.76, 0.78),   # eligibility
      c(0.58, 0.63, 0.68, 0.73, 0.77),   # uptake
      c(0.28, 0.36, 0.44, 0.51, 0.57),   # clinical effect
      c(0.15, 0.22, 0.31, 0.38, 0.45)    # net benefit
    )
  )
)

usethis::use_data(nsclc_dcea_example, overwrite = TRUE)

message("WHO, example CEA, and NSCLC data prepared and saved to data/.")
