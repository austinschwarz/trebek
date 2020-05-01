#' Allows a user to see their category options.
#' Defaults to all options, or shows those that contain the provided query as a substring.
#'
#' @param query A substring of the category name to match.
#'
#' @return Category titles and Ids matching the query, as a data frame.
#'
#' @importFrom dplyr filter
#'
#' @examples category_search("pants")
#'
#' @export
category_search <- function(query = '') {
  if (!exists('all_categories')) {
    cat('Downloading categories data frame from API. This may take a moment.\n(Only done once per session.)')
    get_categories()
  }
  all_categories %>%
    filter(grepl(query, title))
}

#' Gets all categories in the API
#'
#' @returns all categories as a data frame
get_categories <- function() {
  offset = 0
  categories <- query_categories(offset)
  while (offset < 18410) {
    offset = offset + 100
    categories <- rbind(
      categories,
      query_categories(offset)
    )
  }
  categories <- unique(categories)
  all_categories <<- categories
  cat('Categories saved as data frame in variable all_categories.\n')
}

#' Queries the API for categories given an offset
#'
#' @param offset offsets the returned categories. Useful in pagination
#'
#' @returns 100 categories as a data frame
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
query_categories <- function(offset) {
  cat_request <- GET(
    "http://jservice.io/api/categories",
    query=list(count=100, offset=offset)
  )
  cat_response <- cat_request$content %>%
    rawToChar() %>%
    jsonlite::fromJSON()
  cat_response
}

