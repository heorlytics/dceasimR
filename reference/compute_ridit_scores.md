# Compute ridit scores (cumulative midpoint ranks) for inequality measures

Ridit scores are used as the socioeconomic rank variable in
concentration index calculations. For group \\i\\, the ridit is the
cumulative population share up to the midpoint of group \\i\\.

## Usage

``` r
compute_ridit_scores(pop_shares)
```

## Arguments

- pop_shares:

  Numeric vector of population proportions (ordered from most to least
  deprived, sums to 1).

## Value

Numeric vector of ridit scores in \[0, 1\].

## Examples

``` r
compute_ridit_scores(rep(0.2, 5))
#> [1] 0.1 0.3 0.5 0.7 0.9
```
