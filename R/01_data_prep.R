#' Validate and format DCEA input data
#'
#' Checks that a data frame has required columns, correct types, and that
#' population weights sum to 1. Returns the data frame invisibly if valid,
#' or throws an informative error.
#'
#' @param data A data frame to validate.
#' @param required_cols Character vector of required column names.
#' @param weight_var Name of the population weight column.
#' @param tol Tolerance for checking that weights sum to 1 (default: 1e-6).
#'
#' @return The input data frame, invisibly.
#' @export
#'
#' @examples
#' df <- tibble::tibble(
#'   group      = 1:5,
#'   mean_hale  = c(60, 63, 66, 69, 72),
#'   pop_share  = rep(0.2, 5)
#' )
#' validate_dcea_data(df, c("group", "mean_hale", "pop_share"), "pop_share")
validate_dcea_data <- function(data, required_cols, weight_var, tol = 1e-6) {
  if (!is.data.frame(data)) {
    rlang::abort("`data` must be a data frame.")
  }
  missing_cols <- setdiff(required_cols, names(data))
  if (length(missing_cols) > 0) {
    rlang::abort(paste0(
      "Missing required columns: ", paste(missing_cols, collapse = ", ")
    ))
  }
  if (!is.null(weight_var) && weight_var %in% names(data)) {
    w <- data[[weight_var]]
    if (any(!is.finite(w)) || any(w < 0)) {
      rlang::abort(paste0("`", weight_var, "` must be non-negative finite numbers."))
    }
    if (abs(sum(w) - 1) > tol) {
      rlang::warn(paste0(
        "`", weight_var, "` sums to ", round(sum(w), 6),
        ", not 1. Normalising automatically."
      ))
      data[[weight_var]] <- w / sum(w)
    }
  }
  invisible(data)
}

#' Normalise population weights to sum to 1
#'
#' @param weights Numeric vector of weights.
#' @return Normalised numeric vector.
#' @export
#'
#' @examples
#' normalise_weights(c(1, 2, 3, 4, 5))
normalise_weights <- function(weights) {
  if (any(!is.finite(weights)) || any(weights < 0)) {
    rlang::abort("Weights must be non-negative finite numbers.")
  }
  if (sum(weights) == 0) {
    rlang::abort("Weights cannot all be zero.")
  }
  weights / sum(weights)
}

#' Compute ridit scores (cumulative midpoint ranks) for inequality measures
#'
#' Ridit scores are used as the socioeconomic rank variable in concentration
#' index calculations. For group \eqn{i}, the ridit is the cumulative
#' population share up to the midpoint of group \eqn{i}.
#'
#' @param pop_shares Numeric vector of population proportions (ordered from
#'   most to least deprived, sums to 1).
#' @return Numeric vector of ridit scores in [0, 1].
#' @export
#'
#' @examples
#' compute_ridit_scores(rep(0.2, 5))
compute_ridit_scores <- function(pop_shares) {
  pop_shares <- normalise_weights(pop_shares)
  cumulative <- cumsum(pop_shares)
  lag_cumulative <- c(0, cumulative[-length(cumulative)])
  (lag_cumulative + cumulative) / 2
}

#' Prepare subgroup CEA data for DCEA
#'
#' Validates and standardises a data frame of subgroup-specific CEA results
#' for use in \code{\link{run_full_dcea}}.
#'
#' @param data Data frame with per-subgroup CEA results.
#' @param group_var Name of the group identifier column.
#' @param inc_qaly_var Name of the incremental QALY column.
#' @param inc_cost_var Name of the incremental cost column.
#' @param pop_share_var Name of the population share column.
#'
#' @return A validated and normalised tibble.
#' @export
#'
#' @examples
#' df <- tibble::tibble(
#'   group     = 1:5,
#'   inc_qaly  = c(0.3, 0.4, 0.5, 0.55, 0.6),
#'   inc_cost  = rep(10000, 5),
#'   pop_share = rep(0.2, 5)
#' )
#' prepare_subgroup_cea(df, "group", "inc_qaly", "inc_cost", "pop_share")
prepare_subgroup_cea <- function(data, group_var, inc_qaly_var,
                                  inc_cost_var, pop_share_var) {
  req <- c(group_var, inc_qaly_var, inc_cost_var, pop_share_var)
  data <- validate_dcea_data(data, req, pop_share_var)
  data <- dplyr::mutate(data,
    icer = .data[[inc_cost_var]] / .data[[inc_qaly_var]]
  )
  tibble::as_tibble(data)
}
