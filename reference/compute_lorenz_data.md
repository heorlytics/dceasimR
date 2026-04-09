# Compute Lorenz curve data

Returns the coordinates of the Lorenz curve for a health distribution.
Groups are ordered from lowest to highest health (most to least
deprived).

## Usage

``` r
compute_lorenz_data(health_dist, pop_weights, label = "Distribution")
```

## Arguments

- health_dist:

  Numeric vector of health values by group.

- pop_weights:

  Numeric vector of population weights.

- label:

  Optional character label for this curve.

## Value

A tibble with columns `cum_pop` (cumulative population share),
`cum_health` (cumulative health share), and `label`.

## Examples

``` r
compute_lorenz_data(c(60, 63, 66, 69, 72), rep(0.2, 5))
#> # A tibble: 6 × 3
#>   cum_pop cum_health label       
#>     <dbl>      <dbl> <chr>       
#> 1     0        0     Distribution
#> 2     0.2      0.182 Distribution
#> 3     0.4      0.373 Distribution
#> 4     0.6      0.573 Distribution
#> 5     0.8      0.782 Distribution
#> 6     1        1     Distribution
```
