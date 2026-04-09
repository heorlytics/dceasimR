# Calculate Equally Distributed Equivalent Health (EDE)

Uses the Atkinson social welfare function to calculate EDE health — the
level of health that, if equally distributed, would generate the same
social welfare as the actual distribution given inequality aversion
parameter \\\eta\\.

## Usage

``` r
calc_ede(health_dist, pop_weights, eta = 1)
```

## Arguments

- health_dist:

  Numeric vector of health values by group (must be strictly positive).

- pop_weights:

  Numeric vector of population weights (will be normalised to sum to 1).

- eta:

  Inequality aversion parameter (numeric scalar, default = 1).

  - \\\eta = 0\\: returns arithmetic mean (no inequality aversion).

  - \\\eta = 1\\: returns geometric mean (moderate aversion).

  - \\\eta \> 1\\: increasing inequality aversion.

  - NICE relevant range: 0 to 10.

## Value

EDE health value (numeric scalar). Returns `NA` with a warning if any
health values are non-positive.

## Details

\$\$ \text{EDE}(\eta) = \left(\sum_i w_i h_i^{1-\eta} \big/ \sum_i
w_i\right)^{1/(1-\eta)} \quad \text{for } \eta \neq 1 \$\$ \$\$
\text{EDE}(1) = \exp\\\left(\sum_i w_i \ln(h_i)\right) \quad
\text{(geometric mean, } \eta = 1\text{)} \$\$

## References

Atkinson AB (1970). On the Measurement of Inequality. Journal of
Economic Theory 2(3): 244-263.
[doi:10.1016/0022-0531(70)90039-6](https://doi.org/10.1016/0022-0531%2870%2990039-6)

## Examples

``` r
health  <- c(60, 63, 66, 69, 72)
weights <- rep(0.2, 5)

# eta = 0: arithmetic mean
calc_ede(health, weights, eta = 0)
#> [1] 66

# eta = 1: geometric mean
calc_ede(health, weights, eta = 1)
#> [1] 65.8633

# eta = 5: high inequality aversion
calc_ede(health, weights, eta = 5)
#> [1] 65.31903
```
