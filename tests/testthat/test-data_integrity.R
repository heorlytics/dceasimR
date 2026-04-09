test_that("england_imd_hale has 5 rows", {
  expect_equal(nrow(england_imd_hale), 5)
})

test_that("england_imd_hale pop_share sums to 1", {
  expect_equal(sum(england_imd_hale$pop_share), 1, tolerance = 1e-6)
})

test_that("england_imd_hale HALE values increase from Q1 to Q5", {
  hale <- england_imd_hale$mean_hale_all[order(england_imd_hale$imd_quintile)]
  expect_true(all(diff(hale) > 0))
})

test_that("canada_income_hale has 5 rows", {
  expect_equal(nrow(canada_income_hale), 5)
})

test_that("canada_income_hale pop_share sums to 1", {
  expect_equal(sum(canada_income_hale$pop_share), 1, tolerance = 1e-6)
})

test_that("who_regions_hale has 6 rows", {
  expect_equal(nrow(who_regions_hale), 6)
})

test_that("who_regions_hale pop_share sums to approximately 1", {
  expect_equal(sum(who_regions_hale$pop_share), 1, tolerance = 0.01)
})

test_that("example_cea_output is a list with deterministic and psa elements", {
  expect_type(example_cea_output, "list")
  expect_true("deterministic" %in% names(example_cea_output))
  expect_true("psa" %in% names(example_cea_output))
})

test_that("example_cea_output PSA has 1000 rows", {
  expect_equal(nrow(example_cea_output$psa), 1000)
})

test_that("nsclc_dcea_example has subgroup_cea, baseline, staircase elements", {
  expect_true("subgroup_cea" %in% names(nsclc_dcea_example))
  expect_true("baseline" %in% names(nsclc_dcea_example))
  expect_true("staircase" %in% names(nsclc_dcea_example))
})

test_that("get_baseline_health returns a tibble for england", {
  result <- get_baseline_health("england", "imd_quintile")
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 5)
})

test_that("get_baseline_health errors on unknown country", {
  expect_error(get_baseline_health("atlantis"), "must be one of")
})

test_that("normalise_weights sums to 1", {
  w <- normalise_weights(c(1, 2, 3, 4, 5))
  expect_equal(sum(w), 1, tolerance = 1e-10)
})

test_that("normalise_weights errors on all-zero input", {
  expect_error(normalise_weights(rep(0, 5)), "cannot all be zero")
})

test_that("compute_ridit_scores returns values in (0, 1)", {
  r <- compute_ridit_scores(rep(0.2, 5))
  expect_true(all(r > 0 & r < 1))
})
