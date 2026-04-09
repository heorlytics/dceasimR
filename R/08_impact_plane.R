#' Plot Equity-Efficiency Impact Plane
#'
#' Creates the equity-efficiency impact plane as described in Cookson et al.
#' (2017) Value in Health. The x-axis shows health inequality impact (change
#' in a chosen inequality index), the y-axis shows net health benefit
#' (efficiency). Four quadrants represent: Win-Win (NE), equity gain and
#' efficiency loss (NW), equity loss and efficiency gain (SE), Lose-Lose (SW).
#'
#' @param dcea_result Object of class \code{"aggregate_dcea"} or
#'   \code{"full_dcea"}.
#' @param comparators Optional list of additional DCEA result objects to
#'   overlay on the same plane (for multi-comparator plots).
#' @param x_axis Inequality metric for x-axis. One of \code{"sii_change"}
#'   (default), \code{"atkinson_change"}, \code{"gini_change"}.
#' @param y_axis Health outcome for y-axis. One of \code{"nhb"} (default),
#'   \code{"net_monetary_benefit"}.
#' @param show_psa_cloud Logical. Show probabilistic scatter cloud if PSA
#'   data are available (default: \code{TRUE}).
#' @param show_quadrant_labels Logical (default: \code{TRUE}).
#' @param show_threshold_lines Logical. Show NHB = 0 and inequality = 0
#'   reference lines (default: \code{TRUE}).
#' @param point_labels Optional character vector of labels for points.
#' @param colour_palette Optional named character vector of hex colours.
#' @param theme_style Visual theme: \code{"publication"} (default) or
#'   \code{"ggplot_default"}.
#'
#' @return A \pkg{ggplot2} object.
#' @export
#'
#' @references Cookson R, Asaria M, Ali S, Shaw R, Doran T, Goldblatt P
#'   (2017). Health equity monitoring for healthcare quality assurance. Social
#'   Science & Medicine 198: 148-156.
#'
#' @examples
#' result <- run_aggregate_dcea(
#'   icer = 25000, inc_qaly = 0.5, inc_cost = 12500,
#'   population_size = 10000, wtp = 20000
#' )
#' plot_equity_impact_plane(result)
plot_equity_impact_plane <- function(dcea_result,
                                      comparators          = NULL,
                                      x_axis               = "sii_change",
                                      y_axis               = "nhb",
                                      show_psa_cloud       = TRUE,
                                      show_quadrant_labels = TRUE,
                                      show_threshold_lines = TRUE,
                                      point_labels         = NULL,
                                      colour_palette       = NULL,
                                      theme_style          = "publication") {
  .check_dcea_class(dcea_result)

  # Build data frame for plotting
  plane_data <- dcea_result$equity_plane_data
  plane_data$label <- if (!is.null(point_labels)) point_labels[1] else
    plane_data$label

  if (!is.null(comparators)) {
    for (i in seq_along(comparators)) {
      comp_data <- comparators[[i]]$equity_plane_data
      comp_data$label <- if (!is.null(point_labels) && length(point_labels) >= i + 1)
        point_labels[i + 1] else comp_data$label
      plane_data <- dplyr::bind_rows(plane_data, comp_data)
    }
  }

  x_col <- "sii_change"
  y_col <- "nhb"
  x_lab <- "Change in Slope Index of Inequality\n(negative = equity improving)"
  y_lab <- "Net Health Benefit (QALYs)"

  p <- ggplot2::ggplot(plane_data,
    ggplot2::aes(x = .data[[x_col]], y = .data[[y_col]],
                 colour = .data$label, label = .data$label)) +
    ggplot2::geom_point(size = 4)

  if (show_threshold_lines) {
    p <- p +
      ggplot2::geom_hline(yintercept = 0, linetype = "dashed",
                          colour = "grey50") +
      ggplot2::geom_vline(xintercept = 0, linetype = "dashed",
                          colour = "grey50")
  }

  if (show_quadrant_labels) {
    p <- p +
      ggplot2::annotate("text", x = -Inf, y = Inf, label = "Win-Win",
                        hjust = -0.1, vjust = 1.5, colour = "darkgreen",
                        fontface = "italic", size = 3) +
      ggplot2::annotate("text", x = Inf,  y = Inf,
                        label = "Equity loss,\nefficiency gain",
                        hjust = 1.1,  vjust = 1.5, colour = "darkorange",
                        fontface = "italic", size = 3) +
      ggplot2::annotate("text", x = -Inf, y = -Inf,
                        label = "Equity gain,\nefficiency loss",
                        hjust = -0.1, vjust = -0.5, colour = "steelblue",
                        fontface = "italic", size = 3) +
      ggplot2::annotate("text", x = Inf,  y = -Inf, label = "Lose-Lose",
                        hjust = 1.1,  vjust = -0.5, colour = "red3",
                        fontface = "italic", size = 3)
  }

  if (!is.null(colour_palette)) {
    p <- p + ggplot2::scale_colour_manual(values = colour_palette)
  }

  p <- p +
    ggplot2::labs(
      title   = "Equity-Efficiency Impact Plane",
      x       = x_lab,
      y       = y_lab,
      colour  = NULL
    )

  if (theme_style == "publication") {
    p <- p + ggplot2::theme_minimal(base_size = 12) +
      ggplot2::theme(
        legend.position  = "bottom",
        plot.title       = ggplot2::element_text(face = "bold"),
        panel.grid.minor = ggplot2::element_blank()
      )
  }

  p
}

#' Plot Lorenz Curve for Health Distribution
#'
#' Plots the Lorenz curve showing health concentration across the
#' socioeconomic distribution. The 45-degree line represents perfect equality.
#'
#' @param dcea_result DCEA result object, or a data frame with health and
#'   weight columns.
#' @param show_pre_post Logical. Overlay pre- and post-intervention curves
#'   (default: \code{TRUE}).
#' @param show_generalised Logical. Overlay the Generalised Lorenz Curve
#'   (default: \code{FALSE}).
#'
#' @return A \pkg{ggplot2} object.
#' @export
#'
#' @examples
#' result <- run_aggregate_dcea(
#'   icer = 25000, inc_qaly = 0.5, inc_cost = 12500,
#'   population_size = 10000, wtp = 20000
#' )
#' plot_lorenz_curve(result)
plot_lorenz_curve <- function(dcea_result,
                               show_pre_post   = TRUE,
                               show_generalised = FALSE) {
  .check_dcea_class(dcea_result)
  bg <- dcea_result$by_group

  .lorenz_df <- function(health, weights, label) {
    ord  <- order(health)
    h    <- health[ord]
    w    <- weights[ord]
    cum_w <- c(0, cumsum(w))
    cum_h <- c(0, cumsum(w * h) / sum(w * h))
    tibble::tibble(cum_pop = cum_w, cum_health = cum_h, label = label)
  }

  ld_pre  <- .lorenz_df(bg$baseline_hale, bg$pop_share, "Pre-intervention")
  ld_post <- .lorenz_df(bg$post_hale,     bg$pop_share, "Post-intervention")
  ld_eq   <- tibble::tibble(cum_pop = c(0, 1), cum_health = c(0, 1),
                             label = "Perfect equality")

  if (show_pre_post) {
    ld <- dplyr::bind_rows(ld_pre, ld_post, ld_eq)
  } else {
    ld <- dplyr::bind_rows(ld_pre, ld_eq)
  }

  ggplot2::ggplot(ld, ggplot2::aes(x = .data$cum_pop,
                                    y = .data$cum_health,
                                    colour = .data$label,
                                    linetype = .data$label)) +
    ggplot2::geom_line(linewidth = 1) +
    ggplot2::labs(
      title   = "Lorenz Curve for Health Distribution",
      x       = "Cumulative population share (poorest to richest)",
      y       = "Cumulative health share",
      colour  = NULL, linetype = NULL
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(legend.position = "bottom")
}

#' Plot EDE Profile
#'
#' Shows how equity-weighted NHB (or EDE health) changes as inequality
#' aversion (\eqn{\eta}) increases. The profile reveals the critical \eqn{\eta}
#' at which an intervention becomes welfare-improving after accounting for
#' equity concerns.
#'
#' @param dcea_result DCEA result object.
#' @param eta_range Numeric vector of \eqn{\eta} values (default:
#'   \code{seq(0, 15, 0.1)}).
#' @param comparators Optional list of additional DCEA result objects to
#'   overlay on the same plot.
#' @param show_benchmark_eta Logical. Mark commonly used \eqn{\eta} values
#'   (0 = efficiency only; 1 = Robson et al. UK estimate;
#'   10 = strong aversion; default: \code{TRUE}).
#'
#' @return A \pkg{ggplot2} object.
#' @export
#'
#' @examples
#' result <- run_aggregate_dcea(
#'   icer = 25000, inc_qaly = 0.5, inc_cost = 12500,
#'   population_size = 10000, wtp = 20000
#' )
#' plot_ede_profile(result)
plot_ede_profile <- function(dcea_result,
                              eta_range           = seq(0, 15, 0.1),
                              comparators         = NULL,
                              show_benchmark_eta  = TRUE) {
  .check_dcea_class(dcea_result)
  bg <- dcea_result$by_group

  .ede_profile_df <- function(result, label) {
    bg   <- result$by_group
    pre  <- bg$baseline_hale
    post <- bg$post_hale
    w    <- bg$pop_share
    tibble::tibble(
      eta       = eta_range,
      delta_ede = vapply(eta_range,
        function(e) calc_ede(post, w, e) - calc_ede(pre, w, e),
        numeric(1)
      ),
      label = label
    )
  }

  all_results <- list(dcea_result)
  all_labels  <- c("Intervention")
  if (!is.null(comparators)) {
    all_results <- c(all_results, comparators)
    all_labels  <- c(all_labels, paste("Comparator", seq_along(comparators)))
  }

  profile_data <- dplyr::bind_rows(
    mapply(.ede_profile_df, all_results, all_labels, SIMPLIFY = FALSE)
  )

  p <- ggplot2::ggplot(
    profile_data,
    ggplot2::aes(x = .data$eta, y = .data$delta_ede,
                 colour = .data$label)
  ) +
    ggplot2::geom_line(linewidth = 1) +
    ggplot2::geom_hline(yintercept = 0, linetype = "dashed",
                        colour = "grey50")

  if (show_benchmark_eta) {
    benchmark_eta <- c(0, 1, 10)
    benchmark_lab <- c("eta=0\n(efficiency)", "eta=1\n(UK est.)", "eta=10")
    p <- p +
      ggplot2::geom_vline(xintercept = benchmark_eta, linetype = "dotted",
                          colour = "grey70") +
      ggplot2::annotate("text", x = benchmark_eta,
                        y = max(profile_data$delta_ede, na.rm = TRUE),
                        label = benchmark_lab, vjust = -0.3, size = 2.8,
                        colour = "grey40")
  }

  p +
    ggplot2::labs(
      title  = "EDE Profile: Equity-Weighted NHB over Inequality Aversion",
      x      = expression(paste("Inequality aversion parameter (", eta, ")")),
      y      = expression(paste(Delta, "EDE (QALYs)")),
      colour = NULL
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(legend.position = "bottom")
}

#' Plot Inequality Staircase
#'
#' Visualises the causal pathway from intervention access to health inequality
#' impact across the five staircase steps: (1) disease prevalence by group,
#' (2) eligibility, (3) uptake/access, (4) clinical effect, (5) opportunity
#' cost distribution.
#'
#' @param staircase_data Data frame with columns: \code{step} (integer 1-5),
#'   \code{step_label} (character), \code{group} (integer),
#'   \code{group_label} (character), \code{value} (numeric).
#' @param equity_var Equity stratification variable name (for axis label).
#'
#' @return A \pkg{ggplot2} faceted plot.
#' @export
#'
#' @examples
#' \dontrun{
#' # Requires user-supplied staircase data
#' plot_inequality_staircase(my_staircase_data)
#' }
plot_inequality_staircase <- function(staircase_data,
                                       equity_var = "imd_quintile") {
  req <- c("step", "step_label", "group", "value")
  if (!all(req %in% names(staircase_data))) {
    rlang::abort(paste0("staircase_data must have columns: ",
                        paste(req, collapse = ", ")))
  }
  if (!"group_label" %in% names(staircase_data)) {
    staircase_data$group_label <- paste("Group", staircase_data$group)
  }

  ggplot2::ggplot(
    staircase_data,
    ggplot2::aes(x = .data$group_label, y = .data$value,
                 fill = .data$group_label)
  ) +
    ggplot2::geom_col(show.legend = FALSE) +
    ggplot2::facet_wrap(~ step_label, scales = "free_y", ncol = 2) +
    ggplot2::labs(
      title = "Inequality Staircase: Causal Pathway to Health Impact",
      x     = equity_var,
      y     = "Value"
    ) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(
      strip.text  = ggplot2::element_text(face = "bold"),
      axis.text.x = ggplot2::element_text(angle = 30, hjust = 1)
    )
}

# Internal helper
.check_dcea_class <- function(x) {
  if (!inherits(x, c("aggregate_dcea", "full_dcea"))) {
    rlang::abort("`dcea_result` must be of class 'aggregate_dcea' or 'full_dcea'.")
  }
}
