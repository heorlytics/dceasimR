#' Generate NICE-formatted DCEA submission table
#'
#' Creates a summary table formatted according to NICE (2025) Methods Support
#' Document guidance for DCEA as supplementary evidence in technology
#' appraisals.
#'
#' @param dcea_result Object of class \code{"aggregate_dcea"} or
#'   \code{"full_dcea"}.
#' @param format Output format: \code{"tibble"} (default), \code{"flextable"},
#'   \code{"html"}, or \code{"xlsx"}.
#' @param include_psa Logical. Include probabilistic uncertainty columns if
#'   PSA data are available (default: \code{FALSE}).
#'
#' @return A formatted table object of the requested type.
#' @export
#'
#' @examples
#' result <- run_aggregate_dcea(
#'   icer = 25000, inc_qaly = 0.5, inc_cost = 12500,
#'   population_size = 10000, wtp = 20000
#' )
#' generate_nice_table(result, format = "tibble")
generate_nice_table <- function(dcea_result, format = "tibble",
                                 include_psa = FALSE) {
  .check_dcea_class(dcea_result)
  format <- match.arg(format, c("tibble", "flextable", "html", "xlsx"))

  bg  <- dcea_result$by_group
  smr <- dcea_result$summary
  ii  <- dcea_result$inequality_impact

  sii_row <- ii[ii$index == "sii", ]

  tbl <- tibble::tibble(
    `Equity subgroup` = bg$group_label,
    `Baseline HALE (years)` = round(bg$baseline_hale, 2),
    `Post-intervention HALE (years)` = round(bg$post_hale, 2),
    `Change in HALE (years)` = round(bg$post_hale - bg$baseline_hale, 4),
    `Net Health Benefit (QALYs)` = round(bg$nhb, 2),
    `Population share` = scales::comma(round(bg$pop_share, 3))
  )

  # Summary row
  summary_row <- tibble::tibble(
    `Equity subgroup` = "Total / Summary",
    `Baseline HALE (years)` = NA_real_,
    `Post-intervention HALE (years)` = NA_real_,
    `Change in HALE (years)` = NA_real_,
    `Net Health Benefit (QALYs)` = round(smr$nhb, 2),
    `Population share` = "1.000"
  )

  tbl_full <- dplyr::bind_rows(tbl, summary_row)

  if (format == "tibble") return(tbl_full)

  if (format == "flextable") {
    if (!requireNamespace("flextable", quietly = TRUE)) {
      rlang::abort("Package 'flextable' is required for format = 'flextable'.")
    }
    ft <- flextable::flextable(tbl_full)
    ft <- flextable::bold(ft, i = nrow(tbl_full))
    ft <- flextable::set_caption(ft, "Distributional Cost-Effectiveness Analysis \u2014 NICE Submission Table")
    return(ft)
  }

  if (format == "html") {
    return(knitr::kable(tbl_full, format = "html",
                        caption = "DCEA Summary Table (NICE format)"))
  }

  if (format == "xlsx") {
    rlang::abort("Use export_dcea_excel() for xlsx output.")
  }
}

#' Export DCEA results to Excel (NICE submission format)
#'
#' Writes a multi-sheet Excel workbook with NICE-formatted DCEA output,
#' including the summary table, per-group results, inequality indices, and
#' social welfare profile.
#'
#' @param dcea_result Object of class \code{"aggregate_dcea"} or
#'   \code{"full_dcea"}.
#' @param filepath Output \code{.xlsx} file path (character).
#' @param include_plots Logical. Embed plots as images in the Excel workbook
#'   (default: \code{FALSE}).
#'
#' @return Invisibly returns \code{filepath}.
#' @export
#'
#' @examples
#' \dontrun{
#' result <- run_aggregate_dcea(
#'   icer = 25000, inc_qaly = 0.5, inc_cost = 12500,
#'   population_size = 10000, wtp = 20000
#' )
#' export_dcea_excel(result, "my_dcea_results.xlsx")
#' }
export_dcea_excel <- function(dcea_result, filepath, include_plots = FALSE) {
  .check_dcea_class(dcea_result)
  if (!requireNamespace("openxlsx", quietly = TRUE)) {
    rlang::abort("Package 'openxlsx' is required for export_dcea_excel().")
  }

  wb <- openxlsx::createWorkbook()

  # Sheet 1: Summary table
  openxlsx::addWorksheet(wb, "DCEA Summary")
  nice_tbl <- generate_nice_table(dcea_result, format = "tibble")
  openxlsx::writeData(wb, "DCEA Summary", nice_tbl)

  # Sheet 2: Per-group results
  openxlsx::addWorksheet(wb, "Per-Group Results")
  openxlsx::writeData(wb, "Per-Group Results", dcea_result$by_group)

  # Sheet 3: Inequality impact
  openxlsx::addWorksheet(wb, "Inequality Indices")
  openxlsx::writeData(wb, "Inequality Indices", dcea_result$inequality_impact)

  # Sheet 4: Social welfare profile
  openxlsx::addWorksheet(wb, "Social Welfare Profile")
  openxlsx::writeData(wb, "Social Welfare Profile",
                      dcea_result$social_welfare)

  openxlsx::saveWorkbook(wb, filepath, overwrite = TRUE)
  message("DCEA results exported to: ", filepath)
  invisible(filepath)
}

#' Generate a full DCEA report
#'
#' Renders a complete DCEA report as an HTML, Word, or PDF document using
#' R Markdown.
#'
#' @param dcea_result Object of class \code{"aggregate_dcea"} or
#'   \code{"full_dcea"}.
#' @param format Output format: \code{"html"} (default), \code{"word"},
#'   \code{"pdf"}.
#' @param filepath Output file path. If \code{NULL}, a temporary file is used
#'   and the report is opened in a browser.
#' @param template Report template: \code{"nice_submission"} (default),
#'   \code{"academic"}, \code{"cadth"}.
#'
#' @return Invisibly returns the output file path.
#' @export
#'
#' @examples
#' \dontrun{
#' result <- run_aggregate_dcea(
#'   icer = 25000, inc_qaly = 0.5, inc_cost = 12500,
#'   population_size = 10000, wtp = 20000
#' )
#' generate_dcea_report(result, format = "html")
#' }
generate_dcea_report <- function(dcea_result, format = "html",
                                  filepath = NULL, template = "nice_submission") {
  .check_dcea_class(dcea_result)
  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    rlang::abort("Package 'rmarkdown' is required for generate_dcea_report().")
  }

  format   <- match.arg(format, c("html", "word", "pdf"))
  template <- match.arg(template, c("nice_submission", "academic", "cadth"))

  if (is.null(filepath)) {
    ext      <- switch(format, html = ".html", word = ".docx", pdf = ".pdf")
    filepath <- tempfile(pattern = "dcea_report_", fileext = ext)
  }

  # Create a temporary Rmd script
  rmd_content <- .build_report_rmd(dcea_result, template)
  rmd_path    <- tempfile(fileext = ".Rmd")
  writeLines(rmd_content, rmd_path)

  out_format <- switch(format,
    html = rmarkdown::html_document(toc = TRUE),
    word = rmarkdown::word_document(),
    pdf  = rmarkdown::pdf_document()
  )

  rmarkdown::render(rmd_path, output_format = out_format,
                    output_file = filepath, quiet = TRUE)
  message("Report written to: ", filepath)
  invisible(filepath)
}

# Internal: build Rmd content for the report
.build_report_rmd <- function(dcea_result, template) {
  smr <- dcea_result$summary
  paste0(
    '---\ntitle: "DCEA Report"\ndate: "', Sys.Date(), '"\n---\n\n',
    '## Key Results\n\n',
    '- Net Health Benefit: **', round(smr$nhb, 2), ' QALYs**\n',
    '- SII change: **', round(smr$sii_change, 4), '**\n',
    '- Decision: **', smr$decision, '**\n\n',
    '## Per-Group Results\n\n',
    '```{r echo=FALSE}\nknitr::kable(dcea_result$by_group)\n```\n\n',
    '## Inequality Indices\n\n',
    '```{r echo=FALSE}\nknitr::kable(dcea_result$inequality_impact)\n```\n'
  )
}
