#' Gets random questions from the API
#'
#' @param num_questions number of question you want returned
#'
#' @return returns a vector of q's
#'
#' @export
#'

get_trivia_qs <- function(num_questions=1) {

  request <- GET("jservice.io/api/random",query=list(count=num_questions))

  request$content %>% rawToChar() %>% fromJSON()
}
