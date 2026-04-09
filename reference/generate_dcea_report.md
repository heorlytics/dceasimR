# Generate a full DCEA report

Renders a complete DCEA report as an HTML, Word, or PDF document using R
Markdown.

## Usage

``` r
generate_dcea_report(
  dcea_result,
  format = "html",
  filepath = NULL,
  template = "nice_submission"
)
```

## Arguments

- dcea_result:

  Object of class `"aggregate_dcea"` or `"full_dcea"`.

- format:

  Output format: `"html"` (default), `"word"`, `"pdf"`.

- filepath:

  Output file path. If `NULL`, a temporary file is used and the report
  is opened in a browser.

- template:

  Report template: `"nice_submission"` (default), `"academic"`,
  `"cadth"`.

## Value

Invisibly returns the output file path.

## Examples

``` r
if (FALSE) { # \dontrun{
result <- run_aggregate_dcea(
  icer = 25000, inc_qaly = 0.5, inc_cost = 12500,
  population_size = 10000, wtp = 20000
)
generate_dcea_report(result, format = "html")
} # }
```
