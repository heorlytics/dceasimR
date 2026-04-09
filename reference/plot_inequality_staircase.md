# Plot Inequality Staircase

Visualises the causal pathway from intervention access to health
inequality impact across the five staircase steps: (1) disease
prevalence by group, (2) eligibility, (3) uptake/access, (4) clinical
effect, (5) opportunity cost distribution.

## Usage

``` r
plot_inequality_staircase(staircase_data, equity_var = "imd_quintile")
```

## Arguments

- staircase_data:

  Data frame with columns: `step` (integer 1-5), `step_label`
  (character), `group` (integer), `group_label` (character), `value`
  (numeric).

- equity_var:

  Equity stratification variable name (for axis label).

## Value

A ggplot2 faceted plot.

## Examples

``` r
if (FALSE) { # \dontrun{
# Requires user-supplied staircase data
plot_inequality_staircase(my_staircase_data)
} # }
```
