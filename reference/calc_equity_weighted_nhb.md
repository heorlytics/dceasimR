# Calculate equity-weighted Net Health Benefit (NHB)

Applies equity weights to per-group NHB values to obtain the
population-level equity-weighted NHB. This is the key summary statistic
from the social welfare perspective.

## Usage

``` r
calc_equity_weighted_nhb(nhb_by_group, equity_weights, pop_weights)
```

## Arguments

- nhb_by_group:

  Numeric vector of net health benefit per group.

- equity_weights:

  Numeric vector of equity weights from
  [`calc_equity_weights`](https://heorlytics.github.io/dceasimR/reference/calc_equity_weights.md).

- pop_weights:

  Numeric vector of population weights.

## Value

Scalar equity-weighted NHB (numeric).

## Examples

``` r
baseline <- c(60, 63, 66, 69, 72)
weights  <- rep(0.2, 5)
ew       <- calc_equity_weights(baseline, weights, eta = 1)
nhb      <- c(100, 150, 200, 250, 300)
calc_equity_weighted_nhb(nhb, ew, weights)
#> [1] 195.4413
```
