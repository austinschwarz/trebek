
# trebek

<!-- badges: start -->
<!-- badges: end -->

The goal of trebek is to have access to jeopardy questions, using the [jservice.io](http://jservice.io) API created by [sottenad](https://github.com/sottenad/jService). 

Our main functions allow you to display **random jeopardy questions**, **query categories**, and **query questions**, as well as **play your own game of Jeopardy**!

## Installation

You can install trebek from github with:

``` r
library(devtools)
install_github("taustinschwarz/trebek")

library(trebek)
```

## Examples

#### If you want to see a random jeopardy question
``` r
random_jeopardy()
```
```
"elves" for 600:
In the Harry Potter books, Winky, Kreacher & Dobby are this
type of elf belonging to wizarding families

Press Enter see answer
What is house elves?
```

#### For more than one random question
``` r
random_jeopardy(5)
```
```
"4-syllable words" for 200:
Mission: this 10-letter word meaning hopelessly difficult;
the clue will self-destruct in one second

Press Enter see answer
What is impossible?

Press Enter for next question
"sherwood forest" for 800:
...
...
```

#### To see all jeopardy questions in the year 2007 worth $400
``` r
jeopardy_question_search(min_date = '2007-01-01', max_date = '2007-12-31', value = 400)
```
```
[returns a dataframe and displays results as a searchable data table]
```

#### If you want to see all of your category options with "pants" as a substring
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

#### To see the jeopardy questions in the category "i'm not wearing any pants"
``` r
jeopardy_question_search(category = 10215)
```
```
     value     question       answer        airdate         category                      category_id
1    200       On Sept...     David         2007-05-25      i'm not wearing any pants     10215
...
...
```

