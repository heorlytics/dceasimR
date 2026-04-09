# Plot method for aggregate_dcea

Dispatches to
[`plot_equity_impact_plane`](https://heorlytics.github.io/dceasimR/reference/plot_equity_impact_plane.md)
by default.

## Usage

``` r
# S3 method for class 'aggregate_dcea'
plot(x, type = "impact_plane", ...)
```

## Arguments

- x:

  An object of class `"aggregate_dcea"`.

- type:

  Plot type: `"impact_plane"` (default), `"lorenz"`, or `"ede_profile"`.

- ...:

  Additional arguments passed to the underlying plot function.

## Value

A ggplot2 object.
