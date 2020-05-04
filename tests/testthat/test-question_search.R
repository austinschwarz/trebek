testthat::test_that("Values are Correctly Selected", {
  valuelist = c(200,400,600,800,1000)
  value = sample(valuelist,1)
  questiondf = jeopardy_question_search(value = value)
  testthat::expect_equal(mean(questiondf$value), value)
})

