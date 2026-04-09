# Calculate Equity Weights

Derives equity weights from the Atkinson social welfare function. Equity
weights represent the relative social value of a one-unit health gain in
each socioeconomic group given inequality aversion \\\eta\\.

## Usage

``` r
calc_equity_weights(baseline_health, pop_weights, eta = 1, normalise = TRUE)
```

## Arguments

- baseline_health:

  Numeric vector of baseline health (HALE) by group (ordered from most
  to least deprived).

- pop_weights:

  Numeric vector of population weights.

- eta:

  Inequality aversion parameter (default = 1).

- normalise:

  Logical. If `TRUE` (default), weights are normalised so their
  population-weighted mean equals 1. If `FALSE`, returns raw marginal
  welfare derivatives.

## Value

Named numeric vector of equity weights, one per group.

## Details

For the Atkinson SWF, the equity weight for group \\i\\ is proportional
to \\h_i^{-\eta}\\: groups with lower baseline health receive higher
weights when \\\eta \> 0\\.

## References

Cookson R, Griffin S, Norheim OF, Culyer AJ (2020). Distributional
Cost-Effectiveness Analysis. Oxford University Press.
[doi:10.1093/oso/9780198838197.001.0001](https://doi.org/10.1093/oso/9780198838197.001.0001)

Robson M, Asaria M, Cookson R, Tsuchiya A, Ali S (2017). Eliciting the
Level of Health Inequality Aversion in England. Health Economics 26(10):
1328-1334. [doi:10.1002/hec.3386](https://doi.org/10.1002/hec.3386)

## Examples

``` r
baseline <- c(60, 63, 66, 69, 72)
weights  <- rep(0.2, 5)
calc_equity_weights(baseline, weights, eta = 1)
#> [1] 1.0954413 1.0432775 0.9958558 0.9525577 0.9128678
```
