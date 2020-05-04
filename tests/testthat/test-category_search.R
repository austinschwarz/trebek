test_that("category search returns a data frame", {
  categories <- category_search("pants")
  expect_equal(class(categories), "data.frame")
})
