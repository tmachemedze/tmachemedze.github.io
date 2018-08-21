# Getting started with R

## Introduction

This guide was prepared using RStudio and therefore you might need to launch RStudio if you want to follow the coding. **Note**: there are several other IDEs for R other than RStudio and you can as well use whichever IDE you are comfortable with.

Most R commands adopt the following syntax:
  
  `> command(argument1, argument2, ...,)`
  
Any R command needs to be followed by brackets. Using RStudio, you can either type your commands at the console and press enter or type in the script editor (`Menu -> New File -> R Script`) and press the `Run` button to the top right corner of the same window. Alternatively, selected/highlighted parts of an R script file can be run pressing `Ctrl + Enter` and the whole script can be run by pressing `Ctrl + Alt + R`. 

## Organize your R session

### Working directory

We check the current working directory by typing:


```r
getwd()
```

```
## [1] "C:/stata2rcourse"
```

We set another working directory by typing:

`setwd("path_to_directory"`

Note that R uses forward slashes to separate directories or you can use double back slashes. 

### Load (and install) required libraries

To install a package, we type:

`install.packages("package name")`

Unlike in Stata where you just need to install an ado file and start running the programme, in R you need to load the package in each session where it is required. The command for loading a package is:

`library(package name)`

### Comments

`#` denotes a comment. Anything after the `#` is not evaluated and ignored in R

## Getting help

R has several help functions as described below:


* `help(solve)` or `?solve` - access help page for command `solve`.

    * useful only if you already know the name of the function that you wish to use.

* `apropos()` - searches for objects, including functions, directly accessible in the current R session that have names that include a specified character string. For example: `apropos("glm")`.
* `help.search("solve")`  and `??solve` - scans the documentation for packages installed in your library for commands which could be related to string `solve`.

* `help.start()` - Start the hypertext (currently HTML) version of R's online documentation. 

* `RSiteSearch()`  - uses an internet search engine to search for information in function help pages. For example: `RSiteSearch("glm")`.

* `example(exp)` - examples for the usage of `exp`.

* `example("*")` - special characters have to be in quotation marks.

* Some packages provides a demonstration of the R functionality and typying `demo()` will return a list of all demos and the associated packages. 

* For tricky questions, error messages and other issues, use [Google](https://www.google.com/) (include "in R" to the end of your query).

* Thre is also a search engine just for `R`, [RSeek](https://rseek.org/).

* [StackOverflow](https://stackoverflow.com/) is also a great resource with many questions for many specific packages in R and a rating system for answers.

## Output file

**`sink()` function**

For example:

`sink(file="output_file_name.txt")`

The `sink(file="output_file_name.txt")` function redirects output to the file `"output_file_name.txt"` and saves to your current working directory.By default, if the file already exists, its contents are overwritten. Include the option `append=TRUE` to append text to the file rather than overwriting it. Including the option `split=TRUE` will send output to both the screen and the output file. Issuing the command `sink()` without options will return output to the screen alone.

Unfortunately, compared to the Stata log file system, the `sink()` function only save the output, i.e. results with no code. It appears as if there is no straight forward way of having both "input" line and "output" results. One of the suggested solutions is to save output with `sink()` and input with `savehistory()` separately. We will show how to save command history in the section to follow.

## Objects in R

It is possible and usual to have multiple pieces of data simultaneously open during an R session. These include datasets, summary tables, graphs, derived variables, functions, e.t.c. All these are referred to as objects. In fact, everything in R is an object and each can be manipulated independently in many ways.  

For example, lets assign `x` to be 5 and `y` to be 3:


```r
x<-5
y<-3
```
where `<-` (the less than sign plus the minus) is an assignment operator. `x` is assigned a value 5 and `y` a value 3.

`x` and `y` can be accessed by simply typing the object name:


```r
x
```

```
## [1] 5
```

```r
y
```

```
## [1] 3
```

A list of all objects loaded in the workspace can be retrieved by typing:


```r
ls()
```

```
## [1] "x" "y"
```

There are several classes or types of objects in R which have distinct properties. By comparison, the Stata [course](http://www.saldru.uct.ac.za/courses/) introduced tabular datasets with variables and observations. There are also macros and scalars in Stata. 

The R equivalent of a Stata dataset is called a `data frame`. This is the data structure we are going to be working with most of the time. A **factor** is another important data structure in R especially when working with survey data. Basically a factor is equivalent to a categorical variable (a variable with value labels) in Stata. Other common object classes include:  vectors, matrices, lists, etc. Describing R objects and their properties (data types and structures) is well beyond the purpose of this guide and users interested should consult the online documentation for further explanations.

### Removing objects from the R environment - rm() function

All R objects are stored in the memory of the computer, limiting the available space for calculation to the size of the **RAM** on your machine. To do more we need to learn how to manipulate the workspace and R makes organizing the workspace easy. The object `x` can be removed by typing:


```r
rm(x)  # remove object x
```

Check:


```r
ls()
```

```
## [1] "y"
```

We can see that we now only have `y` in the workspace.

To remove everything in in the workspace, you type:


```r
rm(list=ls()) #or rm(object1,object2) to remove specific objects, object1 and object2
```

Check:


```r
ls()
```

```
## character(0)
```

## Saving in R

By default, R keeps track of all the commands you use in a session.You can browse the history from the command line by pressing the up-arrow and down-arrow keys. When you press the up-arrow key, you get the commands you typed earlier at the command line.

You can as well type the following commands to retrieve or save the history: (taken from [statmethods](https://www.statmethods.net/interface/workspace.html) website):

`history()` - work with previous commands and display last 25 commands

`savehistory(file="myfile")` - save your command history, default is ".Rhistory"

`loadhistory(file="myfile")` - recall your command history, default is ".Rhistory"


Objects in the current workspace can also be saved and loaded using the following commands:


`save.image()` - save the workspace to the file .RData in the current working directory 

`save(objectlist,file="myfile.RData")` - save specific objects to a file, if you don't specify the path, the current working directory is assumed

`load("myfile.RData")` - load a workspace into the current session if you don't specify the path, the current working directory is assumed 

You can quit the current workspace by simply typing:

`q()` - to quit R. You will be prompted to save the workspace. The are also options to tell R to/not to save, check help results for `?q()`


## Importing NIDS data into R

In this document, we use a [National Income Dynamics Study (NIDS)](http://www.nids.uct.ac.za/) training dataset used in the corresponding Stata [course](http://www.saldru.uct.ac.za/courses/). Therefore it is important to note that this is **NOT** the NIDS dataset that can be used to do serious analysis. If you need proper NIDS data, you need to apply for the data on the [DataFirst](https://datafirst.uct.ac.za/) website.

[DataFirst](https://datafirst.uct.ac.za/) provides microdata mainly in SAS, SPSS and Stata formats. It is possible to import either of these formats into R. For purposes of this course, we will import the Stata files with extension ".dta" and it is not difficult to import the other formats. 

In order to import the data file, we need to employ the services of the `foreign` package [@R-foreign]. The foreign package has functions to import, for example, Stata (`read.dta()`), SPSS (`read.spss()`) and other formats.

It is important to note that the `foreign` package can only read Stata files up to version 12. However, `haven` [@R-haven], a recently new package provides an alternative way to import Stata (up to version 14), SAS and SPSS data files into R. 

Before we call functions from the `foreign` package [@R-foreign], we first need to load the package.


```r
#install.packages("foreign") # to install if not installed
library(foreign)
```

The data is in a subfolder of the current working directory called "data".



```r
nids<-read.dta("./data/nids.dta", convert.factors=FALSE)
```

You can check arguments of the `read.dta()` function by typing `?read.dta`. Note that I have instructed R not to use Stata value labels to create factors. The reason for doing this and for this specific dataset is that factors in R have underlying values which are natural numbers (1,2,3,...). NIDS used negative numbers for different missing types, e.g.,   -9 (Don't Know), -8 (Refused) and -3 (Missing). Setting `convert.factors=TRUE` or the default will not necessarily lead to losing data but the aforementioned value labels will be forced to be 1 (Don't Know), 2 (Refused) and 3 (Missing), i.e. natural numbers starting from the smallest. A factor is a very special and sometimes frustrating data type in R. While factors in R are comparable to categorical variables in Stata, the two programmes handle them differently. Factors in R look (and often behave) like character vectors but they are actually integers under the hood, and you need to be careful when treating them like strings or when converting to numeric. 
 
The NIDS dataset is loaded in the workspace as a `nids` data frame, i.e. we have assigned (`nids<-`) the imported object to `nids` but you can give it any other name. Lets explore the data to get a better understanding. 

## Exploring the data

**`dim()`** - We can use the base R `dim()` function to get dimensions of tabular data by typing:


```r
dim(nids)
```

```
## [1] 31170  2089
```

The dimensions are the number of rows and number of columns respectively. One can see that there are 31170 observations (rows) and 2089 variables (columns) in the dataset.

### Subsetting data - part 1

Here we introduce the concept of subsetting data in R. To subset is to select specific elements of a data set. Since we have too many variables and we do not know anything about them yet, I will start by introducing the square bracket or matrix index notation.

We have a `nids` data frame with rows (observations) and columns (variables). Therefore, elements of nids are in the form:

`nids[rows,columns]` 

if you want to think of this in matrix notation. The comma is crucial here since the dataset is organized by rows and columns.  

Each row and column can be identified by its number between the square brackets. For example, if we type:


```r
nids[2,7]
```

```
## [1] 1
```

we will get the value of the second observation of the 7th column in the data. 

We can as well type:


```r
nids[1:10,1:8]
```

```
##      hhqi   hhid    pid w1_r_b1 w1_r_phase w1_r_b1_1 w1_r_b3 w1_r_b4
## 1  201020 103034 301011       1          1         1       1       2
## 2  201015 103037 301012       1          1         1       1       2
## 3  201015 103037 301013       3          1         1       4       1
## 4  201015 103037 301014       2          1         1       8       2
## 5  201019 103050 301015       2          1         1       3       2
## 6  201018 103046 301016       6          1         1       4       1
## 7  201018 103046 301017       2          1         1       1       1
## 8  201022 103049 301018       1          1         1       1       2
## 9  201022 103049 301019       2          1         1       4       2
## 10 201022 103049 301020       3          1         1       8       1
```

which returns the first 10 observations `1:10` and the first 8 columns `1:8`. The `:` is an integer sequence operator, i.e. for example, `1:3` returns integers 1,2,3. 

It is not always the case that you want to select everything in the range of certain integer, row or columns, and therefore we use the `c()` function to specifify the rows or columns that we need. Here, `c()` creates a vector based on the numbers you input. For example `c(1,2,3)` is equivalent to `1:3` as decribed above. However, `c()` allows to input non-sequential integers.

For example:

`nids[c(1:5,8),]` - to select rows 1 to 5 and 8

`nids[,c(1,2,3,7,8)]` - to select columns 1,2,3,7 and 8

To do the above in one line:


```r
nids[c(1:5,8),c(1,2,3,7,8)]
```

```
##     hhqi   hhid    pid w1_r_b3 w1_r_b4
## 1 201020 103034 301011       1       2
## 2 201015 103037 301012       1       2
## 3 201015 103037 301013       4       1
## 4 201015 103037 301014       8       2
## 5 201019 103050 301015       3       2
## 8 201022 103049 301018       1       2
```

Given that our dataset has too many variables to print to screen (2089 variables) and that we are now able to subset specific elements of our dataset, we introduce other functions.

**names()**

`names` returns the names of the variables in the selected data frame. For example, We can see `names` of the first eight variables (columns) by typing:


```r
names(nids[,1:8])
```

```
## [1] "hhqi"       "hhid"       "pid"        "w1_r_b1"    "w1_r_phase"
## [6] "w1_r_b1_1"  "w1_r_b3"    "w1_r_b4"
```

**head(), tail()**

The R functions `head()` and `tail()` return the first 6 and last 6 parts of a vector, matrix, table and data frame. For our dataset:  


```r
head(nids[,1:8])
```

```
##     hhqi   hhid    pid w1_r_b1 w1_r_phase w1_r_b1_1 w1_r_b3 w1_r_b4
## 1 201020 103034 301011       1          1         1       1       2
## 2 201015 103037 301012       1          1         1       1       2
## 3 201015 103037 301013       3          1         1       4       1
## 4 201015 103037 301014       2          1         1       8       2
## 5 201019 103050 301015       2          1         1       3       2
## 6 201018 103046 301016       6          1         1       4       1
```


```r
tail(nids[,1:8])
```

```
##         hhqi   hhid pid w1_r_b1 w1_r_phase w1_r_b1_1 w1_r_b3 w1_r_b4
## 31165 209107 105648  NA       4          1         2      13       1
## 31166 207825 103699  NA       2          1         2       4       1
## 31167 201494 102647  NA       1          1         2       2       1
## 31168 201530 101684  NA       4          1         2      12       2
## 31169 202052 111168  NA       1          1         2       1       1
## 31170 207775 104193  NA       7          1         2       4       2
```

**str()** - compactly display the internal structure of an R object. Perhaps the most useful diagnostic function in R. `str` is short for structure and you can use it on any object. The structure of the first 8 variables are as follows:


```r
str(nids[,1:8])
```

```
## 'data.frame':	31170 obs. of  8 variables:
##  $ hhqi      : int  201020 201015 201015 201015 201019 201018 201018 201022 201022 201022 ...
##  $ hhid      : int  103034 103037 103037 103037 103050 103046 103046 103049 103049 103049 ...
##  $ pid       : int  301011 301012 301013 301014 301015 301016 301017 301018 301019 301020 ...
##  $ w1_r_b1   : int  1 1 3 2 2 6 2 1 2 3 ...
##  $ w1_r_phase: int  1 1 1 1 1 1 1 1 1 1 ...
##  $ w1_r_b1_1 : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ w1_r_b3   : int  1 1 4 8 3 4 1 1 4 8 ...
##  $ w1_r_b4   : int  2 2 1 2 2 1 1 2 2 1 ...
```

We see that the subsetted dataset is a data frame with `31170` observations, `8` variables (as expected), their names, all of integer variable type (`int`) and the first 10 observations.

### Data documentation - value and variable labels

So far we have managed to import the data and view subset of its elements. However, we do not know what each of the variable names are or what the numbers represent. This is where we need the documentation about the data or a codebook with a description of the variable names, variable description and value labels, e.t.c

You can find some of this information in the questionnaires provided. We have also included a codebook with a list of variable names and their description. The codebook was prepared using an R package called `memisc` from the imported stata file. The Stata course made it easy by using the Stata `lookfor` function, but for this guide, you need to search in the documents (questionnaires and codebook) for more information.

**Note:** NIDS data from the [DataFirst website](https://datafirst.uct.ac.za/) has consistent standard names that are slightly different from the ones in this training dataset.

### Operators in R

As we use these commands, we will often want to use qualifiers and operators. By using these options, we can restrict the specified R command to a specific sub-population.

Qualifiers and operators add more detail to the data exploration commands that we will be using. For instance, what if we wanted to explore information specific to a particular group or person only? This is where the qualifier and operators are used. Using qualifiers and operators allows us to apply R commands to specific observations in the data. To make things a bit more clear, here are some examples:


<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
<caption>(\#tab:unnamed-chunk-19)Operators</caption>
 <thead>
  <tr>
   <th style="text-align:left;"> Operator </th>
   <th style="text-align:left;"> Description </th>
  </tr>
 </thead>
<tbody>
  <tr grouplength="5"><td colspan="2" style="border-bottom: 1px solid;"><strong>Arithmetic Operators</strong></td></tr>
<tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> \+ </td>
   <td style="text-align:left;"> addition </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> \- </td>
   <td style="text-align:left;"> subtraction </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> \* </td>
   <td style="text-align:left;"> multiplication </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> / </td>
   <td style="text-align:left;"> division </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> ^ or ** </td>
   <td style="text-align:left;"> exponentiation </td>
  </tr>
  <tr grouplength="9"><td colspan="2" style="border-bottom: 1px solid;"><strong>Logical Operators</strong></td></tr>
<tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> &lt; </td>
   <td style="text-align:left;"> less than </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> &lt;= </td>
   <td style="text-align:left;"> less than or equal to </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> &gt; </td>
   <td style="text-align:left;"> greater than </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> &gt;= </td>
   <td style="text-align:left;"> greater than or equal to </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> == </td>
   <td style="text-align:left;"> exactly equal to </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> != </td>
   <td style="text-align:left;"> not equal to </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> !x </td>
   <td style="text-align:left;"> not x </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> x | y </td>
   <td style="text-align:left;"> x or y </td>
  </tr>
  <tr>
   <td style="text-align:left; padding-left: 2em;" indentlevel="1"> x &amp; y </td>
   <td style="text-align:left;"> x and y </td>
  </tr>
</tbody>
</table>


### Subsetting data - part 2

Here we introduce another subset notation, the `subset` function. The basic structure of subset is like this:

`subset(x, condition, select=c(var1, var2))`

where x is the original dataset you want to subset, condition is a condition on your rows, and select is the columns you want to keep. 

For example, if we want to examine the age (`w1_r_best_age_yrs`), race (`w1_best_race`) and highest educational qualification achieved (`w1_r_b7`) by all those aged 90 and above, we type:


```r
head(subset(nids, 
            subset = w1_r_best_age_yrs>90, 
            select = c(w1_r_best_age_yrs, w1_best_race, w1_r_b7)))
```

```
##      w1_r_best_age_yrs w1_best_race w1_r_b7
## 575                101            1      25
## 925                 94            1      25
## 1293                92            1      25
## 1844                95            1      25
## 1887                99            1      25
## 1905                93            1      25
```

Where: 

`x` is `nids`;

`condition` or `subset` is `w1_r_best_age_yrs>90` and

 variable `select`ion is `c(w1_r_best_age_yrs, w1_best_race, w1_r_b7)`


## Tidyverse

### Brief introduction to tidyverse

So far we have introduced the `foreign` package to import data and performing some basic data exploration using some base R functions. There are other base R functions that can perform a number of other operations. However, as mentioned in the introduction, the power of R is also derived from packages that make some of the processes easier to follow and efficient.

Here, we introduce `tidyverse` [@R-tidyverse], a collection of modern R packages that share common philosophies, embed best practices, and are designed to work together. The [tidyverse](https://www.tidyverse.org/) is the collective name given to a suite of R packages designed mostly by Hadley Wickham. All tidyverse packages share an underlying design philosophy, grammar, and data structures. At the time of writing this document, members of the `tidyverse` (or individual packages) include: `broom`, `dplyr`, `forcats`, `ggplot2`, `haven`, `httr`, `hms`, `jsonlite`, `lubridate`, `magrittr`, `modelr`, `purrr`, `readr`, `readxl`, `stringr`, `tibble`, `rvest`, `tidyr`, `xml2`.

### Core tidyverse packages

The core tidyverse packages and their main functions are:

* `ggplot2` - for data visualisation [@R-ggplot2].

* `dplyr` - for data manipulation - the data wrangling workhorse [@R-dplyr].

* `tidyr` - for data tidying [@R-tidyr].

* `readr` - for data import [@R-readr].

* `purrr` - for functional programming [@R-purrr].

* `tibble` - for tibbles, a modern reimagining of data frames [@R-tibble].

You can install `tidyverse` packages by typing:

### Install and load tidyverse packages

To install `tidyverse packages`, we type:

`install.packages("tidyverse")`

and to load the packages:

`library("tidyverse")`

### dplyr verbs

`dplyr` [@R-dplyr] is one of the most important packages for data manipulation and it implements five fundamental verbs for data wrangling:

`filter()` – rows by their values

`arrange()` – reorder rows

`select()` – pick and/or exclude columns

`mutate()` – create new columns

`summarize()` – collapse rows with summaries

And any of the above may be scoped over a group of rows with:

`group_by()` – define groups based on categorical variables


### Using dplyr functions

Arguments:

* First argument is the data frame to work on

* Following arguments define what to do on which named columns in the data frame. Result is always another data frame:

### Pipe operator %>%

Pipes takes the result of the left hand side (LHS) and pushes into the first argument of the right hand side (RHS):

`%>%` is the pipe "operator". It takes what is on the left hand side and puts it in the right hand side’s function.

## More data exploration

Here, we demonstrate how to perform some tasks using both base R and tidyverse functions. However, this guide will use more of the tidyverse functions as we explore further.

The tidyverse packages are already installed and we load as follows:


```r
library(tidyverse)
```

```
## -- Attaching packages ----------------------- tidyverse 1.2.1 --
```

```
## v ggplot2 3.0.0     v purrr   0.2.5
## v tibble  1.4.2     v dplyr   0.7.6
## v tidyr   0.8.1     v stringr 1.3.1
## v readr   1.1.1     v forcats 0.3.0
```

```
## -- Conflicts -------------------------- tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

For now you can ignore the warnings and messages.

### Example 1: Subset variables

Our first task is to view the first few elements for age (`w1_r_best_age_yrs`), race (`w1_best_race`) and highest educational qualification (`w1_r_b7`) for every respondent in the dataset. We are going to use the `head()` function on a subset of the variables mentioned.

**Option 1 - matrix index**


```r
head(nids[,c('w1_r_best_age_yrs', 'w1_best_race', 'w1_r_b7')])
```

```
##   w1_r_best_age_yrs w1_best_race w1_r_b7
## 1                -9            4      12
## 2                66            4      10
## 3                26            4       9
## 4                78            4       7
## 5                46            4      10
## 6                -9            4      12
```


**Option 2 - subset**


```r
head(subset(nids, select=c(w1_r_best_age_yrs, w1_best_race, w1_r_b7)))
```

```
##   w1_r_best_age_yrs w1_best_race w1_r_b7
## 1                -9            4      12
## 2                66            4      10
## 3                26            4       9
## 4                78            4       7
## 5                46            4      10
## 6                -9            4      12
```

**Option 3 - dplyr**


```r
nids %>% 
  select(w1_r_best_age_yrs, w1_best_race, w1_r_b7) %>% # pick columns
  head()
```

```
##   w1_r_best_age_yrs w1_best_race w1_r_b7
## 1                -9            4      12
## 2                66            4      10
## 3                26            4       9
## 4                78            4       7
## 5                46            4      10
## 6                -9            4      12
```

The `dplyr` option takes the object `nids` then (`%>%`) select the variables then (`%>%`) list the first few observations

### Example 2: Subset observations

Lets view contents of first few observations where race (`w1_best_race`) equals 3; the number 3 in this case refers to Indians, thus only information for Indian respondents will be displayed.

For this subset, we will suppress the command since it will print all variables to screen and fill several pages.

**Option 1 - matrix index**


```r
#head(nids[nids$w1_best_race==3,])
```

The `$` sign allows you to extract elements of the data frame by name, i.e., `dataframe_name$column_name`.

**Option 2 - subset**


```r
#head(subset (nids, subset=w1_best_race == 3))
```

**Option 3 - dplyr**


```r
#nids %>%
#  filter(w1_best_race == 3) %>% # filter rows by values
#  head()
```


### Example 3: Subset both observations and variables

In this example, we want to print all the observations for the race variable where age of the individual is greater than 90. 

**Option 1 - matrix index**


```r
nids[nids$w1_r_best_age_yrs > 90,c("w1_best_race")]
```

```
##  [1]  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
## [24]  1  2  2  1  1  1  1  1  1  1  1  1  2  1  2  1  1  1  3  4  2  2 NA
## [47] NA
```

**Option 2 - subset**

```r
subset(nids, subset=w1_r_best_age_yrs > 90,select=c(w1_best_race))
```

```
##       w1_best_race
## 575              1
## 925              1
## 1293             1
## 1844             1
## 1887             1
## 1905             1
## 3031             1
## 3300             1
## 3332             1
## 3430             1
## 4362             1
## 4954             1
## 6625             1
## 6627             1
## 7261             1
## 7734             1
## 7945             1
## 9203             1
## 9513             1
## 11194            1
## 11415            1
## 11593            1
## 12309            1
## 12374            1
## 12673            2
## 12726            2
## 12749            1
## 12930            1
## 12972            1
## 13849            1
## 13890            1
## 14469            1
## 14625            1
## 26620            1
## 26768            1
## 26907            2
## 27285            1
## 27394            2
## 27404            1
## 27587            1
## 27645            1
## 27792            3
## 27799            4
## 28117            2
## 28195            2
## 29246           NA
## 30220           NA
```

**Option 3 - dplyr**


```r
nids %>% 
  filter(w1_r_best_age_yrs > 90) %>%
  select(w1_best_race)
```

```
##    w1_best_race
## 1             1
## 2             1
## 3             1
## 4             1
## 5             1
## 6             1
## 7             1
## 8             1
## 9             1
## 10            1
## 11            1
## 12            1
## 13            1
## 14            1
## 15            1
## 16            1
## 17            1
## 18            1
## 19            1
## 20            1
## 21            1
## 22            1
## 23            1
## 24            1
## 25            2
## 26            2
## 27            1
## 28            1
## 29            1
## 30            1
## 31            1
## 32            1
## 33            1
## 34            1
## 35            1
## 36            2
## 37            1
## 38            2
## 39            1
## 40            1
## 41            1
## 42            3
## 43            4
## 44            2
## 45            2
## 46           NA
## 47           NA
```


When you try the above commands, you will note that two of the observations for race are recorded as a missing value, `NA`. If you wanted to list the race of all individuals older than 90 years old and did not want to list those for whom race was missing, you could type:

**Option 1 - matrix index**


```r
nids[nids$w1_r_best_age_yrs > 90 & !is.na(nids$w1_best_race),c("w1_best_race")]
```

```
##  [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 1 1 1 1 1 1 1 1 1
## [36] 2 1 2 1 1 1 3 4 2 2
```

**Option 2 - subset**

```r
subset(nids, subset=w1_r_best_age_yrs > 90 & !is.na(w1_best_race),select=c(w1_best_race))
```

```
##       w1_best_race
## 575              1
## 925              1
## 1293             1
## 1844             1
## 1887             1
## 1905             1
## 3031             1
## 3300             1
## 3332             1
## 3430             1
## 4362             1
## 4954             1
## 6625             1
## 6627             1
## 7261             1
## 7734             1
## 7945             1
## 9203             1
## 9513             1
## 11194            1
## 11415            1
## 11593            1
## 12309            1
## 12374            1
## 12673            2
## 12726            2
## 12749            1
## 12930            1
## 12972            1
## 13849            1
## 13890            1
## 14469            1
## 14625            1
## 26620            1
## 26768            1
## 26907            2
## 27285            1
## 27394            2
## 27404            1
## 27587            1
## 27645            1
## 27792            3
## 27799            4
## 28117            2
## 28195            2
```

**Option 3 - dplyr**


```r
nids %>%
  filter(w1_r_best_age_yrs > 90 & !is.na(w1_best_race)) %>%
  select(w1_best_race) 
```

```
##    w1_best_race
## 1             1
## 2             1
## 3             1
## 4             1
## 5             1
## 6             1
## 7             1
## 8             1
## 9             1
## 10            1
## 11            1
## 12            1
## 13            1
## 14            1
## 15            1
## 16            1
## 17            1
## 18            1
## 19            1
## 20            1
## 21            1
## 22            1
## 23            1
## 24            1
## 25            2
## 26            2
## 27            1
## 28            1
## 29            1
## 30            1
## 31            1
## 32            1
## 33            1
## 34            1
## 35            1
## 36            2
## 37            1
## 38            2
## 39            1
## 40            1
## 41            1
## 42            3
## 43            4
## 44            2
## 45            2
```

In the above, `is.na(x)` returns a logical value that is `TRUE` if x is missing and FALSE otherwise. By the same reasoning, `!is.na(x)` returns a logical value that is `TRUE` if `x` is not (`!`) missing and `FALSE` otherwise.

With NIDS being the National Income Dynamics Survey, there are obviously a large amount of variables dealing with various forms of income. We will be dealing mainly with the variable for imputed total household monthly income, `w1_hhincome`. This variable is calculated by aggregating all forms of income from the adult questionnaire. How do you think you would get R to list the incomes and races of all those households that earn over R75 000 per month as well as listing their race and age?

From now onwards, we will adopt `dplyr` functions to manipulate the data. The `dplyr` functions offers a more intuitive way of writing code by using the pipe `%>%` operator. To extract the income information, we can type:


```r
nids %>% 
  filter(w1_hhincome> 75000) %>%
  select(w1_best_race, w1_r_best_age_yrs, w1_hhincome) 
```

```
##    w1_best_race w1_r_best_age_yrs w1_hhincome
## 1             4                57    87082.52
## 2             4                46    87082.52
## 3             1                29    89981.23
## 4             3                18    79500.00
## 5             3                56    79500.00
## 6             1                23   100070.00
## 7             1                39    93800.00
## 8             4                36   130000.00
## 9             1                58    84200.00
## 10            1                23    84200.00
## 11            1                50    84200.00
## 12            1                21    84200.00
## 13            1                65    89981.23
## 14            1                63    89981.23
## 15            1                21   100070.00
## 16            4                19   112000.00
## 17            4                58   112000.00
## 18            4                41   102033.33
## 19            4                17   102033.33
## 20            4                45   102033.33
## 21            1                17    89981.23
## 22            1                29    89981.23
## 23            4                70   137239.22
## 24            4                65   137239.22
## 25            3                44    79500.00
## 26            3                17    79500.00
## 27            4                52    86500.00
## 28            3                15    79500.00
## 29            4                21    77397.88
## 30            4                19    77397.88
## 31            4                41    84066.66
## 32            4                44    77397.88
## 33            4                44    77397.88
## 34            4                24    77397.88
## 35            4                54   106605.23
## 36            2                68   106605.23
## 37            4                57   106605.23
## 38            4                39    84066.66
## 39            4                57    99000.00
## 40            3                52    99000.00
## 41            4                56    75908.09
## 42            4                14   130000.00
## 43            4                14   102033.33
## 44            4                12   130000.00
## 45            4                10    84066.66
## 46            4                 4    84066.66
## 47            4                 5    75908.09
## 48            4                13    77397.88
## 49            3                14    99000.00
## 50            1                 0    89981.23
## 51            1                 5    89981.23
## 52            1                15    84200.00
## 53            4                61    75908.09
## 54            4                57    86500.00
## 55            4                59   112000.00
```

We see that there are some 4 and 5 years olds listed in the output. Why do you think this is? It can often be useful to also include the household identifier variable to see which respondents come from the same household. Use the “up-arrow” key to include the household identifier variable, `hhid`, in the variables that are listed.


```r
nids %>% 
  filter(w1_hhincome> 75000) %>%
  select(hhid,w1_best_race, w1_r_best_age_yrs,w1_hhincome) 
```

```
##      hhid w1_best_race w1_r_best_age_yrs w1_hhincome
## 1  107006            4                57    87082.52
## 2  107006            4                46    87082.52
## 3  113860            1                29    89981.23
## 4  170283            3                18    79500.00
## 5  170283            3                56    79500.00
## 6  107242            1                23   100070.00
## 7  112961            1                39    93800.00
## 8  170611            4                36   130000.00
## 9  105215            1                58    84200.00
## 10 105215            1                23    84200.00
## 11 105215            1                50    84200.00
## 12 105215            1                21    84200.00
## 13 113860            1                65    89981.23
## 14 113860            1                63    89981.23
## 15 107242            1                21   100070.00
## 16 170533            4                19   112000.00
## 17 170533            4                58   112000.00
## 18 107067            4                41   102033.33
## 19 107067            4                17   102033.33
## 20 107067            4                45   102033.33
## 21 113860            1                17    89981.23
## 22 113860            1                29    89981.23
## 23 170593            4                70   137239.22
## 24 170593            4                65   137239.22
## 25 170283            3                44    79500.00
## 26 170283            3                17    79500.00
## 27 175112            4                52    86500.00
## 28 170283            3                15    79500.00
## 29 109426            4                21    77397.88
## 30 109426            4                19    77397.88
## 31 171093            4                41    84066.66
## 32 109426            4                44    77397.88
## 33 109426            4                44    77397.88
## 34 109426            4                24    77397.88
## 35 109253            4                54   106605.23
## 36 109253            2                68   106605.23
## 37 109253            4                57   106605.23
## 38 171093            4                39    84066.66
## 39 101257            4                57    99000.00
## 40 101257            3                52    99000.00
## 41 109186            4                56    75908.09
## 42 170611            4                14   130000.00
## 43 107067            4                14   102033.33
## 44 170611            4                12   130000.00
## 45 171093            4                10    84066.66
## 46 171093            4                 4    84066.66
## 47 109186            4                 5    75908.09
## 48 109426            4                13    77397.88
## 49 101257            3                14    99000.00
## 50 113860            1                 0    89981.23
## 51 113860            1                 5    89981.23
## 52 105215            1                15    84200.00
## 53 109186            4                61    75908.09
## 54 175112            4                57    86500.00
## 55 170533            4                59   112000.00
```

You should find that members of the same household are listed directly above one another. This is because the data has been sorted according to the household identifier. We can choose to change the way in which the data is sorted using the `arrange` command. For instance, we may wish to have the data ordered according to income.


```r
nids<-nids %>% arrange(w1_hhincome)
```

The above command assign `nids` to be `nids` sorted by `w1_hhincome`.


```r
nids %>% 
  filter(w1_hhincome> 75000) %>%
  select(hhid,w1_best_race, w1_r_best_age_yrs,w1_hhincome)
```

```
##      hhid w1_best_race w1_r_best_age_yrs w1_hhincome
## 1  109186            4                56    75908.09
## 2  109186            4                 5    75908.09
## 3  109186            4                61    75908.09
## 4  109426            4                21    77397.88
## 5  109426            4                19    77397.88
## 6  109426            4                44    77397.88
## 7  109426            4                44    77397.88
## 8  109426            4                24    77397.88
## 9  109426            4                13    77397.88
## 10 170283            3                18    79500.00
## 11 170283            3                56    79500.00
## 12 170283            3                44    79500.00
## 13 170283            3                17    79500.00
## 14 170283            3                15    79500.00
## 15 171093            4                41    84066.66
## 16 171093            4                39    84066.66
## 17 171093            4                10    84066.66
## 18 171093            4                 4    84066.66
## 19 105215            1                58    84200.00
## 20 105215            1                23    84200.00
## 21 105215            1                50    84200.00
## 22 105215            1                21    84200.00
## 23 105215            1                15    84200.00
## 24 175112            4                52    86500.00
## 25 175112            4                57    86500.00
## 26 107006            4                57    87082.52
## 27 107006            4                46    87082.52
## 28 113860            1                29    89981.23
## 29 113860            1                65    89981.23
## 30 113860            1                63    89981.23
## 31 113860            1                17    89981.23
## 32 113860            1                29    89981.23
## 33 113860            1                 0    89981.23
## 34 113860            1                 5    89981.23
## 35 112961            1                39    93800.00
## 36 101257            4                57    99000.00
## 37 101257            3                52    99000.00
## 38 101257            3                14    99000.00
## 39 107242            1                23   100070.00
## 40 107242            1                21   100070.00
## 41 107067            4                41   102033.33
## 42 107067            4                17   102033.33
## 43 107067            4                45   102033.33
## 44 107067            4                14   102033.33
## 45 109253            4                54   106605.23
## 46 109253            2                68   106605.23
## 47 109253            4                57   106605.23
## 48 170533            4                19   112000.00
## 49 170533            4                58   112000.00
## 50 170533            4                59   112000.00
## 51 170611            4                36   130000.00
## 52 170611            4                14   130000.00
## 53 170611            4                12   130000.00
## 54 170593            4                70   137239.22
## 55 170593            4                65   137239.22
```

We can see that the level of income now increases as we scroll down the list. However, notice that members of the same household are still next to one another. This is because the income variable we are using is a household level variable and therefore has the same value for every member of the household.

Let's see if you have gotten the hang of this, try these quick exercises:

**Exercises**

**1. What is the hhid value for the 1000th observation?**

Question 1 Answer

**2. What are the ages of the respondents with an hhid equal to 42011?**

Question 2 Answer

**3. How many 50 year old Indian respondents are there in the data? (Be careful this one is a bit tougher than the others)**

Question 3 Answer


## Managing the data

In this section, we'll learn some data management commands. In many circumstances, we will want to amend the original NIDS data set. We might want to add new variables that we create from the existing variables, we might want to drop variables that we will never use to free up memory, we might want to recode missing values, and/or we might want to create our own variable labels. While we will not deal with some of the trickier data management issues (such as merging data sets) in this section, you will learn enough to get started. 

We'll start by creating a new variable. To create a new variable in R using `dplyr` functions you use the `mutate` command. Suppose we want to create a new variable called "temp" and we would like this variable to be equal to 1 for every observation in the dataset.
To create this new variable you need to type:


```r
nids<-nids %>% 
  mutate(temp=1)
```

Go ahead and enter this command into R. You will notice that our new variable temp has been added to the end of the variable list in the R variables window. How do we know for sure what this new variable is equal to? Did the command work correctly?

See if you can figure this out:


**4. How can we check to make sure our new variable is equal to 1?**

Question 4 Answer

**5. How would you create a new variable called "temp2" that is equal to 50 for all of the observations in the data set?**

Question 5 Answer


Now you may be asking yourself, why would I want to create a variable like temp that has the same value for each observation in the data set. Variables like temp can actually be quite useful at times, although a majority of the variables you create will not have the same value for all observations. Let's try another example. Suppose we want to create a variable for race that has only two values: white and non‐white. This can be useful if we are investigating the consequences of past discrimination in South Africa. The variable `w1_best_race` in the NIDS data set has four values: 1 (African), 2 (Coloured), 3 (Asian/Indian) and 4 (White).

Our goal here is to have a variable `w1_best_race2` which is equal to 1 if the individual is white and equal to 2 if the
individual is non‐white. Here we suggest to use the `ifelse` command within the `mutate` function. The `ifelse` command works as follows:

`ifelse(condition, value if condition is true, value if condition is false)`

In the case of `w1_best_race2`:


```r
nids<-nids %>% 
  mutate(w1_best_race2=ifelse(w1_best_race==4,1,2))
```

We can tabulate results for the new variable and see the breakdown:


```r
table(nids$w1_best_race2)
```

```
## 
##     1     2 
##  1432 26762
```

We can achieve the same results using base R functions. 


```r
nids$w1_best_race3<-NA # NA for all values of w1_best_race3
nids$w1_best_race3[nids$w1_best_race==4]<-1 # w1_best_race3 is 0 for all cases where w1_best_race==4
nids$w1_best_race3[nids$w1_best_race<4 & nids$w1_best_race>=1]<-2 # w1_best_race3 is 1 for all cases where w1_best_race!=4
table(nids$w1_best_race3)
```

```
## 
##     1     2 
##  1432 26762
```

The above example provides us with a good opportunity to introduce factor variables, the equivalent of Stata's categorical variables. Here, we want to assign the new variable, `w1_best_race2`, the respective value labels. We achieve this using the `factor` function:


```r
nids<-nids %>% 
  mutate(w1_best_race2=factor(w1_best_race2, levels=1:2, labels=c("White","Non-White")))
#nids$w1_best_race2<-factor(nids$w1_best_race2, levels=c(1,2), labels=c("White","Non-White"))
```

Tabulate labelled variable:


```r
table(nids$w1_best_race2)
```

```
## 
##     White Non-White 
##      1432     26762
```

You will now notice that at the end of the Variable view window that our new variable `w1_best_race2` is listed. Alright now it's your turn. Try to answer the following questions:

**6. How would you create a new variable called "head" that is equal to 1 if the individual is the resident head, and equal to 0 if the individual is not?**

Question 6 Answer

~~**7. How would you label this new variable with the following label ‐ "Resident head indicator"?**~~

Question 7 Answer


We can also generate variables using the mathematical operators. For example, if we wanted a variable for the total monthly household income from government we could add household monthly income from government grants (`w1_hhgovt`) and household monthly income from
other government sources (`w1_hhother`) to create a new variable which we call `hhincome_govt`. Thus, we would type:


```r
nids<-nids %>% 
  mutate(hhincome_govt = w1_hhgovt + w1_hhother)
```

## Worked example: creating a bmi variable

In this worked example, our aim is to create a body mass index (BMI) variable. The Body Mass Index (BMI) is a measure of the nutritional status of adults and is calculated by dividing weight in kilograms by the square of height in metres. As such, we first need to find and explore the height and weight variables in the dataset. Let’s start with height.

You will see in the metadata document that there are 3 height variables for children and 3 height variables for adults. You should turn to the metadata and questionnaires to investigate why this is the case. One of the reasons for repeated measurement is to try to minimize the chance that heights are measured incorrectly. Ideally, we would collate the information contained in the three measures to obtain a variable containing the best estimate of every individual in the dataset. Here, we will instead use the first measure (`w1_a_n1_1`) as a crude estimate of the height of adults in the sample.

Let’s have a look at this variable:

First six observations


```r
nids %>% 
  select(w1_a_n1_1) %>%
  head()
```

```
##   w1_a_n1_1
## 1     161.0
## 2     156.2
## 3     160.0
## 4     176.2
## 5     165.0
## 6     158.2
```

Last six observations


```r
nids %>% 
  select(w1_a_n1_1) %>%
  tail()
```

```
##       w1_a_n1_1
## 31165        NA
## 31166     187.1
## 31167        NA
## 31168        NA
## 31169      -8.0
## 31170      -8.0
```

Did you notice that the heights are measured in centimeters? In order to calculate BMI, we will need heights in meters. Also, since BMI is a ratio of weight to height squared, we will not want to include the negative nonresponse height or weight values. Lastly, BMI is only valid for people over the age of 20 years of age. Let’s create a new height variable in a more useful form for our purposes:


```r
nids<-nids %>%
  mutate(height = ifelse (w1_a_n1_1 >= 0 & w1_a_best_age_yrs >= 20, w1_a_n1_1/100, NA))
```

What is the height of the tallest person in our sample? What is the mean height of the sample?


```r
summary(nids$height)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   0.453   1.553   1.610   1.614   1.680   2.074   19718
```

The `summary()` function is a generic function that recognizes objects belonging to different classes and treat them accordingly
without returning an error message.

We see that applying the `summary()` function to a numerical variable above computes basic descriptive statistics (mean, median, quartiles, maximum and minimum). R automatically works out which type of summary is best suited to a given object class. Typing `summary(nids)` will return summary information about each variable in the dataset.

We can see that the range is [0.453, 2.074], which tells us that the shortest person in the sample has a reported height of less than half a metre, while the tallest person is 2.07 metres tall. The average height in the sample is 1.61 metres. We can get an idea of the distribution of heights in the sample by looking at the percentiles. Half the people in the sample are between 1.55 and 1.68 metres tall.

Returning to the shortest person in the population, recall that we have restricted the height variable to only include individuals over the age of 20. This means that a person who is 0.453 metres tall is either exceptionally short or that there was an error made in measurement or data capturing. Let’s investigate people who have reported heights that are below ‘normal’.

How many are there in the sample?


```r
nids %>% 
  filter(height<1) %>% #filter all height less than 1 meter
  select(w1_a_best_age_yrs, w1_a_b2, height) #pick to print data for these variables
```

```
##    w1_a_best_age_yrs w1_a_b2 height
## 1                 50       1  0.622
## 2                 22       2  0.637
## 3                 49       2  0.453
## 4                 48       2  0.994
## 5                 23       2  0.552
## 6                 26       2  0.641
## 7                 43       2  0.639
## 8                 34       1  0.654
## 9                 74       1  0.725
## 10                50       1  0.704
## 11                38       2  0.615
## 12                57       2  0.610
## 13                75       2  0.682
## 14                36       2  0.624
## 15                50       2  0.847
## 16                34       2  0.710
## 17                64       1  0.557
## 18                41       2  0.542
## 19                75       1  0.790
## 20                40       1  0.610
## 21                26       2  0.585
## 22                22       2  0.966
## 23                64       2  0.700
## 24                49       1  0.668
## 25                21       2  0.984
## 26                79       2  0.527
## 27                57       2  0.771
## 28                30       2  0.642
```

We see there are 28 people who are shorter than one meter tall in the sample. We also list the gender (`w1_a_b2`) and age of these individuals to give us more information to potentially identify a pattern. There does not appear to be a relationship with age. However, we see that the majority of individuals under one metre are females.

**8. Create a new variable called "weight" that has no negative values and is missing for individual younger than 20. Investigate the weight distribution in the population as we have just done for the height distribution.**



```r
nids<-nids %>%
  mutate(weight = ifelse (w1_a_n2_1 >= 0 & w1_a_best_age_yrs >= 20, w1_a_n2_1, NA)) 

summary(nids$weight)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   19.20   57.20   66.80   69.59   79.60  150.00   19848
```


**Generating a variable for BMI**

The heights and weights of people in the South African population are interesting in themselves, but in order to assess the health of an individual we need a measure of weight given height. For instance, we might want to say that someone who weighs 100 kg and is 1.6 metres tall is overweight, while someone who weighs 100 kg, but is 2 metres tall is not. The Body Mass Index (BMI) is a commonly used measure of the relationship between weight and height and allows us to talk about whether an individual is overweight, underweight or of a healthy weight.

The BMI is calculated by dividing weight (kg) by height squared ($m^2$) for people over the age of
20 (i.e. $BMI = \frac{weight}{height^2}$)


```r
nids<-nids %>%
  mutate(bmi = weight/height^2)
```

Some points to note. Firstly, our `bmi` variable should have a missing value for individuals who are younger than 20 since both our `height` and `weight` variables are missing for these individuals. We will be ignoring them when we look at BMI in this course as calculating the BMI for individuals under the age of 20 involves a different formula.

It is always good to get a sense of what your new variable looks like. Have we coded it correctly? Does it contain the information we want it to contain? Is the variable missing for those who should not have a value and valid for those who should get a value?

Check that BMI is missing for people under age 20 and for those who have missing height for weight values.


```r
nids %>% 
  filter(w1_a_best_age_yrs<20) %>% # filter children younger than 20 years
  filter(!is.na(bmi)) %>% # filter children whose BMI is not missing
  summarise(n=n()) # count how many are they
```

```
##   n
## 1 0
```


```r
nids %>% 
  filter(is.na(height) | is.na(weight)) %>% #filter those with missing height and missing weight
  filter(!is.na(bmi)) %>% # filter not missing BMI
  summarise(n=n()) #count
```

```
##   n
## 1 0
```

How many respondents have non-missing BMI values?


```r
nids %>%
  filter(!is.na(bmi)) %>%
  summarise(count = n())
```

```
##   count
## 1 11285
```

The World Health Organisation classifies a BMI under 18.5 as underweight, a BMI between 18.5 and 24.9 as normal, a BMI between 25 and 29.9 as overweight and a BMI of 30 or more as obese. In light of this, does our new variable appear to be reasonable?

In the later chapters of this series we will investigate the determinants of BMI and in doing so address the following questions. What happens to your BMI as you get older? Do richer people have a higher or lower BMI than middle income or poor people? Is the average BMI different across racial groups? But for now, try to put what you have learnt in this chapter into practice by completing the following question. Then use the exercises to revise the new tools you have learnt.

**9. See if you can create a variable called `age_bins` that is equal to 1 if the individual is between ages 20 and 29, 2 for ages 30 - 39, 3 for ages 40 - 49, 4 for ages 50 - 59, 5 for ages 60 - 69, 6 for ages 70 - 120. Ensure that your variable is missing for other values of the age variable.**


## Question answers

Question 1 answer

**What is the hhid value for the 1000th observation?**

Answer:


```r
nids[1000,c("hhid")]
```

```
## [1] 105886
```

The above command will display the value for the variable hhid for the 1000th observation in the data set. Now it is possible that you could get a different answer than above, it all depends on the order the observations have been saved in. If this is your first time using the NIDS data file then you should get the answer above.

Question 2 answer

**What are the ages of the respondents with an hhid equal to 101041?**

Answer:

8, 14, 15, 57, 59


```r
nids[which(nids$hhid==101041),c("w1_r_best_age_yrs")]
```

```
## [1] 57 15 59 14  8
```

The above command displays the value for the variable `w1_r_best_age_yrs` if the variable `hhid` is equal to 101041.


Question 3 answer

**How many 50 year old Indian respondents are there in the data?**

Answer:

Two


```r
nrow(nids[which(nids$w1_best_race == 3 & nids$w1_r_best_age_yrs==50),])
```

```
## [1] 2
```

```r
#To see the hhid
nids[which(nids$w1_best_race == 3 & nids$w1_r_best_age_yrs==50),c("hhid")]
```

```
## [1] 170064 101113
```

Question 4 answer

**How can we check to make sure our new variable is equal to 1?**

Answer:

One way is to tabulate the new variable temp.


```r
table(nids$temp)
```

```
## 
##     1 
## 31170
```


Question 5 answer

**How would you create a new variable called "temp2" that is equal to 50 for all of the observations in the data set?**

Answer:


```r
nids<-nids %>% 
  mutate(temp2=50)

#Or

nids$temp2<-50
```

Question 6 answer

**How would you create a new variable called "head" that is equal to 1 if the individual is the resident head, and equal to 0 if the individual is not?**

Answer:

The first step to creating the new variable head is to find a variable in the data set that will tell us who is and is not a resident head. To accomplish this, search for the variables and/or variable labels contain the key text "resident head" from the codebook.

The variable, `w1_r_b3` (Household member’s relationship to Resident head), seems the most promising. To verify this we use the NIDS survey metadata pdf (page 56, contains the relevant question for variable `w1_r_b3` i.e. Wave 1, Full Roster Data, Question B3). It becomes clear after viewing the codelist relating to this question (Appendix A – Table 1 on page 120) that `w1_r_b3` is the variable we want. From this codelist we see that a resident head is given a value of 1, thus when the variable `w1_r_b3` is equal to 1, that individual is a resident head.

With this knowledge, we are able to create the new variable.


```r
nids<- nids%>% 
  mutate(head=ifelse(w1_r_b3 == 1,1,0))
#nids$head=ifelse(nids$w1_r_b3 == 1,1,0)
```

Here we used the `ifelse` command where if the condition `w1_r_b3 == 1` is met, the new variable is equal to 1 and zero for everyone else.


Question 7 answer

**How would you label this new variable with the following label "Resident head indicator"?**

Answer:

Not applicable


Question 8 answer

Answer:

**Create a new variable called “weight” that has no negative values and is missing for individual younger than 20. Investigate the weight distribution in the population as we have just done for the height distribution.**

The weight variable is `w1_a_n2_1`.


```r
nids<-nids %>%
  mutate(weight = ifelse (w1_a_n2_1 >= 0 & w1_a_best_age_yrs >= 20, w1_a_n2_1, NA)) 

summary(nids$weight)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   19.20   57.20   66.80   69.59   79.60  150.00   19848
```


Question 9 answer

**Create a variable called age_bins that is equal to 1 if the individual is between ages 20 and 29, 2 for ages 30 – 39, 3 for ages 40 – 49, 4 for ages 50 – 59, 5 for ages 60 – 69, 6 for ages 70 120. Ensure that your variable is missing for other values of the age variable.**

Answer:


```r
nids<-nids %>% 
  mutate(age_bins=case_when(
    w1_a_best_age_yrs > 20 & w1_a_best_age_yrs<=29 ~ 1,
    w1_a_best_age_yrs > 29 & w1_a_best_age_yrs<=39 ~ 2,
    w1_a_best_age_yrs > 39 & w1_a_best_age_yrs<=49 ~ 3,
    w1_a_best_age_yrs > 49 & w1_a_best_age_yrs<=59 ~ 4,
    w1_a_best_age_yrs > 59 & w1_a_best_age_yrs<=69 ~ 5,
    w1_a_best_age_yrs > 69 & w1_a_best_age_yrs<=120 ~ 6)) %>% 
  mutate(age_bins=factor(age_bins, labels = c("20-29","30-39","40-49","50-59","60-69","70-120")))

#OR
#nids$age_bins<-factor(cut(nids$w1_a_best_age_yrs, c(20,29,39,49,59,69,120),labels = c("20-29","30-39","40-49","50-59","60-69","70-120")))

#OR
#nids$age_bins<-NA
# nids$age_bins[nids$w1_a_best_age_yrs>=20 & nids$w1_a_best_age_yrs<=29]<-1
# nids$age_bins[nids$w1_a_best_age_yrs>29 & nids$w1_a_best_age_yrs<=39]<-2
# nids$age_bins[nids$w1_a_best_age_yrs>39 & nids$w1_a_best_age_yrs<=49]<-3
# nids$age_bins[nids$w1_a_best_age_yrs>49 & nids$w1_a_best_age_yrs<=59]<-4
# nids$age_bins[nids$w1_a_best_age_yrs>59 & nids$w1_a_best_age_yrs<=69]<-5
# nids$age_bins[nids$w1_a_best_age_yrs>69 & nids$w1_a_best_age_yrs<=120]<-6
```


```r
nids%>%
  group_by(age_bins)%>%
  summarise(count = n())
```

```
## # A tibble: 7 x 2
##   age_bins count
##   <fct>    <int>
## 1 20-29     3525
## 2 30-39     2921
## 3 40-49     2553
## 4 50-59     2018
## 5 60-69     1299
## 6 70-120     955
## 7 <NA>     17899
```

## Exercises

Using R and the NIDS dataset, answer the following questions.

**1. How many households are in the NIDS data file?**

Exercise 1 Answer

**2. What are some variables in the data set that are related to food?**

Exercise 2 Answer

**3. How old is the oldest person in the data set?**

Exercise 3 Answer

**4. How many 50 year old women are in the data set?**

Exercise 4 Answer

**5. How would you create a new variable that is equal to 1 for Africans and 0 for non‐Africans?**

Exercise 5 Answer

**6. How would you drop every variable from the data set except the new variable you just created?**

Exercise 6 Answer



## Exercise answers

Exercise 1 answer

**How many households are in the NIDs data file?**

Answer: 7305

The first step is to determine what variable uniquely identifies each household. From the labels in the codebook, it is clear that the variable `hhid` is the variable needed as it is the "household identifier". We can confirm this by using the NIDS survey. One way to obtain the number of unique `hhid` values, is to use the commands `unique` and `length`:


```r
length(unique(nids$hhid))
```

```
## [1] 7305
```


Exercise 3 answer

**How old is the oldest person in the data set?**

Answer:


```r
max(nids$w1_r_best_age_yrs, na.rm=TRUE)
```

```
## [1] 105
```


Exercise 4 answer

**How many 85 year old women are in the data set?**

There are 10 women who are 85 years old in the data set. To obtain the answer to question 4, you could have used the following commands:


```r
nrow(nids[which(nids$w1_r_best_age_yrs == 85 & nids$w1_r_b4 == 2),])
```

```
## [1] 10
```

```r
#OR

nids %>% 
  filter(w1_r_best_age_yrs == 85 & w1_r_b4 == 2) %>% 
  nrow
```

```
## [1] 10
```

Exercise 5 answer

**How would you create a new variable that is equal to 1 for Africans and 0 for non-Africans?**

The first step in creating the new variable is to determine which value of the variable race identifies Africans. From the NIDS survey we know that the value 1 identifies an African respondent. With this knowledge, we are able to create the new variable.


```r
nids<-nids %>% 
  mutate(newvar=ifelse(w1_best_race==1,1,2))
```

Exercise 6 answer

**How would you drop every variable from the data set except the new variable you just created?**


```r
#nids<-data.frame(nids$newvar)

#Or

#nids<-nids %>% 
#  select(newvar)
```

## Session information

The output below shows what R packages and versions where used.


```r
print(sessionInfo(), locale = FALSE)
```

```
## R version 3.5.1 (2018-07-02)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows 7 x64 (build 7601) Service Pack 1
## 
## Matrix products: default
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
##  [1] bindrcpp_0.2.2   forcats_0.3.0    stringr_1.3.1    dplyr_0.7.6     
##  [5] purrr_0.2.5      readr_1.1.1      tidyr_0.8.1      tibble_1.4.2    
##  [9] ggplot2_3.0.0    tidyverse_1.2.1  kableExtra_0.9.0 knitr_1.20      
## [13] foreign_0.8-70  
## 
## loaded via a namespace (and not attached):
##  [1] tidyselect_0.2.4  xfun_0.3          haven_1.1.2      
##  [4] lattice_0.20-35   colorspace_1.3-2  htmltools_0.3.6  
##  [7] viridisLite_0.3.0 yaml_2.2.0        utf8_1.1.4       
## [10] rlang_0.2.1       pillar_1.3.0      withr_2.1.2      
## [13] glue_1.3.0        modelr_0.1.2      readxl_1.1.0     
## [16] bindr_0.1.1       plyr_1.8.4        cellranger_1.1.0 
## [19] munsell_0.5.0     gtable_0.2.0      rvest_0.3.2      
## [22] evaluate_0.11     fansi_0.3.0       broom_0.5.0      
## [25] Rcpp_0.12.18      scales_1.0.0      backports_1.1.2  
## [28] jsonlite_1.5      hms_0.4.2         digest_0.6.15    
## [31] stringi_1.1.7     bookdown_0.7      rprojroot_1.3-2  
## [34] grid_3.5.1        cli_1.0.0         tools_3.5.1      
## [37] magrittr_1.5      lazyeval_0.2.1    crayon_1.3.4     
## [40] pkgconfig_2.0.2   xml2_1.2.0        lubridate_1.7.4  
## [43] assertthat_0.2.0  rmarkdown_1.10    httr_1.3.1       
## [46] rstudioapi_0.7    R6_2.2.2          nlme_3.1-137     
## [49] compiler_3.5.1
```

