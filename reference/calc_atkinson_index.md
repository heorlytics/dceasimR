# Calculate Atkinson Index of Health Inequality

The Atkinson index measures the extent of inequality in the health
distribution, explicitly incorporating a parameter \\\varepsilon\\
representing inequality aversion. Higher \\\varepsilon\\ values give
more weight to health differences at the bottom of the distribution.

## Usage

``` r
calc_atkinson_index(health_dist, pop_weights, epsilon = 1)
```

## Arguments

- health_dist:

  Numeric vector of health values across population groups.

- pop_weights:

  Numeric vector of population weights (need not sum to 1; will be
  normalised internally).

- epsilon:

  Inequality aversion parameter (default = 1). Must be non-negative.
  When \\\varepsilon = 0\\, returns 0 (no aversion).

## Value

Atkinson index value in \[0, 1\]. A value of 0 indicates perfect
equality; a value approaching 1 indicates maximum inequality.

## References

Atkinson AB (1970). On the Measurement of Inequality. Journal of
Economic Theory 2(3): 244-263.
[doi:10.1016/0022-0531(70)90039-6](https://doi.org/10.1016/0022-0531%2870%2990039-6)

## Examples

``` r
# Perfect equality
calc_atkinson_index(rep(70, 5), rep(0.2, 5), epsilon = 1)
#> [1] -4.440892e-16

# Gradient across groups
calc_atkinson_index(c(60, 63, 66, 69, 72), rep(0.2, 5), epsilon = 1)
#> [1] 0.002071263
```
