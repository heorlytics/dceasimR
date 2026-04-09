# Export DCEA results to Excel (NICE submission format)

Writes a multi-sheet Excel workbook with NICE-formatted DCEA output,
including the summary table, per-group results, inequality indices, and
social welfare profile.

## Usage

``` r
export_dcea_excel(dcea_result, filepath, include_plots = FALSE)
```

## Arguments

- dcea_result:

  Object of class `"aggregate_dcea"` or `"full_dcea"`.

- filepath:

  Output `.xlsx` file path (character).

- include_plots:

  Logical. Embed plots as images in the Excel workbook (default:
  `FALSE`).

## Value

Invisibly returns `filepath`.

## Examples

``` r
if (FALSE) { # \dontrun{
result <- run_aggregate_dcea(
  icer = 25000, inc_qaly = 0.5, inc_cost = 12500,
  population_size = 10000, wtp = 20000
)
export_dcea_excel(result, "my_dcea_results.xlsx")
} # }
```
