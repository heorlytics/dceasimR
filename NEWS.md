# dceasimR 0.1.0

## Initial CRAN submission

* First release of `dceasimR` — the first comprehensive R package for
  Distributional Cost-Effectiveness Analysis (DCEA) on CRAN.

### New functions

* `run_aggregate_dcea()` — aggregate DCEA following Love-Koh et al. (2019)
* `run_full_dcea()` — full-form DCEA with subgroup-specific parameters
* `calc_sii()` / `calc_rii()` — Slope and Relative Index of Inequality
* `calc_concentration_index()` — standard, Erreygers, and Wagstaff variants
* `calc_atkinson_index()` — Atkinson inequality index
* `calc_gini()` — Gini coefficient for health distributions
* `calc_all_inequality_indices()` — calculate all indices in one call
* `calc_ede()` / `calc_ede_profile()` — Equally Distributed Equivalent health
* `calc_social_welfare()` — social welfare function analysis
* `calc_equity_weights()` / `calc_equity_weighted_nhb()` — equity weighting
* `get_baseline_health()` — preloaded baseline HALE data (England, Canada, WHO)
* `merge_cea_with_baseline()` — merge CEA output with baseline distributions
* `plot_equity_impact_plane()` — equity-efficiency impact plane visualisation
* `plot_lorenz_curve()` — Lorenz and Generalised Lorenz curves
* `plot_ede_profile()` — EDE profile across eta range
* `plot_inequality_staircase()` — causal pathway staircase visualisation
* `run_dcea_sensitivity()` — sensitivity analysis over key DCEA parameters
* `plot_dcea_tornado()` — tornado diagram for sensitivity results
* `generate_nice_table()` — NICE-formatted submission tables
* `export_dcea_excel()` — Excel export in NICE submission format
* `generate_dcea_report()` — full HTML/Word/PDF DCEA reports

### Datasets

* `england_imd_hale` — England HALE by IMD quintile (PHE/OHID)
* `england_imd_qol` — EQ-5D utility norms by IMD and age band
* `canada_income_hale` — Canada HALE by income quintile
* `who_regions_hale` — WHO regional HALE data
* `example_cea_output` — hypothetical CEA output for examples
* `nsclc_dcea_example` — NSCLC worked example from literature
