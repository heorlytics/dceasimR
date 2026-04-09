# Calculate Gini Coefficient for Health Distribution

Computes the Gini coefficient as a measure of health inequality across
socioeconomic groups. The Gini ranges from 0 (perfect equality) to 1
(maximum inequality).

## Usage

``` r
calc_gini(health_dist, pop_weights = NULL)
```

## Arguments

- health_dist:

  Numeric vector of health values (ordered from lowest to highest
  group).

- pop_weights:

  Optional numeric vector of population weights. If `NULL`, equal
  weights are assumed.

## Value

Gini coefficient (numeric scalar in \[0, 1\]).

## Examples

``` r
calc_gini(c(60, 63, 66, 69, 72), pop_weights = rep(0.2, 5))
#> [1] 0.03636364
```
