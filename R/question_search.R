#' Creates an interactive table of Jeopardy questions
#' following given criteria, limited at 100 questions
#'
#' @param value The in-game dollar value that corresponds to the Jeopardy quesion
#' @param category The category of the question, as an id integer
#' @param min_date The earliest date to show, based on original air date
#' @param max_date The latest date to show, based on original air date
#'
#' @return An data frame of the specified questions, displays as data table in viewer.
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#' @importFrom tidyr %>%
#' @importFrom anytime anytime
#' @importFrom DT datatable
#'
#' @export

jeopardy_question_search = function(value=NULL, category=NULL, min_date=NULL, max_date=NULL){
  #max_date and min_date functionality is mixed in api
  if (!is.null(min_date)){
    min_date = anytime(min_date)
  }
  if (!is.null(max_date)){
    max_date = anytime(max_date)
  }
  request = GET('http://jservice.io/api/clues', query = list(value=value, category = category, max_date = min_date, min_date=max_date))
  content = request$content %>% rawToChar() %>% fromJSON()
  if (length(content) == 0) {
    cat("No questions fit that criteria\n")
    return()
  }

  content = clean_data(content)

  # display data frame as a data table
  print(datatable(content))

  # return data frame
  content
}


#' Cleans Jeopardy datatable for display.
#'
#' @param data The dataset to manage
#'
#' @return A clean data frame for the question_search function
#'
#' @importFrom dplyr select

clean_data = function(data){
  if (nrow(data) == 0) {
    return(data)
  }

  data = merge(data, data$category, by.x = "category_id", by.y = "id")
  data$category = data$title
  data = select(data, value, question, answer, airdate, category)
  data$airdate = gsub("T12:00:00.000Z", "", x=data$airdate)
  data$answer = gsub("<i>", "", x=data$answer)
  data$answer = gsub("</i>","", x = data$answer)
  return(data)
}

