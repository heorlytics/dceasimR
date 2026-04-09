# Equity weights over a range of eta values

Convenience function that returns equity weights for each group across a
range of \\\eta\\ values. Useful for understanding how the choice of
inequality aversion changes the implied weights.

## Usage

``` r
calc_equity_weight_profile(
  baseline_health,
  pop_weights,
  eta_range,
  group_labels = NULL
)
```

## Arguments

- baseline_health:

  Numeric vector of baseline health by group.

- pop_weights:

  Numeric vector of population weights.

- eta_range:

  Numeric vector of \\\eta\\ values.

- group_labels:

  Optional character vector of group labels.

## Value

A tidy tibble with columns `eta`, `group`, `group_label` (if provided),
and `equity_weight`.

## Examples

``` r
baseline <- c(60, 63, 66, 69, 72)
weights  <- rep(0.2, 5)
calc_equity_weight_profile(baseline, weights, eta_range = 0:5)
#> # A tibble: 30 × 4
#>      eta group group_label equity_weight
#>    <int> <int> <chr>               <dbl>
#>  1     0     1 Group 1             1    
#>  2     0     2 Group 2             1    
#>  3     0     3 Group 3             1    
#>  4     0     4 Group 4             1    
#>  5     0     5 Group 5             1    
#>  6     1     1 Group 1             1.10 
#>  7     1     2 Group 2             1.04 
#>  8     1     3 Group 3             0.996
#>  9     1     4 Group 4             0.953
#> 10     1     5 Group 5             0.913
#> # ℹ 20 more rows
```
