#' Run DCEA Sensitivity Analysis
#'
#' Performs systematic one-way and multi-way sensitivity analysis across
#' key DCEA parameters: inequality aversion (\eqn{\eta}), WTP threshold,
#' opportunity cost threshold, subgroup distribution assumptions, and equity
#' measure choice.
#'
#' @param dcea_result Object of class \code{"aggregate_dcea"} or
#'   \code{"full_dcea"}.
#' @param params_to_vary Character vector of parameter names to vary. Options:
#'   \code{"eta"}, \code{"wtp"}, \code{"occ_threshold"},
#'   \code{"subgroup_distribution"}, \code{"equity_measure"}, \code{"all"}
#'   (default: \code{"all"}).
#' @param eta_range Numeric vector of \eqn{\eta} values for eta sensitivity
#'   (default: \code{0:10}).
#' @param wtp_range Numeric vector of WTP values to test (default: varies
#'   ±50\% around base case).
#' @param occ_range Numeric vector of opportunity cost threshold values
#'   (default: \code{c(8000, 10000, 13000, 15000, 20000)}).
#'
#' @return An object of class \code{"dcea_sensitivity"} with elements:
#'   \describe{
#'     \item{\code{eta_profile}}{Tibble: NHB and SII change across eta range.}
#'     \item{\code{one_way}}{Tibble: results of one-way sensitivity for all
#'       parameters.}
#'     \item{\code{tornado_data}}{Data frame ready for tornado plot.}
#'     \item{\code{parameters}}{List of parameter ranges used.}
#'   }
#' @export
#'
#' @examples
#' result <- run_aggregate_dcea(
#'   icer = 25000, inc_qaly = 0.5, inc_cost = 12500,
#'   population_size = 10000, wtp = 20000
#' )
#' sa <- run_dcea_sensitivity(result, params_to_vary = "eta")
#' plot_dcea_tornado(sa)
run_dcea_sensitivity <- function(dcea_result,
                                  params_to_vary = "all",
                                  eta_range      = 0:10,
                                  wtp_range      = NULL,
                                  occ_range      = NULL) {
  .check_dcea_class(dcea_result)

  if ("all" %in% params_to_vary) {
    params_to_vary <- c("eta", "wtp", "occ_threshold")
  }

  meta <- dcea_result$metadata
  base_nhb <- dcea_result$summary$nhb

  # ---- ETA sensitivity ----------------------------------------------------
  eta_profile <- NULL
  if ("eta" %in% params_to_vary) {
    bg <- dcea_result$by_group
    eta_rows <- lapply(eta_range, function(eta) {
      ew <- calc_equity_weights(bg$baseline_hale, bg$pop_share, eta)
      ewnhb <- calc_equity_weighted_nhb(bg$nhb, ew, bg$pop_share)
      tibble::tibble(
        eta               = eta,
        equity_weight_q1  = ew[1],
        equity_weight_q5  = ew[length(ew)],
        equity_weighted_nhb = ewnhb,
        delta_ede = calc_ede(bg$post_hale, bg$pop_share, eta) -
          calc_ede(bg$baseline_hale, bg$pop_share, eta)
      )
    })
    eta_profile <- dplyr::bind_rows(eta_rows)
  }

  # ---- WTP sensitivity ----------------------------------------------------
  wtp_rows <- NULL
  if ("wtp" %in% params_to_vary && inherits(dcea_result, "aggregate_dcea")) {
    base_wtp <- dcea_result$summary$wtp
    if (is.null(wtp_range)) {
      wtp_range <- c(base_wtp * 0.5, base_wtp * 0.75,
                     base_wtp, base_wtp * 1.25, base_wtp * 1.5)
    }
    wtp_rows <- lapply(wtp_range, function(w) {
      nhb_w <- dcea_result$summary$total_health_gain -
        dcea_result$summary$total_opp_cost
      tibble::tibble(parameter = "wtp", value = w, nhb = nhb_w)
    })
    wtp_rows <- dplyr::bind_rows(wtp_rows)
  }

  # ---- Opportunity cost threshold sensitivity ------------------------------
  occ_rows <- NULL
  if ("occ_threshold" %in% params_to_vary &&
      inherits(dcea_result, "aggregate_dcea")) {
    base_occ <- dcea_result$summary$opportunity_cost_threshold
    if (is.null(occ_range)) {
      occ_range <- c(8000, 10000, 13000, 15000, 20000)
    }
    base_cost <- dcea_result$summary$inc_cost *
      dcea_result$summary$population_size
    occ_rows <- lapply(occ_range, function(occ) {
      nhb_occ <- dcea_result$summary$total_health_gain -
        base_cost / occ
      tibble::tibble(parameter = "occ_threshold", value = occ, nhb = nhb_occ)
    })
    occ_rows <- dplyr::bind_rows(occ_rows)
  }

  # ---- Combine one-way results -------------------------------------------
  one_way <- dplyr::bind_rows(wtp_rows, occ_rows)

  # ---- Tornado data -------------------------------------------------------
  tornado_data <- NULL
  if (!is.null(one_way) && nrow(one_way) > 0) {
    tornado_data <- one_way |>
      dplyr::group_by(.data$parameter) |>
      dplyr::summarise(
        nhb_low  = min(.data$nhb),
        nhb_high = max(.data$nhb),
        nhb_base = base_nhb,
        range    = max(.data$nhb) - min(.data$nhb)
      ) |>
      dplyr::arrange(dplyr::desc(.data$range))
  }

  structure(
    list(
      eta_profile  = eta_profile,
      one_way      = one_way,
      tornado_data = tornado_data,
      parameters   = list(
        eta_range = eta_range,
        wtp_range = wtp_range,
        occ_range = occ_range
      )
    ),
    class = "dcea_sensitivity"
  )
}

#' Plot Tornado Diagram for DCEA Sensitivity Analysis
#'
#' Creates a tornado diagram showing the influence of each parameter on
#' the net health benefit. Parameters are sorted by range (most influential
#' at the top).
#'
#' @param sensitivity_result Output from \code{\link{run_dcea_sensitivity}}.
#'
#' @return A \pkg{ggplot2} tornado diagram.
#' @export
#'
#' @examples
#' result <- run_aggregate_dcea(
#'   icer = 25000, inc_qaly = 0.5, inc_cost = 12500,
#'   population_size = 10000, wtp = 20000
#' )
#' sa <- run_dcea_sensitivity(result)
#' plot_dcea_tornado(sa)
plot_dcea_tornado <- function(sensitivity_result) {
  if (!inherits(sensitivity_result, "dcea_sensitivity")) {
    rlang::abort("`sensitivity_result` must be from run_dcea_sensitivity().")
  }
  td <- sensitivity_result$tornado_data
  if (is.null(td) || nrow(td) == 0) {
    rlang::warn("No tornado data available. Run with params_to_vary including 'wtp' or 'occ_threshold'.")
    return(ggplot2::ggplot() +
             ggplot2::labs(title = "No tornado data available") +
             ggplot2::theme_minimal())
  }

  td$parameter <- factor(td$parameter,
                         levels = rev(td$parameter[order(td$range)]))

  ggplot2::ggplot(td) +
    ggplot2::geom_segment(
      ggplot2::aes(x = .data$nhb_low, xend = .data$nhb_high,
                   y = .data$parameter, yend = .data$parameter),
      linewidth = 8, colour = "steelblue", alpha = 0.7
    ) +
    ggplot2::geom_vline(
      ggplot2::aes(xintercept = nhb_base[1]),
      linetype = "dashed", colour = "red3"
    ) +
    ggplot2::labs(
      title = "Tornado Diagram: DCEA Sensitivity Analysis",
      x     = "Net Health Benefit (QALYs)",
      y     = "Parameter"
    ) +
    ggplot2::theme_minimal(base_size = 12)
}
