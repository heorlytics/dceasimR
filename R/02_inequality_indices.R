#' Calculate Slope Index of Inequality (SII)
#'
#' Fits a weighted regression of health on ridit scores to estimate the
#' absolute health difference between the most and least deprived groups.
#' The SII is the regression coefficient on the ridit score, interpretable
#' as the total health gap across the full socioeconomic range.
#'
#' @param data A data frame with health and group columns.
#' @param health_var Name of the health variable column (character).
#' @param group_var Name of the socioeconomic group column (ordered integer,
#'   1 = most deprived).
#' @param weight_var Name of the population share column (sums to 1).
#'
#' @return A named list with elements:
#'   \describe{
#'     \item{sii}{Slope Index of Inequality (numeric)}
#'     \item{rii}{Relative Index of Inequality (numeric)}
#'     \item{se_sii}{Standard error of SII}
#'     \item{p_value}{p-value for SII}
#'     \item{model}{The underlying \code{lm} object}
#'   }
#' @export
#'
#' @references Mackenbach JP, Kunst AE (1997) Measuring the magnitude of
#'   socioeconomic inequalities in health: an overview of available measures
#'   illustrated with two examples from Europe. Social Science and Medicine
#'   44(6): 757-771. \doi{10.1016/S0277-9536(96)00073-1}
#'
#' @examples
#' df <- tibble::tibble(
#'   group      = 1:5,
#'   mean_hale  = c(60, 63, 66, 69, 72),
#'   pop_share  = rep(0.2, 5)
#' )
#' calc_sii(df, "mean_hale", "group", "pop_share")
calc_sii <- function(data, health_var, group_var, weight_var) {
  data <- validate_dcea_data(
    data,
    required_cols = c(health_var, group_var, weight_var),
    weight_var = weight_var
  )
  data <- dplyr::arrange(data, .data[[group_var]])
  ridit <- compute_ridit_scores(data[[weight_var]])
  h     <- data[[health_var]]
  w     <- data[[weight_var]]

  model <- stats::lm(h ~ ridit, weights = w)
  coefs <- summary(model)$coefficients

  sii     <- coefs["ridit", "Estimate"]
  se_sii  <- coefs["ridit", "Std. Error"]
  p_value <- coefs["ridit", "Pr(>|t|)"]
  mu      <- stats::weighted.mean(h, w)
  rii     <- if (mu != 0) sii / mu else NA_real_

  list(
    sii     = sii,
    rii     = rii,
    se_sii  = se_sii,
    p_value = p_value,
    model   = model
  )
}

#' Calculate Relative Index of Inequality (RII)
#'
#' The RII is the SII expressed relative to the mean health level. An RII of
#' 0.20 means the most deprived group has health 20% lower than the mean
#' across the full socioeconomic range.
#'
#' @inheritParams calc_sii
#' @return A named list with elements \code{rii}, \code{sii}, \code{se_rii},
#'   \code{p_value}, and \code{model}.
#' @export
#'
#' @examples
#' df <- tibble::tibble(
#'   group      = 1:5,
#'   mean_hale  = c(60, 63, 66, 69, 72),
#'   pop_share  = rep(0.2, 5)
#' )
#' calc_rii(df, "mean_hale", "group", "pop_share")
calc_rii <- function(data, health_var, group_var, weight_var) {
  result <- calc_sii(data, health_var, group_var, weight_var)
  w  <- data[[weight_var]]
  h  <- data[[health_var]]
  mu <- stats::weighted.mean(h, w)
  result$se_rii <- if (mu != 0) result$se_sii / mu else NA_real_
  result
}

#' Calculate Concentration Index
#'
#' Measures the degree to which a health variable is concentrated among
#' socioeconomically advantaged or disadvantaged groups. A negative value
#' indicates the health variable (e.g., illness) is concentrated among the
#' deprived; a positive value indicates concentration among the advantaged.
#'
#' @inheritParams calc_sii
#' @param rank_var Name of the socioeconomic rank variable (ridit scores,
#'   0 = lowest, 1 = highest). If \code{NULL}, computed from \code{group_var}
#'   and \code{weight_var} using ridit scoring.
#' @param type Concentration index variant: \code{"standard"} (Kakwani),
#'   \code{"erreygers"} (bounded), or \code{"wagstaff"} (normalised).
#'
#' @return A named list with \code{ci} (concentration index), \code{se},
#'   and \code{type}.
#' @export
#'
#' @references
#' Erreygers G (2009). Correcting the Concentration Index. Journal of Health
#' Economics 28(2): 504-515. \doi{10.1016/j.jhealeco.2008.02.003}
#'
#' @examples
#' df <- tibble::tibble(
#'   group      = 1:5,
#'   mean_hale  = c(60, 63, 66, 69, 72),
#'   pop_share  = rep(0.2, 5)
#' )
#' calc_concentration_index(df, "mean_hale", "group", "pop_share")
calc_concentration_index <- function(data, health_var, group_var, weight_var,
                                      rank_var = NULL,
                                      type = c("standard", "erreygers", "wagstaff")) {
  type <- match.arg(type)
  data <- validate_dcea_data(
    data,
    required_cols = c(health_var, group_var, weight_var),
    weight_var = weight_var
  )
  data <- dplyr::arrange(data, .data[[group_var]])
  h <- data[[health_var]]
  w <- data[[weight_var]]

  if (is.null(rank_var)) {
    r <- compute_ridit_scores(w)
  } else {
    r <- data[[rank_var]]
  }

  mu <- stats::weighted.mean(h, w)
  ci <- 2 * stats::weighted.mean((r - 0.5) * h, w) / mu

  if (type == "erreygers") {
    h_min <- min(h)
    h_max <- max(h)
    ci    <- 4 * mu / (h_max - h_min) * ci
  } else if (type == "wagstaff") {
    n  <- length(h)
    ci <- ci / (1 - mu)
  }

  list(ci = ci, se = NA_real_, type = type)
}

#' Calculate Atkinson Index of Health Inequality
#'
#' The Atkinson index measures the extent of inequality in the health
#' distribution, explicitly incorporating a parameter \eqn{\varepsilon}
#' representing inequality aversion. Higher \eqn{\varepsilon} values give
#' more weight to health differences at the bottom of the distribution.
#'
#' @param health_dist Numeric vector of health values across population groups.
#' @param pop_weights Numeric vector of population weights (need not sum to 1;
#'   will be normalised internally).
#' @param epsilon Inequality aversion parameter (default = 1). Must be
#'   non-negative. When \eqn{\varepsilon = 0}, returns 0 (no aversion).
#'
#' @return Atkinson index value in [0, 1]. A value of 0 indicates perfect
#'   equality; a value approaching 1 indicates maximum inequality.
#' @export
#'
#' @references Atkinson AB (1970). On the Measurement of Inequality. Journal
#'   of Economic Theory 2(3): 244-263. \doi{10.1016/0022-0531(70)90039-6}
#'
#' @examples
#' # Perfect equality
#' calc_atkinson_index(rep(70, 5), rep(0.2, 5), epsilon = 1)
#'
#' # Gradient across groups
#' calc_atkinson_index(c(60, 63, 66, 69, 72), rep(0.2, 5), epsilon = 1)
calc_atkinson_index <- function(health_dist, pop_weights, epsilon = 1) {
  if (any(health_dist <= 0)) {
    rlang::warn("Non-positive health values detected. Atkinson index may be undefined.")
    return(NA_real_)
  }
  pop_weights <- normalise_weights(pop_weights)
  mu <- stats::weighted.mean(health_dist, pop_weights)

  if (epsilon == 0) {
    return(0)
  } else if (epsilon == 1) {
    # Geometric mean via L'Hopital limit
    ede <- exp(sum(pop_weights * log(health_dist)))
  } else {
    ede <- (sum(pop_weights * health_dist^(1 - epsilon)))^(1 / (1 - epsilon))
  }

  1 - ede / mu
}

#' Calculate Gini Coefficient for Health Distribution
#'
#' Computes the Gini coefficient as a measure of health inequality across
#' socioeconomic groups. The Gini ranges from 0 (perfect equality) to 1
#' (maximum inequality).
#'
#' @param health_dist Numeric vector of health values (ordered from lowest
#'   to highest group).
#' @param pop_weights Optional numeric vector of population weights. If
#'   \code{NULL}, equal weights are assumed.
#'
#' @return Gini coefficient (numeric scalar in [0, 1]).
#' @export
#'
#' @examples
#' calc_gini(c(60, 63, 66, 69, 72), pop_weights = rep(0.2, 5))
calc_gini <- function(health_dist, pop_weights = NULL) {
  n <- length(health_dist)
  if (is.null(pop_weights)) pop_weights <- rep(1 / n, n)
  pop_weights <- normalise_weights(pop_weights)

  ord <- order(health_dist)
  h   <- health_dist[ord]
  w   <- pop_weights[ord]
  mu  <- sum(w * h)

  cum_w <- cumsum(w)
  lag_w <- c(0, cum_w[-n])
  p     <- (lag_w + cum_w) / 2  # ridit

  gini <- 2 * sum(w * h * p) / mu - 1
  max(0, min(1, gini))
}

#' Calculate all inequality indices in one call
#'
#' Convenience wrapper that computes SII, RII, concentration index, Atkinson
#' index (for multiple \eqn{\varepsilon} values), and Gini coefficient and
#' returns them as a tidy data frame.
#'
#' @inheritParams calc_sii
#' @param epsilon_values Numeric vector of \eqn{\varepsilon} values for the
#'   Atkinson index (default: \code{c(0.5, 1, 2)}).
#'
#' @return A tibble with columns \code{index}, \code{value}, and
#'   \code{description}.
#' @export
#'
#' @examples
#' df <- tibble::tibble(
#'   group      = 1:5,
#'   mean_hale  = c(60, 63, 66, 69, 72),
#'   pop_share  = rep(0.2, 5)
#' )
#' calc_all_inequality_indices(df, "mean_hale", "group", "pop_share")
calc_all_inequality_indices <- function(data, health_var, group_var,
                                         weight_var,
                                         epsilon_values = c(0.5, 1, 2)) {
  sii_res <- calc_sii(data, health_var, group_var, weight_var)
  ci_res  <- calc_concentration_index(data, health_var, group_var, weight_var)
  h       <- dplyr::arrange(data, .data[[group_var]])[[health_var]]
  w       <- dplyr::arrange(data, .data[[group_var]])[[weight_var]]
  gini    <- calc_gini(h, w)

  atk_rows <- lapply(epsilon_values, function(eps) {
    tibble::tibble(
      index       = paste0("atkinson_epsilon_", eps),
      value       = calc_atkinson_index(h, w, epsilon = eps),
      description = paste0("Atkinson index (epsilon = ", eps, ")")
    )
  })

  dplyr::bind_rows(
    tibble::tibble(
      index       = "sii",
      value       = sii_res$sii,
      description = "Slope Index of Inequality"
    ),
    tibble::tibble(
      index       = "rii",
      value       = sii_res$rii,
      description = "Relative Index of Inequality"
    ),
    tibble::tibble(
      index       = "concentration_index",
      value       = ci_res$ci,
      description = "Concentration Index (standard)"
    ),
    tibble::tibble(
      index       = "gini",
      value       = gini,
      description = "Gini coefficient"
    ),
    dplyr::bind_rows(atk_rows)
  )
}
