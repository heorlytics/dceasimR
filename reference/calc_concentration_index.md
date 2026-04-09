# Calculate Concentration Index

Measures the degree to which a health variable is concentrated among
socioeconomically advantaged or disadvantaged groups. A negative value
indicates the health variable (e.g., illness) is concentrated among the
deprived; a positive value indicates concentration among the advantaged.

## Usage

``` r
calc_concentration_index(
  data,
  health_var,
  group_var,
  weight_var,
  rank_var = NULL,
  type = c("standard", "erreygers", "wagstaff")
)
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

- rank_var:

  Name of the socioeconomic rank variable (ridit scores, 0 = lowest, 1 =
  highest). If `NULL`, computed from `group_var` and `weight_var` using
  ridit scoring.

- type:

  Concentration index variant: `"standard"` (Kakwani), `"erreygers"`
  (bounded), or `"wagstaff"` (normalised).

## Value

A named list with `ci` (concentration index), `se`, and `type`.

## References

Erreygers G (2009). Correcting the Concentration Index. Journal of
Health Economics 28(2): 504-515.
[doi:10.1016/j.jhealeco.2008.02.003](https://doi.org/10.1016/j.jhealeco.2008.02.003)

## Examples

``` r
df <- tibble::tibble(
  group      = 1:5,
  mean_hale  = c(60, 63, 66, 69, 72),
  pop_share  = rep(0.2, 5)
)
calc_concentration_index(df, "mean_hale", "group", "pop_share")
#> $ci
#> [1] 0.03636364
#> 
#> $se
#> [1] NA
#> 
#> $type
#> [1] "standard"
#> 
```
