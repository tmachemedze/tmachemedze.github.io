# Further analysis and useful online resources

## Further analyses

The preceding sections covers most of the content in the original Stata course. Here we provide further information for users who might be interested in carrying out advanced statistical analyses. The list below is non-exhaustive but we hope it can provide a good starting point for those interested in the respective types of analyses.

**Regression analysis:** 

  * In the guide we introduced `lm()` to fit linear models. There is another function, `glm()`, for fitting simple and multiple linear and non linear regressions including logistic regression and more generally models falling under the Generalized Linear Model (GLM) framework. This function is implemented in the base R `stats` package.
 
  * `lme4` [@R-lme4] and `nlme` [@R-nlme] - packages for fitting linear multilevel (i.e. mixed effects) models. The `nlme` package also allows to fit non linear multilevel models.

**Complex sample survey design and data analysis** 

  * Main suite of functions used to do complex survey weighting in R is in the `survey` package [@R-survey]. It includes commands to specify a complex survey design (stratified sampling design, cluster sampling, multi-stage sampling and pps sampling with or without replacement), calibration (post-stratification, generalized raking/calibration, GREG estimation and trimming of weights), e.t.c. You can also check supporting [vignettes here](http://r-survey.r-forge.r-project.org/survey/index.html).
  

## Useful online resources

There are hundreds of web sites and online resources dedicated to R that users can consult. It is difficult to do justice to all of them and a few of the most common ones are listed below to help you get started: 

**Introductory**

* The R [manuals](https://cran.r-project.org) [@RCoreTeam].

* An [Introduction to R](https://cran.r-project.org/doc/manuals/R-intro.pdf) [@venables2014r].

* Quick-R [homepage - statmethods.net](https://www.statmethods.net/) - a good place to start learning R and an easily accessible reference.

* DataCamp's free interactive [introduction to R programming](https://www.datacamp.com/courses/introduction-to-r).

* [Cookbook for R](http://www.cookbook-r.com/).

* UCLA website [https://stats.idre.ucla.edu/r/](https://stats.idre.ucla.edu/r/) - provides a good starting point for the R beginner and other statistical packages.

* [R Reference Card](https://cran.r-project.org/doc/contrib/Short-refcard.pdf).

**Expert**

* The [R for Data Science](https://www.amazon.com/Data-Science-Transform-Visualize-Model/dp/1491910399) book [@wickham2016r]. The book provides readers with a good grounding in basic aspects of data analysis, from import and cleaning to visualizing and modeling. The book was authored by Hadley Wickham and Garrett Grolemund who both work at RStudio. Wickham is the main developer of the `tidyverse` packages that are used in this guide. *R for Data Science* is also available for [free online](http://r4ds.had.co.nz/).

* [The R Inferno](http://www.burns-stat.com/pages/Tutor/R_inferno.pdf) [@burns2012r]. The abstract sums up everything: "If you are using R and you think you're in hell, this is a map for you." - Patrick Burns.


**Data visualization (ggplot2 graphics)**.

Useful resources for starting to learn `ggplot2` include:

* gglot2 [Documentation](http://ggplot2.tidyverse.org/) (particularly the [function reference](http://ggplot2.tidyverse.org/reference/index.html)).

* Data Visualization Chapter of [R for Data Science](http://r4ds.had.co.nz/data-visualisation.html) Book [@wickham2016r].

* RStudio's ggplot2 [cheat sheet](https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf).

* [R Graphics Cookbook](http://www.cookbook-r.com/Graphs/) [@chang2012r].

* [UCLA's](https://stats.idre.ucla.edu/r/seminars/ggplot2_intro/) introduction to `ggplot2`.


**Blogs**

* [https://www.r-bloggers.com/](https://www.r-bloggers.com/) - a blog aggregator that posts or repost R related articles contributed by bloggers. It helps you keep up to date with changes in packages, new techniques and better applications. R bloggers is a good place to find R tutorials, announcements, and other random happenings.

* [http://blog.revolutionanalytics.com/](http://blog.revolutionanalytics.com/) - now part of Microsoft and is a blog that is dedicated to a wide variety of R technical updates.

**Ask questions**

* [StackOverflow](https://stackoverflow.com/) - a searchable forum of questions and answers about computer programming. It is a great resource with many questions for many specific packages in R and most developers of the packages are also active on StackOverflow to answer questions related to their packages. There is also a rating system for answers.

* [stats.stackexchange.com](https://stats.stackexchange.com/)  - not specific to R but contains statistics/machine learning/data analysis/data mining/data visualization related questions and answers raised by R users.

**Other**

* [rseek.org](https://rseek.org/) - the search engine just for R.



