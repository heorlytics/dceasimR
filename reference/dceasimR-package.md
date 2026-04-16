# dceasimR: Distributional Cost-Effectiveness Analysis for Health Technology Assessment

Implements distributional cost-effectiveness analysis (DCEA) as
described in Cookson et al. (2020) and methods endorsed by NICE (2025).
Provides functions for aggregate and full-form DCEA, inequality
measurement, social welfare function evaluation, equity-efficiency
impact plane visualisation, and sensitivity analysis.

## Main functions

- [`run_aggregate_dcea`](https://heorlytics.github.io/dceasimR/reference/run_aggregate_dcea.md)
  — Aggregate DCEA (Love-Koh 2019)

- [`run_full_dcea`](https://heorlytics.github.io/dceasimR/reference/run_full_dcea.md)
  — Full-form DCEA with subgroup data

- [`calc_sii`](https://heorlytics.github.io/dceasimR/reference/calc_sii.md)
  /
  [`calc_rii`](https://heorlytics.github.io/dceasimR/reference/calc_rii.md)
  — Inequality indices

- [`calc_ede`](https://heorlytics.github.io/dceasimR/reference/calc_ede.md)
  — Equally Distributed Equivalent health

- [`plot_equity_impact_plane`](https://heorlytics.github.io/dceasimR/reference/plot_equity_impact_plane.md)
  — Equity-efficiency impact plane

- [`get_baseline_health`](https://heorlytics.github.io/dceasimR/reference/get_baseline_health.md)
  — Preloaded baseline distributions \#'

## Key references

Cookson R, Griffin S, Norheim OF, Culyer AJ (2020). Distributional
Cost-Effectiveness Analysis. Oxford University Press. Oxford University
Press (ISBN:9780198838197).

Love-Koh J, Asaria M, Cookson R, Griffin S (2019). The Social
Distribution of Health: Estimating Quality-Adjusted Life Expectancy in
England. Value in Health 22(5): 518-526.
[doi:10.1016/j.jval.2018.10.007](https://doi.org/10.1016/j.jval.2018.10.007)

Asaria M, Griffin S, Cookson R (2016). Distributional Cost-Effectiveness
Analysis: A Tutorial. Medical Decision Making 36(1): 8-19.
[doi:10.1177/0272989X15583266](https://doi.org/10.1177/0272989X15583266)

## See also

Useful links:

- <https://heorlytics.github.io/dceasimR/>

- Report bugs at <https://github.com/heorlytics/dceasimR/issues>

## Author

**Maintainer**: Shubhram Pandey <shubhram.pandey@heorlytics.com>
([ORCID](https://orcid.org/0009-0005-2303-1592))
