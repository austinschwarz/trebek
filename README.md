
# trebek

<!-- badges: start -->
<!-- badges: end -->

The goal of trebek is to ...

## Installation

You can install the released version of trebek from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("trebek")
```

## Examples

If you want to see a random jeopardy question
``` r
library(trebek)
random_jeopardy()
```

For more than one random question
``` r
random_jeopardy(5)
```

To see all jeopardy questions in the year 2007 worth $400
``` r
jeopardy_question_search(min_date = '2007-01-01', max_date = '2007-12-31', value = 400)
```

If you want to see all of your category options with "pants" as a substring
``` r
category_search("pants")
```
```
     id                     title clues_count
1 13617        trial participants           5
2 15279                     pants          10
3 18166              -mancy pants          10
4 10215 i'm not wearing any pants           5
```

To see the jeopardy questions in the category "i'm not wearing any pants"
``` r
jeopardy_question_search(category = 10215)
```


