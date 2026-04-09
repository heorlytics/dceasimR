#' Compute Lorenz curve data
#'
#' Returns the coordinates of the Lorenz curve for a health distribution.
#' Groups are ordered from lowest to highest health (most to least deprived).
#'
#' @param health_dist Numeric vector of health values by group.
#' @param pop_weights Numeric vector of population weights.
#' @param label Optional character label for this curve.
#'
#' @return A tibble with columns \code{cum_pop} (cumulative population share),
#'   \code{cum_health} (cumulative health share), and \code{label}.
#' @export
#'
#' @examples
#' compute_lorenz_data(c(60, 63, 66, 69, 72), rep(0.2, 5))
compute_lorenz_data <- function(health_dist, pop_weights, label = "Distribution") {
  pop_weights <- normalise_weights(pop_weights)
  ord <- order(health_dist)
  h   <- health_dist[ord]
  w   <- pop_weights[ord]

  cum_w  <- c(0, cumsum(w))
  cum_h  <- c(0, cumsum(w * h) / sum(w * h))

  tibble::tibble(
    cum_pop    = cum_w,
    cum_health = cum_h,
    label      = label
  )
}

#' Compute Generalised Lorenz curve data
#'
#' The Generalised Lorenz Curve (GLC) scales the Lorenz curve by mean health,
#' making it sensitive to both inequality and average health level.
#'
#' @inheritParams compute_lorenz_data
#'
#' @return A tibble with columns \code{cum_pop}, \code{cum_health_generalised},
#'   and \code{label}.
#' @export
#'
#' @examples
#' compute_generalised_lorenz_data(c(60, 63, 66, 69, 72), rep(0.2, 5))
compute_generalised_lorenz_data <- function(health_dist, pop_weights,
                                             label = "Distribution") {
  pop_weights <- normalise_weights(pop_weights)
  mu  <- sum(pop_weights * health_dist)
  ld  <- compute_lorenz_data(health_dist, pop_weights, label)
  ld$cum_health_generalised <- ld$cum_health * mu
  ld
}
