# England IMD quintile EQ-5D utility norms

Age- and IMD-stratified EQ-5D-3L utility norms for England. Useful for
assigning baseline quality of life weights in full-form DCEA.

## Usage

``` r
england_imd_qol
```

## Format

A tibble with 40 rows (5 IMD quintiles x 8 age bands) and 6 variables:

- imd_quintile:

  Integer (1-5).

- age_band:

  Character. Age band label.

- mean_eq5d_utility:

  Numeric. Mean EQ-5D-3L utility score.

- se_eq5d:

  Numeric. Standard error.

- mean_qale_remaining:

  Numeric. Quality-Adjusted Life Expectancy remaining (years).

- source:

  Character. Data source citation.

## Source

Adapted from Ara R & Brazier JE (2010) with IMD gradient adjustments
from Petrou et al. (Population Health Metrics).
