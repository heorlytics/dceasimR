test_that("plot_equity_impact_plane returns ggplot for aggregate_dcea", {
  result <- run_aggregate_dcea(
    icer = 25000, inc_qaly = 0.5, inc_cost = 12500,
    population_size = 10000, wtp = 20000
  )
  p <- plot_equity_impact_plane(result)
  expect_s3_class(p, "ggplot")
})

test_that("plot_lorenz_curve returns ggplot", {
  result <- run_aggregate_dcea(
    icer = 25000, inc_qaly = 0.5, inc_cost = 12500,
    population_size = 10000, wtp = 20000
  )
  p <- plot_lorenz_curve(result)
  expect_s3_class(p, "ggplot")
})

test_that("plot_ede_profile returns ggplot", {
  result <- run_aggregate_dcea(
    icer = 25000, inc_qaly = 0.5, inc_cost = 12500,
    population_size = 10000, wtp = 20000
  )
  p <- plot_ede_profile(result, eta_range = 0:5)
  expect_s3_class(p, "ggplot")
})

test_that("plot_equity_impact_plane errors on wrong class", {
  expect_error(plot_equity_impact_plane(list(x = 1)),
               "must be of class")
})

test_that("plot_inequality_staircase returns ggplot", {
  sc <- build_staircase_data(
    group           = 1:5,
    group_labels    = paste("Q", 1:5),
    prevalence      = c(0.08, 0.07, 0.06, 0.05, 0.04),
    eligibility     = c(0.70, 0.72, 0.74, 0.76, 0.78),
    uptake          = c(0.60, 0.65, 0.70, 0.75, 0.80),
    clinical_effect = c(0.3, 0.38, 0.45, 0.52, 0.58),
    opportunity_cost = rep(0.05, 5)
  )
  p <- plot_inequality_staircase(sc)
  expect_s3_class(p, "ggplot")
})
