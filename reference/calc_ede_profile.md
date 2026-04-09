# Calculate EDE over a range of eta values

Evaluates
[`calc_ede`](https://heorlytics.github.io/dceasimR/reference/calc_ede.md)
across a vector of \\\eta\\ values and returns a tidy tibble. This is
the basis for EDE profile plots as described in the York DCEA handbook.

## Usage

``` r
calc_ede_profile(health_dist, pop_weights, eta_range = seq(0, 10, 0.1))
```

## Arguments

- health_dist:

  Numeric vector of health values by group.

- pop_weights:

  Numeric vector of population weights.

- eta_range:

  Numeric vector of \\\eta\\ values to evaluate (default:
  `seq(0, 10, 0.1)`).

## Value

A tibble with columns `eta` and `ede`.

## Examples

``` r
health  <- c(60, 63, 66, 69, 72)
weights <- rep(0.2, 5)
calc_ede_profile(health, weights)
#> # A tibble: 101 × 2
#>      eta   ede
#>    <dbl> <dbl>
#>  1   0    66  
#>  2   0.1  66.0
#>  3   0.2  66.0
#>  4   0.3  66.0
#>  5   0.4  65.9
#>  6   0.5  65.9
#>  7   0.6  65.9
#>  8   0.7  65.9
#>  9   0.8  65.9
#> 10   0.9  65.9
#> # ℹ 91 more rows
```
