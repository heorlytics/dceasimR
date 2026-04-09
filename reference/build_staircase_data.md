# Build inequality staircase data from component inputs

Constructs the five-step inequality staircase data frame from individual
component vectors. The staircase traces how the distribution of health
gains is shaped at each stage: prevalence, eligibility, uptake, clinical
effect, and net opportunity cost.

## Usage

``` r
build_staircase_data(
  group,
  group_labels,
  prevalence,
  eligibility,
  uptake,
  clinical_effect,
  opportunity_cost
)
```

## Arguments

- group:

  Integer vector of group identifiers (1 = most deprived).

- group_labels:

  Character vector of group labels.

- prevalence:

  Numeric vector: disease prevalence by group (proportion).

- eligibility:

  Numeric vector: proportion eligible for the intervention by group.

- uptake:

  Numeric vector: uptake rate by group (0-1).

- clinical_effect:

  Numeric vector: incremental QALY gain by group.

- opportunity_cost:

  Numeric vector: QALYs displaced per group via budget impact.

## Value

A tibble in long format suitable for
[`plot_inequality_staircase`](https://heorlytics.github.io/dceasimR/reference/plot_inequality_staircase.md).

## Examples

``` r
build_staircase_data(
  group         = 1:5,
  group_labels  = paste("IMD Q", 1:5),
  prevalence    = c(0.08, 0.07, 0.06, 0.05, 0.04),
  eligibility   = c(0.70, 0.72, 0.74, 0.76, 0.78),
  uptake        = c(0.60, 0.64, 0.68, 0.72, 0.76),
  clinical_effect = c(0.30, 0.38, 0.45, 0.52, 0.58),
  opportunity_cost = c(0.05, 0.05, 0.05, 0.05, 0.05)
)
#> # A tibble: 25 × 5
#>     step step_label            group group_label value
#>    <int> <chr>                 <int> <chr>       <dbl>
#>  1     1 1. Disease prevalence     1 IMD Q 1      0.08
#>  2     1 1. Disease prevalence     2 IMD Q 2      0.07
#>  3     1 1. Disease prevalence     3 IMD Q 3      0.06
#>  4     1 1. Disease prevalence     4 IMD Q 4      0.05
#>  5     1 1. Disease prevalence     5 IMD Q 5      0.04
#>  6     2 2. Eligibility            1 IMD Q 1      0.7 
#>  7     2 2. Eligibility            2 IMD Q 2      0.72
#>  8     2 2. Eligibility            3 IMD Q 3      0.74
#>  9     2 2. Eligibility            4 IMD Q 4      0.76
#> 10     2 2. Eligibility            5 IMD Q 5      0.78
#> # ℹ 15 more rows
```
