# Prepare subgroup CEA data for DCEA

Validates and standardises a data frame of subgroup-specific CEA results
for use in
[`run_full_dcea`](https://heorlytics.github.io/dceasimR/reference/run_full_dcea.md).

## Usage

``` r
prepare_subgroup_cea(
  data,
  group_var,
  inc_qaly_var,
  inc_cost_var,
  pop_share_var
)
```

## Arguments

- data:

  Data frame with per-subgroup CEA results.

- group_var:

  Name of the group identifier column.

- inc_qaly_var:

  Name of the incremental QALY column.

- inc_cost_var:

  Name of the incremental cost column.

- pop_share_var:

  Name of the population share column.

## Value

A validated and normalised tibble.

## Examples

``` r
df <- tibble::tibble(
  group     = 1:5,
  inc_qaly  = c(0.3, 0.4, 0.5, 0.55, 0.6),
  inc_cost  = rep(10000, 5),
  pop_share = rep(0.2, 5)
)
prepare_subgroup_cea(df, "group", "inc_qaly", "inc_cost", "pop_share")
#> # A tibble: 5 × 5
#>   group inc_qaly inc_cost pop_share   icer
#>   <int>    <dbl>    <dbl>     <dbl>  <dbl>
#> 1     1     0.3     10000       0.2 33333.
#> 2     2     0.4     10000       0.2 25000 
#> 3     3     0.5     10000       0.2 20000 
#> 4     4     0.55    10000       0.2 18182.
#> 5     5     0.6     10000       0.2 16667.
```
