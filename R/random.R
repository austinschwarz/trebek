#' Gets random jeopardy questions from the API
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
random_jeopardy <- function(num_questions=1) {

  request <- GET("http://jservice.io/api/random",query=list(count=num_questions))

  content <- (request$content %>% rawToChar() %>% fromJSON())
  content <- merge(content, content$category, by.x = 'category_id', by.y = 'id')

  for (row in 1:nrow(content)){

    q <- content[row,]

    display_question(q)

    if (!row == nrow(content)){

      wait("for next question")
    }
  }
}

#' Waits for enter key before continuing
#'
#' @param to what will happen after you press enter. Default empty string.
#'
#' @return None
wait <- function(to = "") {
  ready <- readline(prompt = paste('Press Enter', to))
}


#' Displays the question in a standardized format
#'
#' @param question a question as a row of a data frame.
#'
#' @return None
#'
#' @export
display_question <- function(question) {

  cat(paste(
    '"', question$title, '"',
    ' for ', question$value, ':\n',
    question$question %>%
      strwrap(., simplify = FALSE) %>%
      unlist() %>%
      paste(collapse = '\n'),
    '\n\n',
    sep = ''
  ))

  wait("to see answer")

  cat(paste(
    'What is ', question$answer, '?\n\n',
    sep = ''
  ))
}

