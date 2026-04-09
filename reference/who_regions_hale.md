# WHO regional HALE data

Health-Adjusted Life Expectancy at birth for the six WHO regions. Useful
for international equity analyses and global burden of disease
perspectives.

## Usage

``` r
who_regions_hale
```

## Format

A tibble with 6 rows and 8 variables:

- who_region:

  Character. WHO region code.

- region_label:

  Character. Full region name.

- mean_hale:

  Numeric. HALE at birth (years).

- se_hale:

  Numeric. Standard error.

- pop_share:

  Numeric. Proportion of world population.

- cumulative_rank:

  Numeric. Ridit score.

- year:

  Integer. Reference year.

- source:

  Character. WHO GHO data citation.

## Source

WHO Global Health Observatory. <https://www.who.int/data/gho>
