test_that("display question correctly",{

  fake_row <- t(as.data.frame(c(
    500,"what did the fox say?",
    "whocares",2002-06-12,
    "animals",42),col.names=c("1")))

  rownames(fake_row) <- c("1")

  colnames(fake_row) <- c("value","question","answer","airdate","title","category_id")

  fake_row <- as.data.frame(fake_row,stringsAsFactors = FALSE)

  answer <- capture.output(display_question(fake_row))

  expected_answer <- paste("What is ", fake_row[1,3], "?",sep='')

  expect_equal(fake_row[1,2],answer[2])

  expect_equal(expected_answer,answer[5])
})
