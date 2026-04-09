#' England IMD quintile Health-Adjusted Life Expectancy data
#'
#' Baseline HALE (Health-Adjusted Life Expectancy) at birth for England,
#' stratified by Index of Multiple Deprivation (IMD) quintile. Quintile 1 is
#' the most deprived; quintile 5 is the least deprived.
#'
#' @format A tibble with 5 rows and 14 variables:
#' \describe{
#'   \item{imd_quintile}{Integer (1-5). 1 = most deprived.}
#'   \item{group}{Integer (1-5). Standard group identifier (same as \code{imd_quintile}).}
#'   \item{quintile_label}{Character. Human-readable quintile label.}
#'   \item{group_label}{Character. Standard group label (same as \code{quintile_label}).}
#'   \item{mean_hale}{Numeric. HALE at birth (years), both sexes (standard name).}
#'   \item{mean_hale_all}{Numeric. HALE at birth (years), both sexes.}
#'   \item{mean_hale_male}{Numeric. HALE at birth (years), males.}
#'   \item{mean_hale_female}{Numeric. HALE at birth (years), females.}
#'   \item{se_hale}{Numeric. Standard error of \code{mean_hale} (standard name).}
#'   \item{se_hale_all}{Numeric. Standard error of \code{mean_hale_all}.}
#'   \item{pop_share}{Numeric. Proportion of population in quintile (sums to 1).}
#'   \item{cumulative_rank}{Numeric. Ridit score for concentration index.}
#'   \item{year}{Integer. Reference data year.}
#'   \item{source}{Character. Data source.}
#' }
#' @source Office for Health Inequalities and Disparities (OHID) / Public
#'   Health England Health Profiles Plus. Proxy values based on published
#'   PHE data and interpolation from peer-reviewed literature.
#' @references
#'   Love-Koh J et al. (2019). Value in Health 22(5): 518-526.
#'   \doi{10.1016/j.jval.2018.10.007}
"england_imd_hale"

#' England IMD quintile EQ-5D utility norms
#'
#' Age- and IMD-stratified EQ-5D-3L utility norms for England. Useful for
#' assigning baseline quality of life weights in full-form DCEA.
#'
#' @format A tibble with 40 rows (5 IMD quintiles x 8 age bands) and 6 variables:
#' \describe{
#'   \item{imd_quintile}{Integer (1-5).}
#'   \item{age_band}{Character. Age band label.}
#'   \item{mean_eq5d_utility}{Numeric. Mean EQ-5D-3L utility score.}
#'   \item{se_eq5d}{Numeric. Standard error.}
#'   \item{mean_qale_remaining}{Numeric. Quality-Adjusted Life Expectancy
#'     remaining (years).}
#'   \item{source}{Character. Data source citation.}
#' }
#' @source Adapted from Ara R & Brazier JE (2010) with IMD gradient
#'   adjustments from Petrou et al. (Population Health Metrics).
"england_imd_qol"

#' Canada income quintile HALE data
#'
#' Health-Adjusted Life Expectancy for Canada, stratified by household
#' income quintile. For use in Canadian DCEA analyses (CADTH workflow).
#'
#' @format A tibble with 5 rows and 9 variables analogous to
#'   \code{\link{england_imd_hale}} but with income-based stratification.
#' @source Statistics Canada, Health-Adjusted Life Expectancy by income
#'   quintile.
"canada_income_hale"

#' WHO regional HALE data
#'
#' Health-Adjusted Life Expectancy at birth for the six WHO regions.
#' Useful for international equity analyses and global burden of disease
#' perspectives.
#'
#' @format A tibble with 6 rows and 8 variables:
#' \describe{
#'   \item{who_region}{Character. WHO region code.}
#'   \item{region_label}{Character. Full region name.}
#'   \item{mean_hale}{Numeric. HALE at birth (years).}
#'   \item{se_hale}{Numeric. Standard error.}
#'   \item{pop_share}{Numeric. Proportion of world population.}
#'   \item{cumulative_rank}{Numeric. Ridit score.}
#'   \item{year}{Integer. Reference year.}
#'   \item{source}{Character. WHO GHO data citation.}
#' }
#' @source WHO Global Health Observatory. \url{https://www.who.int/data/gho}
"who_regions_hale"

#' Example CEA model output
#'
#' A hypothetical cost-effectiveness analysis output for a lung cancer
#' (NSCLC) treatment versus standard of care. Used in package examples and
#' vignettes to demonstrate DCEA functions without requiring real data.
#'
#' @format A list with two elements:
#' \describe{
#'   \item{deterministic}{A tibble with columns: \code{strategy},
#'     \code{total_qaly}, \code{total_cost}, \code{inc_qaly},
#'     \code{inc_cost}, \code{icer}, \code{nhb_at_20k}, \code{nhb_at_30k}.}
#'   \item{psa}{A data frame of 1000 PSA iterations with columns
#'     \code{inc_qaly} and \code{inc_cost}.}
#' }
#' @source Hypothetical data generated for illustration purposes only.
"example_cea_output"

#' NSCLC DCEA worked example
#'
#' A full DCEA worked example based on published literature for a
#' non-small-cell lung cancer treatment. Includes subgroup-level CEA results
#' by IMD quintile for use in full-form DCEA demonstrations.
#'
#' @format A list with elements:
#' \describe{
#'   \item{subgroup_cea}{Tibble of per-IMD-quintile CEA results.}
#'   \item{baseline}{Baseline health distribution for NSCLC population.}
#'   \item{staircase}{Staircase data for the inequality staircase plot.}
#' }
#' @source Adapted from published NSCLC DCEA literature for illustration.
"nsclc_dcea_example"
