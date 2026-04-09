test_that("calc_sii returns correct class and names", {
  df <- tibble::tibble(
    group      = 1:5,
    mean_hale  = c(60, 63, 66, 69, 72),
    pop_share  = rep(0.2, 5)
  )
  result <- calc_sii(df, "mean_hale", "group", "pop_share")
  expect_type(result, "list")
  expect_named(result, c("sii", "rii", "se_sii", "p_value", "model"),
               ignore.order = TRUE)
})

test_that("calc_sii SII is positive when health increases with rank", {
  df <- tibble::tibble(
    group     = 1:5,
    mean_hale = c(60, 63, 66, 69, 72),
    pop_share = rep(0.2, 5)
  )
  result <- calc_sii(df, "mean_hale", "group", "pop_share")
  expect_gt(result$sii, 0)
})

test_that("calc_sii SII is approximately correct for linear gradient", {
  # Linear health gradient from 60 to 80 across quintiles
  df <- tibble::tibble(
    group     = 1:5,
    mean_hale = seq(60, 80, by = 5),
    pop_share = rep(0.2, 5)
  )
  result <- calc_sii(df, "mean_hale", "group", "pop_share")
  expect_equal(result$sii, 20, tolerance = 2)
})

test_that("calc_sii errors on missing columns", {
  df <- tibble::tibble(group = 1:5, pop_share = rep(0.2, 5))
  expect_error(calc_sii(df, "mean_hale", "group", "pop_share"))
})

test_that("calc_atkinson_index returns 0 for perfectly equal distribution", {
  result <- calc_atkinson_index(rep(70, 5), rep(0.2, 5), epsilon = 1)
  expect_equal(result, 0, tolerance = 1e-10)
})

test_that("calc_atkinson_index returns 0 for epsilon = 0", {
  result <- calc_atkinson_index(c(60, 63, 66, 69, 72), rep(0.2, 5),
                                 epsilon = 0)
  expect_equal(result, 0)
})

test_that("calc_atkinson_index is between 0 and 1", {
  result <- calc_atkinson_index(c(60, 63, 66, 69, 72), rep(0.2, 5),
                                 epsilon = 1)
  expect_gte(result, 0)
  expect_lte(result, 1)
})

test_that("calc_atkinson_index increases with epsilon for unequal distribution", {
  h <- c(60, 63, 66, 69, 72)
  w <- rep(0.2, 5)
  a1 <- calc_atkinson_index(h, w, epsilon = 0.5)
  a2 <- calc_atkinson_index(h, w, epsilon = 1)
  a3 <- calc_atkinson_index(h, w, epsilon = 2)
  expect_lt(a1, a2)
  expect_lt(a2, a3)
})

test_that("calc_atkinson_index warns on non-positive values", {
  expect_warning(calc_atkinson_index(c(-1, 2, 3, 4, 5), rep(0.2, 5)))
})

test_that("calc_gini returns value between 0 and 1", {
  result <- calc_gini(c(60, 63, 66, 69, 72), pop_weights = rep(0.2, 5))
  expect_gte(result, 0)
  expect_lte(result, 1)
})

test_that("calc_gini returns 0 for perfectly equal distribution", {
  result <- calc_gini(rep(65, 5), pop_weights = rep(0.2, 5))
  expect_equal(result, 0, tolerance = 1e-10)
})

test_that("calc_concentration_index returns named list", {
  df <- tibble::tibble(
    group     = 1:5,
    mean_hale = c(60, 63, 66, 69, 72),
    pop_share = rep(0.2, 5)
  )
  result <- calc_concentration_index(df, "mean_hale", "group", "pop_share")
  expect_named(result, c("ci", "se", "type"), ignore.order = TRUE)
})

test_that("calc_all_inequality_indices returns a tibble", {
  df <- tibble::tibble(
    group     = 1:5,
    mean_hale = c(60, 63, 66, 69, 72),
    pop_share = rep(0.2, 5)
  )
  result <- calc_all_inequality_indices(df, "mean_hale", "group", "pop_share")
  expect_s3_class(result, "tbl_df")
  expect_true("index" %in% names(result))
  expect_true("value" %in% names(result))
})
