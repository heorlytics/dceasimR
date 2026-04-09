# Run Aggregate DCEA

Implements the aggregate DCEA approach of Love-Koh et al. (2019) Value
in Health. Uses disease-level healthcare utilisation patterns to
distribute average health benefits from a standard CEA across
socioeconomic groups. This is the method supported by NICE (2025) as a
supplementary analysis for technology appraisals.

## Usage

``` r
run_aggregate_dcea(
  icer,
  inc_qaly,
  inc_cost,
  population_size,
  wtp = 20000,
  disease_icd = NULL,
  subgroup_distribution = NULL,
  baseline_health = NULL,
  equity_var = "imd_quintile",
  wtp_for_equity = NULL,
  opportunity_cost_threshold = 13000,
  psa_results = NULL
)
```

## Arguments

- icer:

  Incremental cost-effectiveness ratio (GBP per QALY).

- inc_qaly:

  Incremental QALYs per patient (from base-case CEA).

- inc_cost:

  Incremental cost per patient (from base-case CEA).

- population_size:

  Total eligible population size (integer).

- wtp:

  Willingness-to-pay threshold in GBP/QALY (default: 20000).

- disease_icd:

  ICD-10 code or description for HES utilisation lookup. Used to
  distribute benefits across IMD groups if `subgroup_distribution` is
  `NULL`. Example: `"C34"` for lung cancer.

- subgroup_distribution:

  Optional named numeric vector (length = number of equity subgroups)
  giving the proportion of patients in each group. Names should match
  group labels in the baseline dataset. Must sum to 1. If `NULL`,
  derived from `disease_icd` via internal lookup.

- baseline_health:

  Optional tibble from
  [`get_baseline_health`](https://heorlytics.github.io/dceasimR/reference/get_baseline_health.md).
  If `NULL`, uses England IMD quintile data.

- equity_var:

  Equity stratification variable (default: `"imd_quintile"`).

- wtp_for_equity:

  Optional second WTP threshold for equity-weighted analysis.

- opportunity_cost_threshold:

  Cost per QALY of care displaced by the intervention's budget impact
  (default: 13000, i.e., NICE's k threshold).

- psa_results:

  Optional data frame of PSA iteration results (one row per iteration,
  columns `inc_qaly` and `inc_cost`).

## Value

An object of class `"aggregate_dcea"`, a named list with:

- `summary`:

  Key scalar DCEA outputs.

- `by_group`:

  Per-group tibble: health gain, opportunity cost, NHB.

- `inequality_impact`:

  Pre/post inequality indices.

- `social_welfare`:

  Social welfare results over eta.

- `equity_plane_data`:

  Data frame for `plot_equity_impact_plane`.

- `metadata`:

  Inputs and assumptions.

## References

Love-Koh J, Asaria M, Cookson R, Griffin S (2019). The Social
Distribution of Health: Estimating Quality-Adjusted Life Expectancy in
England. Value in Health 22(5): 518-526.
[doi:10.1016/j.jval.2018.10.007](https://doi.org/10.1016/j.jval.2018.10.007)

## See also

[`plot_equity_impact_plane`](https://heorlytics.github.io/dceasimR/reference/plot_equity_impact_plane.md),
[`run_full_dcea`](https://heorlytics.github.io/dceasimR/reference/run_full_dcea.md)

## Examples

``` r
result <- run_aggregate_dcea(
  icer            = 25000,
  inc_qaly        = 0.5,
  inc_cost        = 12500,
  population_size = 10000,
  wtp             = 20000
)
summary(result)
#> == Aggregate DCEA Result ==
#>   ICER:             £25,000 / QALY
#>   Incremental QALY: 0.5000
#>   Incremental cost: £12,500
#>   Population size:  10,000
#>   Net Health Benefit: -4615.38 QALYs
#>   SII change:         -0.0000
#>   Decision:           Trade-off: equity gain, efficiency loss
#> 
#> -- Per-group results --
#> # A tibble: 5 × 4
#>   group_label         baseline_hale post_hale   nhb
#>   <chr>                       <dbl>     <dbl> <dbl>
#> 1 Q1 (most deprived)           52.1      52.0 -923.
#> 2 Q2                           56.3      56.2 -923.
#> 3 Q3                           59.8      59.7 -923.
#> 4 Q4                           63.2      63.1 -923.
#> 5 Q5 (least deprived)          66.8      66.7 -923.
#> 
#> -- Inequality impact --
#> # A tibble: 4 × 5
#>   index           pre     post    change pct_change
#>   <chr>         <dbl>    <dbl>     <dbl>      <dbl>
#> 1 sii        18.2     18.1     -4.97e-14  -2.74e-13
#> 2 rii         0.304    0.305    4.72e- 4   1.55e- 1
#> 3 gini        0.0487   0.0488   7.55e- 5   1.55e- 1
#> 4 atkinson_1  0.00374  0.00376  1.17e- 5   3.12e- 1
```
