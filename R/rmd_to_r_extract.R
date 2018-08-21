library(knitr)
f<-list.files(pattern=".Rmd")
lapply(f, purl)
