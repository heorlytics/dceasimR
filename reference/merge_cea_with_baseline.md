# Merge CEA model output with baseline health distribution

Joins a CEA result data frame (one row per equity subgroup) with a
baseline health distribution returned by
[`get_baseline_health`](https://heorlytics.github.io/dceasimR/reference/get_baseline_health.md).
This is the key data-preparation step before running DCEA.

## Usage

``` r
merge_cea_with_baseline(cea_output, baseline, by = "group")
```

## Arguments

- cea_output:

  Data frame of CEA results with at least one column matching the
  baseline `by` variable.

- baseline:

  Tibble returned by
  [`get_baseline_health`](https://heorlytics.github.io/dceasimR/reference/get_baseline_health.md).

- by:

  Column name to join on (default: `"group"`).

## Value

A merged tibble suitable for
[`run_full_dcea`](https://heorlytics.github.io/dceasimR/reference/run_full_dcea.md).

## Examples

``` r
baseline <- get_baseline_health("england", "imd_quintile")
cea_out  <- tibble::tibble(
  group    = 1:5,
  inc_qaly = c(0.3, 0.4, 0.5, 0.55, 0.6),
  inc_cost = rep(10000, 5)
)
merge_cea_with_baseline(cea_out, baseline, by = "group")
#> # A tibble: 5 × 16
#>   group inc_qaly inc_cost imd_quintile quintile_label      group_label mean_hale
#>   <int>    <dbl>    <dbl>        <int> <chr>               <chr>           <dbl>
#> 1     1     0.3     10000            1 Q1 (most deprived)  Q1 (most d…      52.1
#> 2     2     0.4     10000            2 Q2                  Q2               56.3
#> 3     3     0.5     10000            3 Q3                  Q3               59.8
#> 4     4     0.55    10000            4 Q4                  Q4               63.2
#> 5     5     0.6     10000            5 Q5 (least deprived) Q5 (least …      66.8
#> # ℹ 9 more variables: mean_hale_all <dbl>, mean_hale_male <dbl>,
#> #   mean_hale_female <dbl>, se_hale <dbl>, se_hale_all <dbl>, pop_share <dbl>,
#> #   cumulative_rank <dbl>, year <int>, source <chr>
```
