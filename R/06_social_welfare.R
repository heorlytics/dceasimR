#' Calculate Equally Distributed Equivalent Health (EDE)
#'
#' Uses the Atkinson social welfare function to calculate EDE health — the
#' level of health that, if equally distributed, would generate the same
#' social welfare as the actual distribution given inequality aversion
#' parameter \eqn{\eta}.
#'
#' \deqn{
#'   \text{EDE}(\eta) =
#'   \left(\sum_i w_i h_i^{1-\eta} \big/ \sum_i w_i\right)^{1/(1-\eta)}
#'   \quad \text{for } \eta \neq 1
#' }
#' \deqn{
#'   \text{EDE}(1) = \exp\!\left(\sum_i w_i \ln(h_i)\right)
#'   \quad \text{(geometric mean, } \eta = 1\text{)}
#' }
#'
#' @param health_dist Numeric vector of health values by group (must be
#'   strictly positive).
#' @param pop_weights Numeric vector of population weights (will be
#'   normalised to sum to 1).
#' @param eta Inequality aversion parameter (numeric scalar, default = 1).
#'   \itemize{
#'     \item \eqn{\eta = 0}: returns arithmetic mean (no inequality aversion).
#'     \item \eqn{\eta = 1}: returns geometric mean (moderate aversion).
#'     \item \eqn{\eta > 1}: increasing inequality aversion.
#'     \item NICE relevant range: 0 to 10.
#'   }
#'
#' @return EDE health value (numeric scalar). Returns \code{NA} with a
#'   warning if any health values are non-positive.
#' @export
#'
#' @references Atkinson AB (1970). On the Measurement of Inequality. Journal
#'   of Economic Theory 2(3): 244-263. \doi{10.1016/0022-0531(70)90039-6}
#'
#' @examples
#' health  <- c(60, 63, 66, 69, 72)
#' weights <- rep(0.2, 5)
#'
#' # eta = 0: arithmetic mean
#' calc_ede(health, weights, eta = 0)
#'
#' # eta = 1: geometric mean
#' calc_ede(health, weights, eta = 1)
#'
#' # eta = 5: high inequality aversion
#' calc_ede(health, weights, eta = 5)
calc_ede <- function(health_dist, pop_weights, eta = 1) {
  if (any(health_dist <= 0)) {
    rlang::warn(
      "Non-positive health values detected. EDE is undefined; returning NA."
    )
    return(NA_real_)
  }
  pop_weights <- normalise_weights(pop_weights)

  if (eta == 0) {
    return(sum(pop_weights * health_dist))
  }

  if (eta == 1) {
    return(exp(sum(pop_weights * log(health_dist))))
  }

  (sum(pop_weights * health_dist^(1 - eta)))^(1 / (1 - eta))
}

#' Calculate EDE over a range of eta values
#'
#' Evaluates \code{\link{calc_ede}} across a vector of \eqn{\eta} values and
#' returns a tidy tibble. This is the basis for EDE profile plots as
#' described in the York DCEA handbook.
#'
#' @param health_dist Numeric vector of health values by group.
#' @param pop_weights Numeric vector of population weights.
#' @param eta_range Numeric vector of \eqn{\eta} values to evaluate
#'   (default: \code{seq(0, 10, 0.1)}).
#'
#' @return A tibble with columns \code{eta} and \code{ede}.
#' @export
#'
#' @examples
#' health  <- c(60, 63, 66, 69, 72)
#' weights <- rep(0.2, 5)
#' calc_ede_profile(health, weights)
calc_ede_profile <- function(health_dist, pop_weights,
                              eta_range = seq(0, 10, 0.1)) {
  edes <- vapply(eta_range, function(e) calc_ede(health_dist, pop_weights, e),
                 numeric(1))
  tibble::tibble(eta = eta_range, ede = edes)
}

#' Calculate Social Welfare Function value
#'
#' Wraps \code{\link{calc_ede}} to compute social welfare before and after an
#' intervention and decomposes the welfare change into efficiency and equity
#' components.
#'
#' @param baseline_health Numeric vector of pre-intervention health by group.
#' @param post_health Numeric vector of post-intervention health by group.
#' @param pop_weights Numeric vector of population weights.
#' @param eta Inequality aversion parameter (default = 1).
#'
#' @return A named list with elements:
#'   \describe{
#'     \item{\code{ede_baseline}}{EDE health before intervention.}
#'     \item{\code{ede_post}}{EDE health after intervention.}
#'     \item{\code{delta_ede}}{Change in EDE (welfare gain).}
#'     \item{\code{efficiency_component}}{Change in mean health.}
#'     \item{\code{equity_component}}{Change in EDE minus change in mean.}
#'   }
#' @export
#'
#' @examples
#' pre  <- c(60, 63, 66, 69, 72)
#' post <- c(61, 64, 66.5, 69.2, 72.1)
#' w    <- rep(0.2, 5)
#' calc_social_welfare(pre, post, w, eta = 1)
calc_social_welfare <- function(baseline_health, post_health,
                                 pop_weights, eta = 1) {
  pop_weights <- normalise_weights(pop_weights)

  ede_baseline <- calc_ede(baseline_health, pop_weights, eta)
  ede_post     <- calc_ede(post_health,    pop_weights, eta)
  delta_ede    <- ede_post - ede_baseline

  mean_baseline    <- sum(pop_weights * baseline_health)
  mean_post        <- sum(pop_weights * post_health)
  efficiency_comp  <- mean_post - mean_baseline
  equity_comp      <- delta_ede - efficiency_comp

  list(
    ede_baseline         = ede_baseline,
    ede_post             = ede_post,
    delta_ede            = delta_ede,
    efficiency_component = efficiency_comp,
    equity_component     = equity_comp
  )
}
