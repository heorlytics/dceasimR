#' dceasimR: Distributional Cost-Effectiveness Analysis for Health Technology Assessment
#'
#' Implements distributional cost-effectiveness analysis (DCEA) as described in
#' Cookson et al. (2020) and methods endorsed by NICE (2025). Provides functions
#' for aggregate and full-form DCEA, inequality measurement, social welfare
#' function evaluation, equity-efficiency impact plane visualisation, and
#' sensitivity analysis.
#'
#' @section Main functions:
#' \itemize{
#'   \item \code{\link{run_aggregate_dcea}} — Aggregate DCEA (Love-Koh 2019)
#'   \item \code{\link{run_full_dcea}} — Full-form DCEA with subgroup data
#'   \item \code{\link{calc_sii}} / \code{\link{calc_rii}} — Inequality indices
#'   \item \code{\link{calc_ede}} — Equally Distributed Equivalent health
#'   \item \code{\link{plot_equity_impact_plane}} — Equity-efficiency impact plane
#'   \item \code{\link{get_baseline_health}} — Preloaded baseline distributions
#' #' }
#'
#' @section Key references:
#' Cookson R, Griffin S, Norheim OF, Culyer AJ (2020). Distributional
#' Cost-Effectiveness Analysis. Oxford University Press.
#' Oxford University Press (ISBN:9780198838197).
#'
#' Love-Koh J, Asaria M, Cookson R, Griffin S (2019). The Social Distribution
#' of Health: Estimating Quality-Adjusted Life Expectancy in England. Value in
#' Health 22(5): 518-526. \doi{10.1016/j.jval.2018.10.007}
#'
#' Asaria M, Griffin S, Cookson R (2016). Distributional Cost-Effectiveness
#' Analysis: A Tutorial. Medical Decision Making 36(1): 8-19.
#' \doi{10.1177/0272989X15583266}
#'
#' @docType package
#' @name dceasimR-package
#' @aliases dceasimR
"_PACKAGE"

# Suppress R CMD check NOTEs for rlang .data pronoun and bare column names
utils::globalVariables(c(".data", "nhb_base"))
