library(shiny)

ui <- fluidPage(
  title = "dceasimR — Interactive DCEA",
  theme = if (requireNamespace("shinydashboard", quietly = TRUE)) NULL else NULL,

  titlePanel(
    div(
      h2("dceasimR", style = "display: inline; color: #2C5F8A;"),
      h4("Distributional Cost-Effectiveness Analysis",
         style = "display: inline; margin-left: 10px; color: #555;")
    )
  ),

  tabsetPanel(
    id = "main_tabs",

    # ---- Panel 1: CEA Input -----------------------------------------------
    tabPanel(
      "1. CEA Input",
      br(),
      fluidRow(
        column(4,
          wellPanel(
            h4("Base-case CEA parameters"),
            numericInput("icer",            "ICER (£/QALY):",        value = 25000, min = 0),
            numericInput("inc_qaly",        "Incremental QALYs:",    value = 0.5,   min = 0, step = 0.01),
            numericInput("inc_cost",        "Incremental cost (£):", value = 12500, min = 0),
            numericInput("population_size", "Eligible population:",  value = 10000, min = 1),
            hr(),
            sliderInput("wtp", "WTP threshold (£/QALY):",
                        min = 10000, max = 50000, value = 20000, step = 1000),
            sliderInput("occ_threshold", "Opportunity cost threshold (£/QALY):",
                        min = 8000, max = 20000, value = 13000, step = 500),
            textInput("disease_icd", "Disease ICD-10 code (optional):", placeholder = "e.g. C34")
          )
        ),
        column(8,
          h4("CEA input summary"),
          tableOutput("cea_summary_table"),
          br(),
          div(class = "alert alert-info",
            strong("Note:"), " The opportunity cost threshold reflects the health
            value of care displaced by the intervention's budget impact. NICE
            currently uses £13,000/QALY as the central estimate."
          )
        )
      )
    ),

    # ---- Panel 2: Equity Setup -------------------------------------------
    tabPanel(
      "2. Equity Setup",
      br(),
      fluidRow(
        column(4,
          wellPanel(
            h4("Baseline health distribution"),
            selectInput("country", "Country:",
                        choices = c("England" = "england",
                                    "Canada"  = "canada",
                                    "WHO Regions" = "who_regions"),
                        selected = "england"),
            selectInput("equity_var", "Equity variable:",
                        choices = c("IMD quintile"   = "imd_quintile",
                                    "Income quintile" = "income_quintile",
                                    "WHO region"      = "who_region"),
                        selected = "imd_quintile"),
            selectInput("sex_filter", "Sex:",
                        choices = c("All" = "all", "Male" = "male",
                                    "Female" = "female")),
            hr(),
            h4("Patient distribution"),
            checkboxInput("custom_dist", "Override patient distribution?",
                          value = FALSE),
            conditionalPanel(
              "input.custom_dist == true",
              p("Enter proportion of patients in each group (must sum to 1):"),
              uiOutput("custom_dist_inputs")
            )
          )
        ),
        column(8,
          h4("Baseline health by group"),
          tableOutput("baseline_table"),
          plotOutput("lorenz_pre", height = "300px")
        )
      )
    ),

    # ---- Panel 3: Results ------------------------------------------------
    tabPanel(
      "3. Results",
      br(),
      actionButton("run_dcea", "Run DCEA Analysis",
                   class = "btn-primary btn-lg"),
      br(), br(),
      conditionalPanel(
        "output.results_ready",
        fluidRow(
          column(3,
            div(class = "panel panel-default",
              div(class = "panel-heading", "Net Health Benefit"),
              div(class = "panel-body", textOutput("nhb_card"))
            )
          ),
          column(3,
            div(class = "panel panel-default",
              div(class = "panel-heading", "SII Change"),
              div(class = "panel-body", textOutput("sii_card"))
            )
          ),
          column(6,
            div(class = "panel panel-default",
              div(class = "panel-heading", "Decision"),
              div(class = "panel-body", textOutput("decision_card"))
            )
          )
        ),
        hr(),
        fluidRow(
          column(6,
            h4("Equity-Efficiency Impact Plane"),
            plotOutput("impact_plane_plot", height = "400px")
          ),
          column(6,
            h4("Per-group NHB"),
            tableOutput("by_group_table")
          )
        ),
        hr(),
        h4("Inequality indices"),
        tableOutput("inequality_table")
      )
    ),

    # ---- Panel 4: Sensitivity --------------------------------------------
    tabPanel(
      "4. Sensitivity Analysis",
      br(),
      conditionalPanel(
        "output.results_ready",
        fluidRow(
          column(4,
            wellPanel(
              h4("EDE profile (eta sensitivity)"),
              sliderInput("eta_max", "Maximum eta:", min = 2, max = 30, value = 10),
              plotOutput("ede_profile_plot", height = "300px")
            )
          ),
          column(8,
            h4("One-way sensitivity"),
            plotOutput("tornado_plot", height = "400px")
          )
        )
      ),
      conditionalPanel(
        "!output.results_ready",
        div(class = "alert alert-warning",
          "Please run the DCEA analysis in Panel 3 first.")
      )
    ),

    # ---- Panel 5: Export -------------------------------------------------
    tabPanel(
      "5. Export",
      br(),
      conditionalPanel(
        "output.results_ready",
        fluidRow(
          column(4,
            wellPanel(
              h4("Download results"),
              downloadButton("download_excel", "Download Excel (NICE format)",
                             class = "btn-success"),
              br(), br(),
              downloadButton("download_impact_plane", "Download Impact Plane (PNG)"),
              br(), br(),
              downloadButton("download_report", "Download HTML Report")
            )
          ),
          column(8,
            h4("NICE submission table preview"),
            tableOutput("nice_table_preview")
          )
        )
      ),
      conditionalPanel(
        "!output.results_ready",
        div(class = "alert alert-warning",
          "Please run the DCEA analysis in Panel 3 first.")
      )
    )
  )
)
