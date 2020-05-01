#' Gets random questions from the API
#'
#' @param num_questions number of question you want returned
#'
#' @return returns a vector of q's
#'
#' @import dplyr
#' @import httr
#' @importFrom jsonlite fromJSON
#'
#' @export

get_trivia_qs <- function(num_questions=1) {

  request <- GET("http://jservice.io/api/random",query=list(count=num_questions))

  content <- (request$content %>% rawToChar() %>% fromJSON())

  for (row in 1:nrow(content)){

    q <- content[row,]

    print(paste("Category: ", q$category$title))

    print(q$question)

    menu(c("Yes"), title="Ready to see answer?")

    print(q$answer)

    if (!row == nrow(content)){

      menu(c("Yes"), title="Ready for next question?")
    }
  }
}


