#' Displays a jeopardy board that a user can select questions from
#'
#' @param n_categories How many categories in the Jeopardy table. Default is 6.
#'
#' @return None
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr mutate
#' @importFrom textshape column_to_rownames
#'
#' @export

play_jeopardy <- function(n_categories = 6) {
  show_intro()

  wait("start")
  cat("\nHere's the board:\n\n")

  # get six random categories
  off <- sample(1:18410, 1)
  cat_request <- GET(
    "http://jservice.io/api/categories",
    query=list(count=n_categories, offset=off)
  )
  cat_response <- cat_request$content %>%
    rawToChar() %>%
    jsonlite::fromJSON()
  categories <- cat_response$title
  category_ids <- cat_response$id

  # build game board
  values <- c(200, 400, 600, 800, 1000)
  questions <- data.frame(values)
  i = 1
  for (c in categories) {
    questions[c] = i:(i+4)
    i = i+5
  }

  questions <- questions %>%
    mutate(values = paste('$', values, sep = '')) %>%
    column_to_rownames('values')

  # play game
  print(questions)
  cat('\n')
  while(sum(questions!='X') > 0) {
    questions <- play_one_question(questions, category_ids)
    print(questions)
  }

}


#' Displays a jeopardy board that a user can select questions from
#'
#' @param questions questions board.
#' @param category_ids id numbers of categories corresponding to questions board columns.
#'
#' @return updated questions board
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#' @importFrom stringr str_remove

play_one_question <- function(questions, category_ids) {
  # get question as user input
  question <- NA
  while (is.na(question)) {
    question <- readline(prompt="Select a question (1-30): ")
    if ((question %>% tolower() %>% trimws()) %in% c('exit','quit')) {
      cat("\nBye!")
      stop(call. = FALSE)
    }
    question <- suppressWarnings(as.numeric(question))
    if (is.na(question) | question < 1 | question > 30) {
      cat("Please select an question number between 1 and 30, according to the table above.")
      question <- NA
    }
  }

  # location of this question
  value_location <- ifelse(question%%5 == 0, 5, question%%5)
  category_location <- ceiling(question/5)

  if (questions[value_location, category_location] == 'X') {
    cat("Question has already been used, please select another.\n")
    return(questions)
  }
  questions[value_location, category_location] <- 'X'

  # category id and
  category <- category_ids[category_location]
  value <- rownames(questions)[value_location]
  value_num <- str_remove(value, '\\$') %>% as.numeric()

  # find the question
  q_request <- httr::GET(
    "http://jservice.io/api/clues",
    query=list(category = category, value = value_num)
  )
  q_response <- q_request$content %>% rawToChar() %>% fromJSON() %>% data.frame
  q <- data.frame(q_response)[sample(1:nrow(q_response), 1),]

  cat(paste(
    q$category$title,
    ' for ', value, ':\n',
    q$question %>%
      strwrap(., simplify = FALSE) %>%
      unlist() %>%
      paste(collapse = '\n'),
    '\n\n',
    sep = ''
  ))

  wait("see answer")

  cat(paste(
    'What is ', q$answer, '?\n\n',
    sep = ''
  ))

  wait("continue")

  questions
}

#' Displays intro to the game of Jeopardy
#'
#' @return None
#'

show_intro <- function() {
  cat("\n\nTHIS IS...")

  cat(paste(
    "\n   _                                _       ",
    "  (_)                              | |      ",
    "   _  ___  ___  _ __   __ _ _ __ __| |_   _ ",
    "  | |/ _ \\/ _ \\| '_ \\ / _` | '__/ _` | | | |",
    "  | |  __/ (_) | |_) | (_| | | | (_| | |_| |",
    "  | |\\___|\\___/| .__/ \\__,_|_|  \\__,_|\\__, |",
    " _/ |          | |                     __/ |",
    "|__/           |_|                    |___/ ",
    sep = '\n'
  ))

  cat(paste(
    "\n\nNow entering the studio are today's contenstents, YOU!!!\n",
    sep = '\n'
  ))
}


wait <- function(to = "") {
  ready <- readline(prompt = paste('Press Enter', to))
}

