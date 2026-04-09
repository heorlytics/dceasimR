# Run DCEA Sensitivity Analysis

Performs systematic one-way and multi-way sensitivity analysis across
key DCEA parameters: inequality aversion (\\\eta\\), WTP threshold,
opportunity cost threshold, subgroup distribution assumptions, and
equity measure choice.

## Usage

``` r
run_dcea_sensitivity(
  dcea_result,
  params_to_vary = "all",
  eta_range = 0:10,
  wtp_range = NULL,
  occ_range = NULL
)
```

## Arguments

- dcea_result:

  Object of class `"aggregate_dcea"` or `"full_dcea"`.

- params_to_vary:

  Character vector of parameter names to vary. Options: `"eta"`,
  `"wtp"`, `"occ_threshold"`, `"subgroup_distribution"`,
  `"equity_measure"`, `"all"` (default: `"all"`).

- eta_range:

  Numeric vector of \\\eta\\ values for eta sensitivity (default:
  `0:10`).

- wtp_range:

  Numeric vector of WTP values to test (default: varies ±50% around base
  case).

- occ_range:

  Numeric vector of opportunity cost threshold values (default:
  `c(8000, 10000, 13000, 15000, 20000)`).

## Value

An object of class `"dcea_sensitivity"` with elements:

- `eta_profile`:

  Tibble: NHB and SII change across eta range.

- `one_way`:

  Tibble: results of one-way sensitivity for all parameters.

- `tornado_data`:

  Data frame ready for tornado plot.

- `parameters`:

  List of parameter ranges used.

## Examples

``` r
result <- run_aggregate_dcea(
  icer = 25000, inc_qaly = 0.5, inc_cost = 12500,
  population_size = 10000, wtp = 20000
)
sa <- run_dcea_sensitivity(result, params_to_vary = "eta")
plot_dcea_tornado(sa)
#> Warning: No tornado data available. Run with params_to_vary including 'wtp' or 'occ_threshold'.
```
