# Calculate all inequality indices in one call

Convenience wrapper that computes SII, RII, concentration index,
Atkinson index (for multiple \\\varepsilon\\ values), and Gini
coefficient and returns them as a tidy data frame.

## Usage

``` r
calc_all_inequality_indices(
  data,
  health_var,
  group_var,
  weight_var,
  epsilon_values = c(0.5, 1, 2)
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

- epsilon_values:

  Numeric vector of \\\varepsilon\\ values for the Atkinson index
  (default: `c(0.5, 1, 2)`).

## Value

A tibble with columns `index`, `value`, and `description`.

## Examples

``` r
df <- tibble::tibble(
  group      = 1:5,
  mean_hale  = c(60, 63, 66, 69, 72),
  pop_share  = rep(0.2, 5)
)
calc_all_inequality_indices(df, "mean_hale", "group", "pop_share")
#> Warning: essentially perfect fit: summary may be unreliable
#> # A tibble: 7 × 3
#>   index                   value description                   
#>   <chr>                   <dbl> <chr>                         
#> 1 sii                  15       Slope Index of Inequality     
#> 2 rii                   0.227   Relative Index of Inequality  
#> 3 concentration_index   0.0364  Concentration Index (standard)
#> 4 gini                  0.0364  Gini coefficient              
#> 5 atkinson_epsilon_0.5  0.00104 Atkinson index (epsilon = 0.5)
#> 6 atkinson_epsilon_1    0.00207 Atkinson index (epsilon = 1)  
#> 7 atkinson_epsilon_2    0.00414 Atkinson index (epsilon = 2)  
```
