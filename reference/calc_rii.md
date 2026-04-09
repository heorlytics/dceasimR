# Calculate Relative Index of Inequality (RII)

The RII is the SII expressed relative to the mean health level. An RII
of 0.20 means the most deprived group has health 20 across the full
socioeconomic range.

## Usage

``` r
calc_rii(data, health_var, group_var, weight_var)
```

## Arguments

- data:

  A data frame with health and group columns.

- health_var:

  Name of the health variable column (character).

- group_var:

  Name of the socioeconomic group column (ordered integer, 1 = most
  deprived).

- weight_var:

  Name of the population share column (sums to 1).

## Value

A named list with elements `rii`, `sii`, `se_rii`, `p_value`, and
`model`.

## Examples

``` r
df <- tibble::tibble(
  group      = 1:5,
  mean_hale  = c(60, 63, 66, 69, 72),
  pop_share  = rep(0.2, 5)
)
calc_rii(df, "mean_hale", "group", "pop_share")
#> Warning: essentially perfect fit: summary may be unreliable
#> $sii
#> [1] 15
#> 
#> $rii
#> [1] 0.2272727
#> 
#> $se_sii
#> [1] 1.868784e-15
#> 
#> $p_value
#> [1] 4.264559e-48
#> 
#> $model
#> 
#> Call:
#> stats::lm(formula = h ~ ridit, weights = w)
#> 
#> Coefficients:
#> (Intercept)        ridit  
#>        58.5         15.0  
#> 
#> 
#> $se_rii
#> [1] 2.831491e-17
#> 
```
