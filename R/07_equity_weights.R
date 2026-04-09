#' Calculate Equity Weights
#'
#' Derives equity weights from the Atkinson social welfare function. Equity
#' weights represent the relative social value of a one-unit health gain in
#' each socioeconomic group given inequality aversion \eqn{\eta}.
#'
#' For the Atkinson SWF, the equity weight for group \eqn{i} is proportional
#' to \eqn{h_i^{-\eta}}: groups with lower baseline health receive higher
#' weights when \eqn{\eta > 0}.
#'
#' @param baseline_health Numeric vector of baseline health (HALE) by group
#'   (ordered from most to least deprived).
#' @param pop_weights Numeric vector of population weights.
#' @param eta Inequality aversion parameter (default = 1).
#' @param normalise Logical. If \code{TRUE} (default), weights are normalised
#'   so their population-weighted mean equals 1. If \code{FALSE}, returns raw
#'   marginal welfare derivatives.
#'
#' @return Named numeric vector of equity weights, one per group.
#' @export
#'
#' @references
#' Cookson R, Griffin S, Norheim OF, Culyer AJ (2020). Distributional
#' Cost-Effectiveness Analysis. Oxford University Press.
#' Oxford University Press (ISBN:9780198838197).
#'
#' Robson M, Asaria M, Cookson R, Tsuchiya A, Ali S (2017). Eliciting the
#' Level of Health Inequality Aversion in England. Health Economics
#' 26(10): 1328-1334. \doi{10.1002/hec.3386}
#'
#' @examples
#' baseline <- c(60, 63, 66, 69, 72)
#' weights  <- rep(0.2, 5)
#' calc_equity_weights(baseline, weights, eta = 1)
calc_equity_weights <- function(baseline_health, pop_weights, eta = 1,
                                 normalise = TRUE) {
  if (any(baseline_health <= 0)) {
    rlang::abort("Baseline health values must be strictly positive.")
  }
  pop_weights <- normalise_weights(pop_weights)

  raw_weights <- baseline_health^(-eta)

  if (normalise) {
    w_mean <- sum(pop_weights * raw_weights)
    raw_weights <- raw_weights / w_mean
  }

  raw_weights
}

#' Calculate equity-weighted Net Health Benefit (NHB)
#'
#' Applies equity weights to per-group NHB values to obtain the
#' population-level equity-weighted NHB. This is the key summary statistic
#' from the social welfare perspective.
#'
#' @param nhb_by_group Numeric vector of net health benefit per group.
#' @param equity_weights Numeric vector of equity weights from
#'   \code{\link{calc_equity_weights}}.
#' @param pop_weights Numeric vector of population weights.
#'
#' @return Scalar equity-weighted NHB (numeric).
#' @export
#'
#' @examples
#' baseline <- c(60, 63, 66, 69, 72)
#' weights  <- rep(0.2, 5)
#' ew       <- calc_equity_weights(baseline, weights, eta = 1)
#' nhb      <- c(100, 150, 200, 250, 300)
#' calc_equity_weighted_nhb(nhb, ew, weights)
calc_equity_weighted_nhb <- function(nhb_by_group, equity_weights,
                                      pop_weights) {
  pop_weights <- normalise_weights(pop_weights)
  sum(pop_weights * equity_weights * nhb_by_group)
}

#' Equity weights over a range of eta values
#'
#' Convenience function that returns equity weights for each group across
#' a range of \eqn{\eta} values. Useful for understanding how the choice of
#' inequality aversion changes the implied weights.
#'
#' @param baseline_health Numeric vector of baseline health by group.
#' @param pop_weights Numeric vector of population weights.
#' @param eta_range Numeric vector of \eqn{\eta} values.
#' @param group_labels Optional character vector of group labels.
#'
#' @return A tidy tibble with columns \code{eta}, \code{group},
#'   \code{group_label} (if provided), and \code{equity_weight}.
#' @export
#'
#' @examples
#' baseline <- c(60, 63, 66, 69, 72)
#' weights  <- rep(0.2, 5)
#' calc_equity_weight_profile(baseline, weights, eta_range = 0:5)
calc_equity_weight_profile <- function(baseline_health, pop_weights,
                                        eta_range,
                                        group_labels = NULL) {
  n <- length(baseline_health)
  if (is.null(group_labels)) group_labels <- paste("Group", seq_len(n))

  rows <- lapply(eta_range, function(eta) {
    ew <- calc_equity_weights(baseline_health, pop_weights, eta)
    tibble::tibble(
      eta          = eta,
      group        = seq_len(n),
      group_label  = group_labels,
      equity_weight = ew
    )
  })
  dplyr::bind_rows(rows)
}
