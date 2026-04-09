# England IMD quintile Health-Adjusted Life Expectancy data

Baseline HALE (Health-Adjusted Life Expectancy) at birth for England,
stratified by Index of Multiple Deprivation (IMD) quintile. Quintile 1
is the most deprived; quintile 5 is the least deprived.

## Usage

``` r
england_imd_hale
```

## Format

A tibble with 5 rows and 14 variables:

- imd_quintile:

  Integer (1-5). 1 = most deprived.

- group:

  Integer (1-5). Standard group identifier (same as `imd_quintile`).

- quintile_label:

  Character. Human-readable quintile label.

- group_label:

  Character. Standard group label (same as `quintile_label`).

- mean_hale:

  Numeric. HALE at birth (years), both sexes (standard name).

- mean_hale_all:

  Numeric. HALE at birth (years), both sexes.

- mean_hale_male:

  Numeric. HALE at birth (years), males.

- mean_hale_female:

  Numeric. HALE at birth (years), females.

- se_hale:

  Numeric. Standard error of `mean_hale` (standard name).

- se_hale_all:

  Numeric. Standard error of `mean_hale_all`.

- pop_share:

  Numeric. Proportion of population in quintile (sums to 1).

- cumulative_rank:

  Numeric. Ridit score for concentration index.

- year:

  Integer. Reference data year.

- source:

  Character. Data source.

## Source

Office for Health Inequalities and Disparities (OHID) / Public Health
England Health Profiles Plus. Proxy values based on published PHE data
and interpolation from peer-reviewed literature.

## References

Love-Koh J et al. (2019). Value in Health 22(5): 518-526.
[doi:10.1016/j.jval.2018.10.007](https://doi.org/10.1016/j.jval.2018.10.007)
