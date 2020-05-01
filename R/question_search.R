#' Creates an interactive table of selected Jeopardy questions
#'
#' @param value The in-game dollar value that corresponds to the Jeopardy quesion
#' @param category The category of the question, as an id integer
#' @param min_date The earliest date to show, based on original air date
#' @param max_date The latest date to show, based on original air date
#'
#' @return An interactive table of the specified questions.
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#' @importFrom tidyr %>%
#' @importFrom anytime anytime
#' @importFrom DT datatable
#'
#' @export

question_search = function(value=NULL, category=NULL, min_date=NULL, max_date=NULL){
  #max_date and min_date functionality is mixed in api
  if (!is.null(min_date)){
    min_date = anytime(min_date)
  }
  if (!is.null(max_date)){
    max_date = anytime(max_date)
  }
  request = GET('http://jservice.io/api/clues', query = list(value=value, category = category, max_date = min_date, min_date=max_date))
  content = request$content %>% rawToChar() %>% fromJSON()
  content = datacleaning(content)
  datatable(content)
}


#' Cleans Jeopardy datatable for display.
#'
#' @param data The dataset to manage
#'
#' @return A clean data table for the question_search function
#'
#' @importFrom dpylr select

datacleaning = function(data){
  data = merge(data, data$category, by.x = "category_id", by.y = "id")
  data$category = data$title
  data = select(data, value, question, answer, airdate, category)
  data$airdate = gsub("T12:00:00.000Z", "", x=data$airdate)
  data$answer = gsub("<i>", "", x=data$airdate)
  data$answer = gsub("</i>","", x = data$airdate)
  return(data)
}

