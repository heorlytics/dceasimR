test_that("run_aggregate_dcea returns correct class", {
  result <- run_aggregate_dcea(
    icer            = 25000,
    inc_qaly        = 0.5,
    inc_cost        = 12500,
    population_size = 10000,
    wtp             = 20000
  )
  expect_s3_class(result, "aggregate_dcea")
})

test_that("run_aggregate_dcea result has expected structure", {
  result <- run_aggregate_dcea(
    icer            = 25000,
    inc_qaly        = 0.5,
    inc_cost        = 12500,
    population_size = 10000,
    wtp             = 20000
  )
  expect_named(result, c("summary", "by_group", "inequality_impact",
                         "social_welfare", "equity_plane_data", "metadata"),
               ignore.order = TRUE)
})

test_that("NHB is negative when ICER > WTP (above threshold)", {
  result <- run_aggregate_dcea(
    icer            = 30000,
    inc_qaly        = 0.5,
    inc_cost        = 15000,
    population_size = 10000,
    wtp             = 20000,
    opportunity_cost_threshold = 13000
  )
  # Total NHB should be negative when ICER > OCC threshold
  expect_lt(result$summary$total_health_gain - result$summary$total_opp_cost,
            result$summary$total_health_gain)
})

test_that("by_group has 5 rows for England IMD quintile default", {
  result <- run_aggregate_dcea(
    icer            = 20000,
    inc_qaly        = 0.4,
    inc_cost        = 8000,
    population_size = 5000,
    wtp             = 20000
  )
  expect_equal(nrow(result$by_group), 5)
})

test_that("inequality_impact contains expected indices", {
  result <- run_aggregate_dcea(
    icer            = 25000,
    inc_qaly        = 0.5,
    inc_cost        = 12500,
    population_size = 10000,
    wtp             = 20000
  )
  expect_true("sii" %in% result$inequality_impact$index)
  expect_true("gini" %in% result$inequality_impact$index)
})

test_that("social_welfare has eta and ede columns", {
  result <- run_aggregate_dcea(
    icer            = 25000,
    inc_qaly        = 0.5,
    inc_cost        = 12500,
    population_size = 10000,
    wtp             = 20000
  )
  expect_true("eta" %in% names(result$social_welfare))
  expect_true("ede_pre" %in% names(result$social_welfare))
})

test_that("print.aggregate_dcea works without error", {
  result <- run_aggregate_dcea(
    icer = 25000, inc_qaly = 0.5, inc_cost = 12500, population_size = 10000
  )
  expect_output(print(result), "Aggregate DCEA")
})

test_that("plot.aggregate_dcea returns ggplot object", {
  result <- run_aggregate_dcea(
    icer = 25000, inc_qaly = 0.5, inc_cost = 12500, population_size = 10000
  )
  p <- plot(result)
  expect_s3_class(p, "ggplot")
})
