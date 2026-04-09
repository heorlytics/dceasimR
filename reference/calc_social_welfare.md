# Calculate Social Welfare Function value

Wraps
[`calc_ede`](https://heorlytics.github.io/dceasimR/reference/calc_ede.md)
to compute social welfare before and after an intervention and
decomposes the welfare change into efficiency and equity components.

## Usage

``` r
calc_social_welfare(baseline_health, post_health, pop_weights, eta = 1)
```

## Arguments

- baseline_health:

  Numeric vector of pre-intervention health by group.

- post_health:

  Numeric vector of post-intervention health by group.

- pop_weights:

  Numeric vector of population weights.

- eta:

  Inequality aversion parameter (default = 1).

## Value

A named list with elements:

- `ede_baseline`:

  EDE health before intervention.

- `ede_post`:

  EDE health after intervention.

- `delta_ede`:

  Change in EDE (welfare gain).

- `efficiency_component`:

  Change in mean health.

- `equity_component`:

  Change in EDE minus change in mean.

## Examples

``` r
pre  <- c(60, 63, 66, 69, 72)
post <- c(61, 64, 66.5, 69.2, 72.1)
w    <- rep(0.2, 5)
calc_social_welfare(pre, post, w, eta = 1)
#> $ede_baseline
#> [1] 65.8633
#> 
#> $ede_post
#> [1] 66.44688
#> 
#> $delta_ede
#> [1] 0.5835786
#> 
#> $efficiency_component
#> [1] 0.56
#> 
#> $equity_component
#> [1] 0.02357865
#> 
```
