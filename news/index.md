# Changelog

## dceasimR 0.1.0

### Initial CRAN submission

- First release of `dceasimR` — the first comprehensive R package for
  Distributional Cost-Effectiveness Analysis (DCEA) on CRAN.

#### New functions

- [`run_aggregate_dcea()`](https://heorlytics.github.io/dceasimR/reference/run_aggregate_dcea.md)
  — aggregate DCEA following Love-Koh et al. (2019)
- [`run_full_dcea()`](https://heorlytics.github.io/dceasimR/reference/run_full_dcea.md)
  — full-form DCEA with subgroup-specific parameters
- [`calc_sii()`](https://heorlytics.github.io/dceasimR/reference/calc_sii.md)
  /
  [`calc_rii()`](https://heorlytics.github.io/dceasimR/reference/calc_rii.md)
  — Slope and Relative Index of Inequality
- [`calc_concentration_index()`](https://heorlytics.github.io/dceasimR/reference/calc_concentration_index.md)
  — standard, Erreygers, and Wagstaff variants
- [`calc_atkinson_index()`](https://heorlytics.github.io/dceasimR/reference/calc_atkinson_index.md)
  — Atkinson inequality index
- [`calc_gini()`](https://heorlytics.github.io/dceasimR/reference/calc_gini.md)
  — Gini coefficient for health distributions
- [`calc_all_inequality_indices()`](https://heorlytics.github.io/dceasimR/reference/calc_all_inequality_indices.md)
  — calculate all indices in one call
- [`calc_ede()`](https://heorlytics.github.io/dceasimR/reference/calc_ede.md)
  /
  [`calc_ede_profile()`](https://heorlytics.github.io/dceasimR/reference/calc_ede_profile.md)
  — Equally Distributed Equivalent health
- [`calc_social_welfare()`](https://heorlytics.github.io/dceasimR/reference/calc_social_welfare.md)
  — social welfare function analysis
- [`calc_equity_weights()`](https://heorlytics.github.io/dceasimR/reference/calc_equity_weights.md)
  /
  [`calc_equity_weighted_nhb()`](https://heorlytics.github.io/dceasimR/reference/calc_equity_weighted_nhb.md)
  — equity weighting
- [`get_baseline_health()`](https://heorlytics.github.io/dceasimR/reference/get_baseline_health.md)
  — preloaded baseline HALE data (England, Canada, WHO)
- [`merge_cea_with_baseline()`](https://heorlytics.github.io/dceasimR/reference/merge_cea_with_baseline.md)
  — merge CEA output with baseline distributions
- [`plot_equity_impact_plane()`](https://heorlytics.github.io/dceasimR/reference/plot_equity_impact_plane.md)
  — equity-efficiency impact plane visualisation
- [`plot_lorenz_curve()`](https://heorlytics.github.io/dceasimR/reference/plot_lorenz_curve.md)
  — Lorenz and Generalised Lorenz curves
- [`plot_ede_profile()`](https://heorlytics.github.io/dceasimR/reference/plot_ede_profile.md)
  — EDE profile across eta range
- [`plot_inequality_staircase()`](https://heorlytics.github.io/dceasimR/reference/plot_inequality_staircase.md)
  — causal pathway staircase visualisation
- [`run_dcea_sensitivity()`](https://heorlytics.github.io/dceasimR/reference/run_dcea_sensitivity.md)
  — sensitivity analysis over key DCEA parameters
- [`plot_dcea_tornado()`](https://heorlytics.github.io/dceasimR/reference/plot_dcea_tornado.md)
  — tornado diagram for sensitivity results
- [`generate_nice_table()`](https://heorlytics.github.io/dceasimR/reference/generate_nice_table.md)
  — NICE-formatted submission tables
- [`export_dcea_excel()`](https://heorlytics.github.io/dceasimR/reference/export_dcea_excel.md)
  — Excel export in NICE submission format
- [`generate_dcea_report()`](https://heorlytics.github.io/dceasimR/reference/generate_dcea_report.md)
  — full HTML/Word/PDF DCEA reports

#### Datasets

- `england_imd_hale` — England HALE by IMD quintile (PHE/OHID)
- `england_imd_qol` — EQ-5D utility norms by IMD and age band
- `canada_income_hale` — Canada HALE by income quintile
- `who_regions_hale` — WHO regional HALE data
- `example_cea_output` — hypothetical CEA output for examples
- `nsclc_dcea_example` — NSCLC worked example from literature
