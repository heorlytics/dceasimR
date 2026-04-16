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
staircase_df <- data.frame(
  step       = rep(1:5, each = 5),
  step_label = rep(c("Prevalence", "Eligibility", "Uptake",
                     "Clinical effect", "Opportunity cost"), each = 5),
  group      = rep(1:5, times = 5),
  group_label = rep(paste("Q", 1:5), times = 5),
  value      = c(0.30, 0.28, 0.25, 0.22, 0.18,
                 0.90, 0.88, 0.85, 0.82, 0.80,
                 0.70, 0.65, 0.60, 0.55, 0.50,
                 0.45, 0.44, 0.43, 0.42, 0.40,
                 0.20, 0.18, 0.17, 0.15, 0.12)
)
plot_inequality_staircase(staircase_df)
```
