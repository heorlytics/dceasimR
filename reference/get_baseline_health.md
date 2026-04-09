# Get baseline health distribution for a country

Returns pre-loaded HALE (Health-Adjusted Life Expectancy) data
stratified by equity subgroup for use in DCEA. Data are sourced from
ONS/OHID (England), Statistics Canada, and the WHO Global Health
Observatory.

## Usage

``` r
get_baseline_health(
  country = "england",
  equity_var = "imd_quintile",
  age_group = "all",
  sex = "all",
  year = NULL
)
```

## Arguments

- country:

  Character. One of `"england"`, `"canada"`, `"who_regions"`,
  `"scotland"`, `"wales"`.

- equity_var:

  Character. Stratification variable. Options depend on `country`:

  - England: `"imd_quintile"` (default), `"imd_decile"`

  - Canada: `"income_quintile"`

  - WHO: `"who_region"`

- age_group:

  Character. Age filter (default `"all"`).

- sex:

  Character. Sex filter: `"all"` (default), `"male"`, `"female"`.

- year:

  Integer. Data year. Uses most recent available if `NULL`.

## Value

A tibble with columns: `group`, `group_label`, `mean_hale`, `se_hale`,
`pop_share`, `cumulative_rank`, `source`, `year`.

## Examples

``` r
england_baseline <- get_baseline_health("england", "imd_quintile")
england_baseline
#> # A tibble: 5 × 14
#>   imd_quintile group quintile_label      group_label     mean_hale mean_hale_all
#>          <int> <int> <chr>               <chr>               <dbl>         <dbl>
#> 1            1     1 Q1 (most deprived)  Q1 (most depri…      52.1          52.1
#> 2            2     2 Q2                  Q2                   56.3          56.3
#> 3            3     3 Q3                  Q3                   59.8          59.8
#> 4            4     4 Q4                  Q4                   63.2          63.2
#> 5            5     5 Q5 (least deprived) Q5 (least depr…      66.8          66.8
#> # ℹ 8 more variables: mean_hale_male <dbl>, mean_hale_female <dbl>,
#> #   se_hale <dbl>, se_hale_all <dbl>, pop_share <dbl>, cumulative_rank <dbl>,
#> #   year <int>, source <chr>
```
