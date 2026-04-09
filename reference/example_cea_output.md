# Example CEA model output

A hypothetical cost-effectiveness analysis output for a lung cancer
(NSCLC) treatment versus standard of care. Used in package examples and
vignettes to demonstrate DCEA functions without requiring real data.

## Usage

``` r
example_cea_output
```

## Format

A list with two elements:

- deterministic:

  A tibble with columns: `strategy`, `total_qaly`, `total_cost`,
  `inc_qaly`, `inc_cost`, `icer`, `nhb_at_20k`, `nhb_at_30k`.

- psa:

  A data frame of 1000 PSA iterations with columns `inc_qaly` and
  `inc_cost`.

## Source

Hypothetical data generated for illustration purposes only.
