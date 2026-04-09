#' Build inequality staircase data from component inputs
#'
#' Constructs the five-step inequality staircase data frame from individual
#' component vectors. The staircase traces how the distribution of health
#' gains is shaped at each stage: prevalence, eligibility, uptake, clinical
#' effect, and net opportunity cost.
#'
#' @param group Integer vector of group identifiers (1 = most deprived).
#' @param group_labels Character vector of group labels.
#' @param prevalence Numeric vector: disease prevalence by group (proportion).
#' @param eligibility Numeric vector: proportion eligible for the intervention
#'   by group.
#' @param uptake Numeric vector: uptake rate by group (0-1).
#' @param clinical_effect Numeric vector: incremental QALY gain by group.
#' @param opportunity_cost Numeric vector: QALYs displaced per group via
#'   budget impact.
#'
#' @return A tibble in long format suitable for
#'   \code{\link{plot_inequality_staircase}}.
#' @export
#'
#' @examples
#' build_staircase_data(
#'   group         = 1:5,
#'   group_labels  = paste("IMD Q", 1:5),
#'   prevalence    = c(0.08, 0.07, 0.06, 0.05, 0.04),
#'   eligibility   = c(0.70, 0.72, 0.74, 0.76, 0.78),
#'   uptake        = c(0.60, 0.64, 0.68, 0.72, 0.76),
#'   clinical_effect = c(0.30, 0.38, 0.45, 0.52, 0.58),
#'   opportunity_cost = c(0.05, 0.05, 0.05, 0.05, 0.05)
#' )
build_staircase_data <- function(group, group_labels,
                                  prevalence, eligibility, uptake,
                                  clinical_effect, opportunity_cost) {
  step_labels <- c(
    "1. Disease prevalence",
    "2. Eligibility",
    "3. Uptake / access",
    "4. Clinical effect (QALY gain)",
    "5. Net benefit\n(after opportunity cost)"
  )
  net_benefit <- clinical_effect - opportunity_cost

  steps_list <- list(
    prevalence, eligibility, uptake, clinical_effect, net_benefit
  )

  rows <- lapply(seq_along(step_labels), function(s) {
    tibble::tibble(
      step        = s,
      step_label  = step_labels[s],
      group       = group,
      group_label = group_labels,
      value       = steps_list[[s]]
    )
  })
  dplyr::bind_rows(rows)
}
