# Entry point for the dceasimR Shiny application
# This file is used by shiny::runApp()

source("ui.R")
source("server.R")

shiny::shinyApp(ui = ui, server = server)
