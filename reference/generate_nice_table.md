# Generate NICE-formatted DCEA submission table

Creates a summary table formatted according to NICE (2025) Methods
Support Document guidance for DCEA as supplementary evidence in
technology appraisals.

## Usage

``` r
generate_nice_table(dcea_result, format = "tibble", include_psa = FALSE)
```

## Arguments

- dcea_result:

  Object of class `"aggregate_dcea"` or `"full_dcea"`.

- format:

  Output format: `"tibble"` (default), `"flextable"`, `"html"`, or
  `"xlsx"`.

- include_psa:

  Logical. Include probabilistic uncertainty columns if PSA data are
  available (default: `FALSE`).

## Value

A formatted table object of the requested type.

## Examples

``` r
result <- run_aggregate_dcea(
  icer = 25000, inc_qaly = 0.5, inc_cost = 12500,
  population_size = 10000, wtp = 20000
)
generate_nice_table(result, format = "tibble")
#> # A tibble: 6 × 6
#>   `Equity subgroup`   `Baseline HALE (years)` `Post-intervention HALE (years)`
#>   <chr>                                 <dbl>                            <dbl>
#> 1 Q1 (most deprived)                     52.1                             52.0
#> 2 Q2                                     56.3                             56.2
#> 3 Q3                                     59.8                             59.7
#> 4 Q4                                     63.2                             63.1
#> 5 Q5 (least deprived)                    66.8                             66.7
#> 6 Total / Summary                        NA                               NA  
#> # ℹ 3 more variables: `Change in HALE (years)` <dbl>,
#> #   `Net Health Benefit (QALYs)` <dbl>, `Population share` <chr>
```
