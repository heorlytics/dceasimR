# Compute Generalised Lorenz curve data

The Generalised Lorenz Curve (GLC) scales the Lorenz curve by mean
health, making it sensitive to both inequality and average health level.

## Usage

``` r
compute_generalised_lorenz_data(
  health_dist,
  pop_weights,
  label = "Distribution"
)
```

## Arguments

- health_dist:

  Numeric vector of health values by group.

- pop_weights:

  Numeric vector of population weights.

- label:

  Optional character label for this curve.

## Value

A tibble with columns `cum_pop`, `cum_health_generalised`, and `label`.

## Examples

``` r
compute_generalised_lorenz_data(c(60, 63, 66, 69, 72), rep(0.2, 5))
#> # A tibble: 6 × 4
#>   cum_pop cum_health label        cum_health_generalised
#>     <dbl>      <dbl> <chr>                         <dbl>
#> 1     0        0     Distribution                    0  
#> 2     0.2      0.182 Distribution                   12  
#> 3     0.4      0.373 Distribution                   24.6
#> 4     0.6      0.573 Distribution                   37.8
#> 5     0.8      0.782 Distribution                   51.6
#> 6     1        1     Distribution                   66  
```
