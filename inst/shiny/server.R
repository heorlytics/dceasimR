library(shiny)
library(dceasimR)

server <- function(input, output, session) {

  # ---- Reactive: baseline health -----------------------------------------
  baseline <- reactive({
    get_baseline_health(input$country, input$equity_var,
                        sex = input$sex_filter)
  })

  # ---- Reactive: DCEA result ---------------------------------------------
  dcea_result <- reactiveVal(NULL)
  results_ready <- reactiveVal(FALSE)

  observeEvent(input$run_dcea, {
    tryCatch({
      sub_dist <- NULL
      if (input$custom_dist) {
        n <- nrow(baseline())
        vals <- vapply(seq_len(n), function(i) {
          input[[paste0("dist_", i)]] %||% (1 / n)
        }, numeric(1))
        sub_dist <- vals / sum(vals)
      }

      result <- run_aggregate_dcea(
        icer                       = input$icer,
        inc_qaly                   = input$inc_qaly,
        inc_cost                   = input$inc_cost,
        population_size            = input$population_size,
        wtp                        = input$wtp,
        disease_icd                = if (nzchar(input$disease_icd))
                                       input$disease_icd else NULL,
        subgroup_distribution      = sub_dist,
        baseline_health            = baseline(),
        opportunity_cost_threshold = input$occ_threshold
      )
      dcea_result(result)
      results_ready(TRUE)
    }, error = function(e) {
      showNotification(paste("Error:", e$message), type = "error")
    })
  })

  output$results_ready <- reactive({ results_ready() })
  outputOptions(output, "results_ready", suspendWhenHidden = FALSE)

  # ---- Panel 1 outputs ---------------------------------------------------
  output$cea_summary_table <- renderTable({
    data.frame(
      Parameter = c("ICER (£/QALY)", "Incremental QALYs", "Incremental cost",
                    "Population size", "WTP threshold", "OCC threshold"),
      Value = c(
        scales::comma(input$icer),
        round(input$inc_qaly, 4),
        scales::comma(input$inc_cost),
        scales::comma(input$population_size),
        scales::comma(input$wtp),
        scales::comma(input$occ_threshold)
      )
    )
  })

  # ---- Panel 2 outputs ---------------------------------------------------
  output$baseline_table <- renderTable({
    bl <- baseline()
    cols <- intersect(c("group_label", "group", "mean_hale", "pop_share",
                        "cumulative_rank"), names(bl))
    bl[, cols]
  })

  output$lorenz_pre <- renderPlot({
    bl <- baseline()
    if ("mean_hale" %in% names(bl)) {
      ld <- compute_lorenz_data(bl$mean_hale, bl$pop_share, "Baseline")
      ggplot2::ggplot(ld, ggplot2::aes(.data$cum_pop, .data$cum_health)) +
        ggplot2::geom_line(colour = "steelblue", linewidth = 1) +
        ggplot2::geom_abline(linetype = "dashed") +
        ggplot2::labs(x = "Cumulative population", y = "Cumulative health",
                      title = "Baseline Lorenz Curve") +
        ggplot2::theme_minimal()
    }
  })

  output$custom_dist_inputs <- renderUI({
    n <- nrow(baseline())
    bl <- baseline()
    labs <- if ("group_label" %in% names(bl)) bl$group_label else
      paste("Group", seq_len(n))
    lapply(seq_len(n), function(i) {
      numericInput(paste0("dist_", i), labs[i],
                   value = round(1 / n, 3), min = 0, max = 1, step = 0.01)
    })
  })

  # ---- Panel 3 outputs ---------------------------------------------------
  output$nhb_card <- renderText({
    req(results_ready())
    paste(round(dcea_result()$summary$nhb, 1), "QALYs")
  })

  output$sii_card <- renderText({
    req(results_ready())
    paste(round(dcea_result()$summary$sii_change, 4))
  })

  output$decision_card <- renderText({
    req(results_ready())
    dcea_result()$summary$decision
  })

  output$impact_plane_plot <- renderPlot({
    req(results_ready())
    plot_equity_impact_plane(dcea_result())
  })

  output$by_group_table <- renderTable({
    req(results_ready())
    bg <- dcea_result()$by_group
    bg[, c("group_label", "baseline_hale", "post_hale", "nhb")]
  })

  output$inequality_table <- renderTable({
    req(results_ready())
    dcea_result()$inequality_impact
  })

  # ---- Panel 4 outputs ---------------------------------------------------
  output$ede_profile_plot <- renderPlot({
    req(results_ready())
    plot_ede_profile(dcea_result(), eta_range = seq(0, input$eta_max, 0.2))
  })

  output$tornado_plot <- renderPlot({
    req(results_ready())
    sa <- run_dcea_sensitivity(dcea_result(),
                               params_to_vary = c("wtp", "occ_threshold"))
    plot_dcea_tornado(sa)
  })

  # ---- Panel 5 outputs ---------------------------------------------------
  output$nice_table_preview <- renderTable({
    req(results_ready())
    generate_nice_table(dcea_result(), format = "tibble")
  })

  output$download_excel <- downloadHandler(
    filename = function() paste0("dcea_results_", Sys.Date(), ".xlsx"),
    content  = function(file) {
      req(results_ready())
      export_dcea_excel(dcea_result(), file)
    }
  )

  output$download_impact_plane <- downloadHandler(
    filename = function() paste0("impact_plane_", Sys.Date(), ".png"),
    content  = function(file) {
      req(results_ready())
      p <- plot_equity_impact_plane(dcea_result())
      ggplot2::ggsave(file, plot = p, width = 7, height = 6, dpi = 150)
    }
  )

  output$download_report <- downloadHandler(
    filename = function() paste0("dcea_report_", Sys.Date(), ".html"),
    content  = function(file) {
      req(results_ready())
      generate_dcea_report(dcea_result(), format = "html", filepath = file)
    }
  )
}
