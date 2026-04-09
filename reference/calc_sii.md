# Calculate Slope Index of Inequality (SII)

Fits a weighted regression of health on ridit scores to estimate the
absolute health difference between the most and least deprived groups.
The SII is the regression coefficient on the ridit score, interpretable
as the total health gap across the full socioeconomic range.

## Usage

``` r
calc_sii(data, health_var, group_var, weight_var)
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

A named list with elements:

- sii:

  Slope Index of Inequality (numeric)

- rii:

  Relative Index of Inequality (numeric)

- se_sii:

  Standard error of SII

- p_value:

  p-value for SII

- model:

  The underlying `lm` object

## References

Mackenbach JP, Kunst AE (1997) Measuring the magnitude of socioeconomic
inequalities in health: an overview of available measures illustrated
with two examples from Europe. Social Science and Medicine 44(6):
757-771.
[doi:10.1016/S0277-9536(96)00073-1](https://doi.org/10.1016/S0277-9536%2896%2900073-1)

## Examples

``` r
df <- tibble::tibble(
  group      = 1:5,
  mean_hale  = c(60, 63, 66, 69, 72),
  pop_share  = rep(0.2, 5)
)
calc_sii(df, "mean_hale", "group", "pop_share")
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
```
