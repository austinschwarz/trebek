test_that("intro outputs correctly", {
  sink("../test_intro.txt")
  show_intro()
  sink()

  test_intro <- readLines('../test_intro.txt')
  correct_intro <- readLines('../correct_intro.txt')

  expect_equal(test_intro, correct_intro)
})

test_that("intro doesn't return", {
  returns <- show_intro()
  expect_true(is.null(returns))
})
