test_that("run_full_dcea returns correct class", {
  baseline <- get_baseline_health("england", "imd_quintile")
  subgroup <- tibble::tibble(
    group       = 1:5,
    group_label = paste("IMD Q", 1:5),
    inc_qaly    = c(0.3, 0.38, 0.45, 0.52, 0.58),
    inc_cost    = rep(10000, 5),
    pop_share   = rep(0.2, 5)
  )
  result <- run_full_dcea(subgroup, baseline)
  expect_s3_class(result, "full_dcea")
})

test_that("run_full_dcea result has expected names", {
  baseline <- get_baseline_health("england", "imd_quintile")
  subgroup <- tibble::tibble(
    group     = 1:5, group_label = paste("IMD Q", 1:5),
    inc_qaly  = rep(0.4, 5), inc_cost = rep(10000, 5), pop_share = rep(0.2, 5)
  )
  result <- run_full_dcea(subgroup, baseline)
  expect_named(result, c("summary", "by_group", "inequality_impact",
                         "social_welfare", "equity_plane_data", "metadata"),
               ignore.order = TRUE)
})

test_that("run_full_dcea applies uptake adjustment", {
  baseline <- get_baseline_health("england", "imd_quintile")
  subgroup <- tibble::tibble(
    group     = 1:5, group_label = paste("IMD Q", 1:5),
    inc_qaly  = rep(0.5, 5), inc_cost = rep(10000, 5), pop_share = rep(0.2, 5)
  )
  uptake <- c(0.5, 0.6, 0.7, 0.8, 0.9)
  result <- run_full_dcea(subgroup, baseline, uptake_by_group = uptake)
  # With unequal uptake, inc_qaly should differ across groups
  expect_false(all(result$by_group$inc_qaly_adj == result$by_group$inc_qaly_adj[1]))
})

test_that("print.full_dcea works", {
  baseline <- get_baseline_health("england", "imd_quintile")
  subgroup <- tibble::tibble(
    group     = 1:5, group_label = paste("IMD Q", 1:5),
    inc_qaly  = rep(0.4, 5), inc_cost = rep(10000, 5), pop_share = rep(0.2, 5)
  )
  result <- run_full_dcea(subgroup, baseline)
  expect_output(print(result), "Full-Form DCEA")
})
