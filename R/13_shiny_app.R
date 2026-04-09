#' Launch the interactive DCEA Shiny Application
#'
#' Opens a browser-based graphical interface for performing DCEA without
#' writing R code. The app provides panels for CEA input, equity setup,
#' results visualisation, sensitivity analysis, and export. Suitable for
#' manufacturers preparing NICE submissions or analysts exploring equity
#' impacts interactively.
#'
#' @param browser Logical. Open the app in the default browser
#'   (default: \code{TRUE}).
#' @param port Integer. Local port to use. If \code{NULL} (default), a
#'   randomly available port is used.
#'
#' @return Invisible \code{NULL}. The function blocks until the Shiny app
#'   is stopped.
#' @export
#'
#' @examples
#' \dontrun{
#'   launch_dcea_app()
#' }
launch_dcea_app <- function(browser = TRUE, port = NULL) {
  if (!requireNamespace("shiny", quietly = TRUE)) {
    rlang::abort(
      "Package 'shiny' is required to launch the DCEA app. ",
      "Install it with: install.packages('shiny')"
    )
  }
  app_dir <- system.file("shiny", package = "dceasimR")
  if (!nzchar(app_dir) || !file.exists(app_dir)) {
    rlang::abort("Shiny app directory not found in dceasimR installation.")
  }
  shiny::runApp(app_dir, launch.browser = browser, port = port)
}
