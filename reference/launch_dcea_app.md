# Launch the interactive DCEA Shiny Application

Opens a browser-based graphical interface for performing DCEA without
writing R code. The app provides panels for CEA input, equity setup,
results visualisation, sensitivity analysis, and export. Suitable for
manufacturers preparing NICE submissions or analysts exploring equity
impacts interactively.

## Usage

``` r
launch_dcea_app(browser = TRUE, port = NULL)
```

## Arguments

- browser:

  Logical. Open the app in the default browser (default: `TRUE`).

- port:

  Integer. Local port to use. If `NULL` (default), a randomly available
  port is used.

## Value

Invisible `NULL`. The function blocks until the Shiny app is stopped.

## Examples

``` r
if (FALSE) { # \dontrun{
  launch_dcea_app()
} # }
```
