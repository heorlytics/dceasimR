# dceasimR <img src="pkgdown/assets/logo.png" align="right" height="120" alt="dceasimR logo"/>

<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version/dceasimR)](https://CRAN.R-project.org/package=dceasimR)
[![R-CMD-check](https://github.com/heorlytics/dceasimR/actions/workflows/R-CMD-check.yml/badge.svg)](https://github.com/heorlytics/dceasimR/actions/workflows/R-CMD-check.yml)
[![Codecov test coverage](https://codecov.io/gh/heorlytics/dceasimR/branch/main/graph/badge.svg)](https://app.codecov.io/gh/heorlytics/dceasimR?branch=main)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

**The first comprehensive R package for Distributional Cost-Effectiveness
Analysis (DCEA)** — implementing methods endorsed by NICE (2025) and described
in Cookson et al. (2020).

## Overview

Standard cost-effectiveness analysis treats a QALY gained by the most deprived
patient as equivalent to a QALY gained by the least deprived. DCEA breaks this
assumption by distributing health gains across socioeconomic groups,
measuring inequality impact, and applying social welfare function weights.

`dceasimR` provides:

- **Aggregate DCEA** (Love-Koh et al. 2019) — the NICE-endorsed default method
- **Full-form DCEA** — for subgroup-specific evidence
- **Inequality indices** — SII, RII, concentration index, Atkinson, Gini
- **Social welfare functions** — EDE health, equity weights, welfare decomposition
- **Visualisation** — equity-efficiency impact plane, Lorenz curves, EDE profiles
- **Preloaded data** — England (IMD quintile), Canada (income quintile), WHO regions
- **NICE-formatted export** — tables, Excel workbooks, HTML reports

## NICE 2025 compliance

`dceasimR` implements the DCEA methods described in NICE's modular update to
PMG36 (*Technology Evaluation Methods: Health Inequalities*, 2025). The
aggregate DCEA approach follows Love-Koh et al. (2019) Value in Health.

## Installation

```r
# CRAN (once available)
install.packages("dceasimR")

# Development version from GitHub
# install.packages("remotes")
remotes::install_github("heorlytics/dceasimR")
```

## Quick start

```r
library(dceasimR)

# Run aggregate DCEA for a hypothetical NSCLC treatment (NICE TA style)
result <- run_aggregate_dcea(
  icer            = 28000,
  inc_qaly        = 0.45,
  inc_cost        = 12600,
  population_size = 12000,
  disease_icd     = "C34",   # Lung cancer -> uses internal HES utilisation data
  wtp             = 20000,
  opportunity_cost_threshold = 13000
)

# View summary
summary(result)

# Plot equity-efficiency impact plane
plot_equity_impact_plane(result)

# Sensitivity over inequality aversion
plot_ede_profile(result, eta_range = seq(0, 10, 0.1))

# Export NICE-formatted table
generate_nice_table(result, format = "flextable")

```

## Documentation

Full documentation and tutorials are available at
**<https://heorlytics.github.io/dceasimR/>**

## Citation

If you use `dceasimR` in published research, please cite:

```r
citation("dceasimR")
```

```
Pandey S (2026). dceasimR: Distributional Cost-Effectiveness Analysis
for Health Technology Assessment. R package version 0.1.0.
https://heorlytics.github.io/dceasimR/
```

## Key references

> Cookson R, Griffin S, Norheim OF, Culyer AJ (2020). *Distributional
> Cost-Effectiveness Analysis: Quantifying Health Equity Impacts and Trade-Offs.*
> Oxford University Press (ISBN:9780198838197).

> Love-Koh J, Asaria M, Cookson R, Griffin S (2019). The Social Distribution
> of Health: Estimating Quality-Adjusted Life Expectancy in England. *Value in
> Health* 22(5): 518-526. <https://doi.org/10.1016/j.jval.2018.10.007>

> Asaria M, Griffin S, Cookson R (2016). Distributional Cost-Effectiveness
> Analysis: A Tutorial. *Medical Decision Making* 36(1): 8-19.
> <https://doi.org/10.1177/0272989X15583266>

> NICE (2025). *Technology Evaluation Methods: Health Inequalities* (PMG36).
> National Institute for Health and Care Excellence, London.

> Robson M, Asaria M, Cookson R, Tsuchiya A, Ali S (2017). Eliciting the Level
> of Health Inequality Aversion in England. *Health Economics* 26(10): 1328-1334.
> <https://doi.org/10.1002/hec.3386>

## Contributing

Contributions are welcome! Please see
[CONTRIBUTING.md](https://github.com/heorlytics/dceasimR/blob/main/CONTRIBUTING.md)
and file issues at
<https://github.com/heorlytics/dceasimR/issues>.
