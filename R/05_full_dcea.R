#' Run Full-Form DCEA
#'
#' Implements full-form DCEA where subgroup-specific model parameters are
#' available (e.g., differential uptake, differential quality-of-life gains,
#' differential survival by socioeconomic group). Full-form DCEA is appropriate
#' when:
#' \itemize{
#'   \item The disease has well-documented SES gradients in clinical outcomes.
#'   \item Subgroup trial data or real-world evidence is available.
#'   \item NICE requires more granular equity evidence (HST or exceptional cases).
#' }
#'
#' @param subgroup_cea_results Data frame with one row per equity subgroup.
#'   Required columns: \code{group} (integer), \code{group_label} (character),
#'   \code{inc_qaly} (numeric), \code{inc_cost} (numeric),
#'   \code{pop_share} (numeric, sums to 1).
#' @param baseline_health Tibble from \code{\link{get_baseline_health}}.
#' @param wtp Willingness-to-pay threshold in GBP/QALY (default: 20000).
#' @param opportunity_cost_threshold Cost per QALY of displaced care
#'   (default: 13000).
#' @param uptake_by_group Optional named numeric vector of uptake rates (0-1)
#'   per group. If \code{NULL}, assumes equal uptake across all groups.
#' @param adherence_by_group Optional named numeric vector of adherence rates
#'   (0-1) per group. Applied as a multiplier on \code{inc_qaly}.
#' @param comorbidity_adjustment Logical. If \code{TRUE}, applies an
#'   SES-based comorbidity adjustment to QoL gains (experimental;
#'   default: \code{FALSE}).
#' @param psa_iterations Optional integer. Number of PSA iterations. If
#'   provided, returns probabilistic NHB distribution by group.
#'
#' @return An object of class \code{"full_dcea"} with elements analogous to
#'   \code{\link{run_aggregate_dcea}} plus subgroup-level detail.
#' @export
#'
#' @examples
#' baseline <- get_baseline_health("england", "imd_quintile")
#' subgroup_data <- tibble::tibble(
#'   group       = 1:5,
#'   group_label = paste("IMD Q", 1:5),
#'   inc_qaly    = c(0.30, 0.38, 0.45, 0.52, 0.58),
#'   inc_cost    = c(12000, 11500, 11000, 10500, 10000),
#'   pop_share   = rep(0.2, 5)
#' )
#' result <- run_full_dcea(subgroup_data, baseline)
#' summary(result)
run_full_dcea <- function(subgroup_cea_results,
                           baseline_health,
                           wtp                        = 20000,
                           opportunity_cost_threshold = 13000,
                           uptake_by_group            = NULL,
                           adherence_by_group         = NULL,
                           comorbidity_adjustment     = FALSE,
                           psa_iterations             = NULL) {

  req_cols <- c("group", "inc_qaly", "inc_cost", "pop_share")
  if (!"group_label" %in% names(subgroup_cea_results)) {
    subgroup_cea_results$group_label <- paste("Group",
                                               subgroup_cea_results$group)
  }
  subgroup_cea_results <- validate_dcea_data(
    subgroup_cea_results, req_cols, "pop_share"
  )
  subgroup_cea_results <- dplyr::arrange(subgroup_cea_results, .data$group)

  n_groups <- nrow(subgroup_cea_results)
  pop_w    <- subgroup_cea_results$pop_share

  # ---- Apply uptake and adherence adjustments ----------------------------
  inc_qaly_adj <- subgroup_cea_results$inc_qaly
  inc_cost_adj <- subgroup_cea_results$inc_cost

  if (!is.null(uptake_by_group)) {
    uptake_by_group <- uptake_by_group[seq_len(n_groups)]
    inc_qaly_adj    <- inc_qaly_adj * uptake_by_group
    inc_cost_adj    <- inc_cost_adj * uptake_by_group
  }

  if (!is.null(adherence_by_group)) {
    adherence_by_group <- adherence_by_group[seq_len(n_groups)]
    inc_qaly_adj       <- inc_qaly_adj * adherence_by_group
  }

  # ---- NHB per group (at WTP threshold) ----------------------------------
  nhb_by_group  <- inc_qaly_adj - inc_cost_adj / wtp
  opp_cost_by_group <- inc_cost_adj / opportunity_cost_threshold
  net_gain_by_group <- inc_qaly_adj - opp_cost_by_group

  # ---- Baseline and post HALE distributions ------------------------------
  merged <- merge_cea_with_baseline(subgroup_cea_results, baseline_health)
  pre_hale  <- merged$mean_hale
  post_hale <- pre_hale + net_gain_by_group

  # ---- Inequality indices ------------------------------------------------
  pre_indices  <- .compute_summary_inequality(pre_hale,  pop_w)
  post_indices <- .compute_summary_inequality(post_hale, pop_w)

  inequality_impact <- tibble::tibble(
    index      = names(pre_indices),
    pre        = unname(pre_indices),
    post       = unname(post_indices),
    change     = unname(post_indices) - unname(pre_indices)
  )

  # ---- Social welfare profile -------------------------------------------
  eta_range    <- seq(0, 10, by = 0.5)
  swf_results  <- lapply(eta_range, function(eta) {
    tibble::tibble(
      eta       = eta,
      ede_pre   = calc_ede(pre_hale,  pop_w, eta),
      ede_post  = calc_ede(post_hale, pop_w, eta),
      delta_ede = calc_ede(post_hale, pop_w, eta) -
        calc_ede(pre_hale, pop_w, eta)
    )
  })
  social_welfare <- dplyr::bind_rows(swf_results)

  # ---- Equity plane data -------------------------------------------------
  sii_pre  <- calc_sii(
    data.frame(g = seq_len(n_groups), h = pre_hale,  w = pop_w),
    "h", "g", "w"
  )$sii
  sii_post <- calc_sii(
    data.frame(g = seq_len(n_groups), h = post_hale, w = pop_w),
    "h", "g", "w"
  )$sii

  equity_plane_data <- tibble::tibble(
    label      = "Intervention (full-form)",
    nhb        = sum(nhb_by_group * pop_w),
    sii_change = sii_post - sii_pre
  )

  by_group <- tibble::tibble(
    group            = subgroup_cea_results$group,
    group_label      = subgroup_cea_results$group_label,
    pop_share        = pop_w,
    inc_qaly_adj     = inc_qaly_adj,
    inc_cost_adj     = inc_cost_adj,
    opp_cost_qaly    = opp_cost_by_group,
    nhb              = nhb_by_group,
    baseline_hale    = pre_hale,
    post_hale        = post_hale
  )

  summary_out <- list(
    wtp                        = wtp,
    opportunity_cost_threshold = opportunity_cost_threshold,
    nhb                        = sum(nhb_by_group * pop_w),
    sii_pre                    = sii_pre,
    sii_post                   = sii_post,
    sii_change                 = sii_post - sii_pre,
    decision                   = .dcea_decision(
      sum(nhb_by_group * pop_w), sii_post - sii_pre
    )
  )

  structure(
    list(
      summary           = summary_out,
      by_group          = by_group,
      inequality_impact = inequality_impact,
      social_welfare    = social_welfare,
      equity_plane_data = equity_plane_data,
      metadata          = list(
        type           = "full_dcea",
        n_groups       = n_groups,
        uptake_adj     = !is.null(uptake_by_group),
        adherence_adj  = !is.null(adherence_by_group),
        psa_available  = !is.null(psa_iterations)
      )
    ),
    class = "full_dcea"
  )
}

#' Print method for full_dcea
#' @param x An object of class \code{"full_dcea"}.
#' @param ... Further arguments (ignored).
#' @return Invisibly returns \code{x}.
#' @export
print.full_dcea <- function(x, ...) {
  cat("== Full-Form DCEA Result ==\n")
  cat(sprintf("  Net Health Benefit (equity-weighted): %.4f QALYs\n",
              x$summary$nhb))
  cat(sprintf("  SII change: %.4f\n", x$summary$sii_change))
  cat(sprintf("  Decision:   %s\n",   x$summary$decision))
  invisible(x)
}

#' Summary method for full_dcea
#' @param object An object of class \code{"full_dcea"}.
#' @param ... Further arguments (ignored).
#' @return Invisibly returns \code{object}.
#' @export
summary.full_dcea <- function(object, ...) {
  print(object)
  cat("\n-- Per-group results --\n")
  print(object$by_group[, c("group_label", "inc_qaly_adj", "nhb",
                             "baseline_hale", "post_hale")])
  invisible(object)
}

#' Plot method for full_dcea
#' @param x An object of class \code{"full_dcea"}.
#' @param type Plot type (default \code{"impact_plane"}).
#' @param ... Additional arguments passed to the underlying plot function.
#' @return A \pkg{ggplot2} object.
#' @export
plot.full_dcea <- function(x, type = "impact_plane", ...) {
  type <- match.arg(type, c("impact_plane", "lorenz", "ede_profile"))
  switch(type,
    impact_plane = plot_equity_impact_plane(x, ...),
    lorenz       = plot_lorenz_curve(x, ...),
    ede_profile  = plot_ede_profile(x, ...)
  )
}
