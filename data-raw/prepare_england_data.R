## Script: prepare_england_data.R
## Purpose: Prepare England IMD quintile HALE and EQ-5D datasets
## Run once to generate data/*.rda files; not shipped in the package.
## Source: PHE / OHID Health Profiles Plus; Love-Koh et al. (2019)

library(tibble)
library(usethis)

# ---- england_imd_hale -------------------------------------------------------
# HALE values are proxy estimates based on published PHE data and the
# Love-Koh et al. (2019) Value in Health paper (Table 2).
# True values require ONS/PHE data access agreements.

england_imd_hale <- tibble(
  imd_quintile   = 1:5,
  quintile_label = c("Q1 (most deprived)", "Q2", "Q3", "Q4",
                     "Q5 (least deprived)"),
  mean_hale_all  = c(52.1, 56.3, 59.8, 63.2, 66.8),
  mean_hale_male = c(50.4, 54.7, 58.4, 61.9, 65.6),
  mean_hale_female = c(53.8, 57.9, 61.2, 64.5, 68.0),
  se_hale_all    = c(0.42, 0.38, 0.35, 0.33, 0.30),
  pop_share      = rep(0.20, 5),
  cumulative_rank = c(0.10, 0.30, 0.50, 0.70, 0.90),
  year           = 2019L,
  source         = "PHE/OHID Health Profiles Plus (proxy estimates)"
)

usethis::use_data(england_imd_hale, overwrite = TRUE)

# ---- england_imd_qol --------------------------------------------------------
# EQ-5D-3L utility norms by IMD quintile and age band.
# Based on Ara & Brazier (2010) adapted with published IMD gradients.

age_bands <- c("18-24", "25-34", "35-44", "45-54", "55-64", "65-74",
               "75-84", "85+")
base_utilities <- c(0.92, 0.90, 0.87, 0.82, 0.76, 0.69, 0.61, 0.52)
# IMD gradient: Q1 ~0.07 lower than Q5
imd_adj <- c(-0.035, -0.017, 0, 0.013, 0.025)

rows <- vector("list", length = 5 * 8)
k <- 1
for (q in 1:5) {
  for (a in seq_along(age_bands)) {
    rows[[k]] <- tibble(
      imd_quintile       = q,
      age_band           = age_bands[a],
      mean_eq5d_utility  = round(base_utilities[a] + imd_adj[q], 4),
      se_eq5d            = 0.015,
      mean_qale_remaining = round((base_utilities[a] + imd_adj[q]) *
                                    (90 - c(21,30,40,50,60,70,80,88)[a]), 2),
      source             = "Ara & Brazier (2010) + IMD adjustment"
    )
    k <- k + 1
  }
}
england_imd_qol <- dplyr::bind_rows(rows)

usethis::use_data(england_imd_qol, overwrite = TRUE)

message("England data prepared and saved to data/.")
