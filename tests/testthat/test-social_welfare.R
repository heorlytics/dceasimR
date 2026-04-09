test_that("calc_ede equals arithmetic mean when eta = 0", {
  health  <- c(60, 65, 70, 75, 80)
  weights <- rep(0.2, 5)
  expect_equal(calc_ede(health, weights, eta = 0), mean(health),
               tolerance = 1e-6)
})

test_that("calc_ede equals geometric mean when eta = 1", {
  health  <- c(60, 65, 70, 75, 80)
  weights <- rep(0.2, 5)
  geom_mean <- exp(mean(log(health)))
  expect_equal(calc_ede(health, weights, eta = 1), geom_mean, tolerance = 1e-6)
})

test_that("calc_ede decreases as eta increases for unequal distribution", {
  health  <- c(60, 63, 66, 69, 72)
  weights <- rep(0.2, 5)
  ede_0 <- calc_ede(health, weights, eta = 0)
  ede_1 <- calc_ede(health, weights, eta = 1)
  ede_5 <- calc_ede(health, weights, eta = 5)
  expect_gt(ede_0, ede_1)
  expect_gt(ede_1, ede_5)
})

test_that("calc_ede returns NA with warning for non-positive health", {
  expect_warning(result <- calc_ede(c(-1, 5, 6), c(0.33, 0.33, 0.34), eta = 1))
  expect_true(is.na(result))
})

test_that("calc_ede equals mean for perfectly equal distribution", {
  health  <- rep(65, 5)
  weights <- rep(0.2, 5)
  for (eta in c(0, 1, 2, 5)) {
    expect_equal(calc_ede(health, weights, eta = eta), 65, tolerance = 1e-6)
  }
})

test_that("calc_ede_profile returns tibble with correct columns", {
  profile <- calc_ede_profile(c(60, 65, 70), c(1/3, 1/3, 1/3),
                               eta_range = 0:5)
  expect_s3_class(profile, "tbl_df")
  expect_named(profile, c("eta", "ede"))
  expect_equal(nrow(profile), 6)
})

test_that("calc_social_welfare returns expected names", {
  pre  <- c(60, 63, 66, 69, 72)
  post <- c(61, 64, 67, 70, 73)
  w    <- rep(0.2, 5)
  result <- calc_social_welfare(pre, post, w, eta = 1)
  expect_named(result, c("ede_baseline", "ede_post", "delta_ede",
                         "efficiency_component", "equity_component"),
               ignore.order = TRUE)
})

test_that("calc_equity_weights: deprived groups get higher weight when eta > 0", {
  health  <- c(60, 63, 66, 69, 72)
  weights <- rep(0.2, 5)
  ew <- calc_equity_weights(health, weights, eta = 1)
  # Q1 (lowest HALE) should have highest weight
  expect_gt(ew[1], ew[5])
})

test_that("calc_equity_weights returns weights with mean = 1 when normalised", {
  health  <- c(60, 63, 66, 69, 72)
  weights <- rep(0.2, 5)
  ew <- calc_equity_weights(health, weights, eta = 1, normalise = TRUE)
  expect_equal(sum(weights * ew), 1, tolerance = 1e-10)
})

test_that("calc_equity_weighted_nhb returns scalar", {
  nhb <- c(100, 120, 140, 160, 180)
  ew  <- c(1.4, 1.2, 1.0, 0.9, 0.8)
  w   <- rep(0.2, 5)
  result <- calc_equity_weighted_nhb(nhb, ew, w)
  expect_length(result, 1)
  expect_true(is.numeric(result))
})
