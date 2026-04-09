#' Get baseline health distribution for a country
#'
#' Returns pre-loaded HALE (Health-Adjusted Life Expectancy) data stratified
#' by equity subgroup for use in DCEA. Data are sourced from ONS/OHID
#' (England), Statistics Canada, and the WHO Global Health Observatory.
#'
#' @param country Character. One of \code{"england"}, \code{"canada"},
#'   \code{"who_regions"}, \code{"scotland"}, \code{"wales"}.
#' @param equity_var Character. Stratification variable. Options depend on
#'   \code{country}:
#'   \itemize{
#'     \item England: \code{"imd_quintile"} (default), \code{"imd_decile"}
#'     \item Canada: \code{"income_quintile"}
#'     \item WHO: \code{"who_region"}
#'   }
#' @param age_group Character. Age filter (default \code{"all"}).
#' @param sex Character. Sex filter: \code{"all"} (default), \code{"male"},
#'   \code{"female"}.
#' @param year Integer. Data year. Uses most recent available if \code{NULL}.
#'
#' @return A tibble with columns: \code{group}, \code{group_label},
#'   \code{mean_hale}, \code{se_hale}, \code{pop_share},
#'   \code{cumulative_rank}, \code{source}, \code{year}.
#' @export
#'
#' @examples
#' england_baseline <- get_baseline_health("england", "imd_quintile")
#' england_baseline
get_baseline_health <- function(country    = "england",
                                 equity_var = "imd_quintile",
                                 age_group  = "all",
                                 sex        = "all",
                                 year       = NULL) {
  country    <- tolower(country)
  equity_var <- tolower(equity_var)
  sex        <- tolower(sex)

  country_choices <- c("england", "canada", "who_regions", "scotland", "wales")
  if (!country %in% country_choices) {
    rlang::abort(paste0(
      "`country` must be one of: ", paste(country_choices, collapse = ", ")
    ))
  }

  dataset <- switch(country,
    england     = dceasimR::england_imd_hale,
    canada      = dceasimR::canada_income_hale,
    who_regions = dceasimR::who_regions_hale,
    scotland    = dceasimR::england_imd_hale,  # placeholder
    wales       = dceasimR::england_imd_hale   # placeholder
  )

  if (!is.null(year) && "year" %in% names(dataset)) {
    dataset <- dplyr::filter(dataset, .data$year == !!year)
  }
  if (sex != "all" && "sex" %in% names(dataset)) {
    dataset <- dplyr::filter(dataset, .data$sex == !!sex)
  }
  if (age_group != "all" && "age_group" %in% names(dataset)) {
    dataset <- dplyr::filter(dataset, .data$age_group == !!age_group)
  }

  # Normalise to standard column names used throughout the package
  nm <- names(dataset)
  if (!"group"       %in% nm && "imd_quintile"   %in% nm)
    dataset <- dplyr::rename(dataset, group       = "imd_quintile")
  if (!"group_label" %in% nm && "quintile_label" %in% nm)
    dataset <- dplyr::rename(dataset, group_label = "quintile_label")
  if (!"group_label" %in% nm && "region_label"   %in% nm)
    dataset <- dplyr::rename(dataset, group_label = "region_label")
  if (!"mean_hale"   %in% nm && "mean_hale_all"  %in% nm)
    dataset <- dplyr::rename(dataset, mean_hale   = "mean_hale_all")
  if (!"se_hale"     %in% nm && "se_hale_all"    %in% nm)
    dataset <- dplyr::rename(dataset, se_hale     = "se_hale_all")

  # Ensure cumulative_rank (ridit scores) is present
  if (!"cumulative_rank" %in% names(dataset)) {
    dataset <- dplyr::mutate(
      dataset,
      cumulative_rank = compute_ridit_scores(.data$pop_share)
    )
  }

  tibble::as_tibble(dataset)
}

#' Merge CEA model output with baseline health distribution
#'
#' Joins a CEA result data frame (one row per equity subgroup) with a
#' baseline health distribution returned by \code{\link{get_baseline_health}}.
#' This is the key data-preparation step before running DCEA.
#'
#' @param cea_output Data frame of CEA results with at least one column
#'   matching the baseline \code{by} variable.
#' @param baseline Tibble returned by \code{\link{get_baseline_health}}.
#' @param by Column name to join on (default: \code{"group"}).
#'
#' @return A merged tibble suitable for \code{\link{run_full_dcea}}.
#' @export
#'
#' @examples
#' baseline <- get_baseline_health("england", "imd_quintile")
#' cea_out  <- tibble::tibble(
#'   group    = 1:5,
#'   inc_qaly = c(0.3, 0.4, 0.5, 0.55, 0.6),
#'   inc_cost = rep(10000, 5)
#' )
#' merge_cea_with_baseline(cea_out, baseline, by = "group")
merge_cea_with_baseline <- function(cea_output, baseline, by = "group") {
  if (!by %in% names(cea_output)) {
    rlang::abort(paste0("Column '", by, "' not found in `cea_output`."))
  }
  if (!by %in% names(baseline)) {
    rlang::abort(paste0("Column '", by, "' not found in `baseline`."))
  }
  dplyr::left_join(cea_output, baseline, by = by)
}
