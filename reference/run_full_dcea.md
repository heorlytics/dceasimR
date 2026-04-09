# Run Full-Form DCEA

Implements full-form DCEA where subgroup-specific model parameters are
available (e.g., differential uptake, differential quality-of-life
gains, differential survival by socioeconomic group). Full-form DCEA is
appropriate when:

- The disease has well-documented SES gradients in clinical outcomes.

- Subgroup trial data or real-world evidence is available.

- NICE requires more granular equity evidence (HST or exceptional
  cases).

## Usage

``` r
run_full_dcea(
  subgroup_cea_results,
  baseline_health,
  wtp = 20000,
  opportunity_cost_threshold = 13000,
  uptake_by_group = NULL,
  adherence_by_group = NULL,
  comorbidity_adjustment = FALSE,
  psa_iterations = NULL
)
```

## Arguments

- subgroup_cea_results:

  Data frame with one row per equity subgroup. Required columns: `group`
  (integer), `group_label` (character), `inc_qaly` (numeric), `inc_cost`
  (numeric), `pop_share` (numeric, sums to 1).

- baseline_health:

  Tibble from
  [`get_baseline_health`](https://heorlytics.github.io/dceasimR/reference/get_baseline_health.md).

- wtp:

  Willingness-to-pay threshold in GBP/QALY (default: 20000).

- opportunity_cost_threshold:

  Cost per QALY of displaced care (default: 13000).

- uptake_by_group:

  Optional named numeric vector of uptake rates (0-1) per group. If
  `NULL`, assumes equal uptake across all groups.

- adherence_by_group:

  Optional named numeric vector of adherence rates (0-1) per group.
  Applied as a multiplier on `inc_qaly`.

- comorbidity_adjustment:

  Logical. If `TRUE`, applies an SES-based comorbidity adjustment to QoL
  gains (experimental; default: `FALSE`).

- psa_iterations:

  Optional integer. Number of PSA iterations. If provided, returns
  probabilistic NHB distribution by group.

## Value

An object of class `"full_dcea"` with elements analogous to
[`run_aggregate_dcea`](https://heorlytics.github.io/dceasimR/reference/run_aggregate_dcea.md)
plus subgroup-level detail.

## Examples

``` r
baseline <- get_baseline_health("england", "imd_quintile")
subgroup_data <- tibble::tibble(
  group       = 1:5,
  group_label = paste("IMD Q", 1:5),
  inc_qaly    = c(0.30, 0.38, 0.45, 0.52, 0.58),
  inc_cost    = c(12000, 11500, 11000, 10500, 10000),
  pop_share   = rep(0.2, 5)
)
result <- run_full_dcea(subgroup_data, baseline)
summary(result)
#> == Full-Form DCEA Result ==
#>   Net Health Benefit (equity-weighted): -0.1040 QALYs
#>   SII change: 0.5423
#>   Decision:   Lose-Lose (efficiency loss + equity loss)
#> 
#> -- Per-group results --
#> # A tibble: 5 × 5
#>   group_label inc_qaly_adj      nhb baseline_hale post_hale
#>   <chr>              <dbl>    <dbl>         <dbl>     <dbl>
#> 1 IMD Q 1             0.3  -0.3              52.1      51.5
#> 2 IMD Q 2             0.38 -0.195            56.3      55.8
#> 3 IMD Q 3             0.45 -0.1              59.8      59.4
#> 4 IMD Q 4             0.52 -0.00500          63.2      62.9
#> 5 IMD Q 5             0.58  0.0800           66.8      66.6
```
