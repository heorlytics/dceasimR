# Validate and format DCEA input data

Checks that a data frame has required columns, correct types, and that
population weights sum to 1. Returns the data frame invisibly if valid,
or throws an informative error.

## Usage

``` r
validate_dcea_data(data, required_cols, weight_var, tol = 1e-06)
```

## Arguments

- data:

  A data frame to validate.

- required_cols:

  Character vector of required column names.

- weight_var:

  Name of the population weight column.

- tol:

  Tolerance for checking that weights sum to 1 (default: 1e-6).

## Value

The input data frame, invisibly.

## Examples

``` r
df <- tibble::tibble(
  group      = 1:5,
  mean_hale  = c(60, 63, 66, 69, 72),
  pop_share  = rep(0.2, 5)
)
validate_dcea_data(df, c("group", "mean_hale", "pop_share"), "pop_share")
```
