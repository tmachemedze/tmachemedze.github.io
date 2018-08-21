## ------------------------------------------------------------------------
getwd()

## ------------------------------------------------------------------------
x<-5
y<-3

## ------------------------------------------------------------------------
x
y

## ------------------------------------------------------------------------
ls()

## ------------------------------------------------------------------------
rm(x)  # remove object x

## ------------------------------------------------------------------------
ls()

## ------------------------------------------------------------------------
rm(list=ls()) #or rm(object1,object2) to remove specific objects, object1 and object2

## ------------------------------------------------------------------------
ls()

## ------------------------------------------------------------------------
#install.packages("foreign") # to install if not installed
library(foreign)

## ----message=FALSE, warning=FALSE----------------------------------------
nids<-read.dta("./data/nids.dta", convert.factors=FALSE)

## ------------------------------------------------------------------------
dim(nids)

## ------------------------------------------------------------------------
nids[2,7]

## ------------------------------------------------------------------------
nids[1:10,1:8]

## ------------------------------------------------------------------------
nids[c(1:5,8),c(1,2,3,7,8)]

## ------------------------------------------------------------------------
names(nids[,1:8])

## ------------------------------------------------------------------------
head(nids[,1:8])

## ------------------------------------------------------------------------
tail(nids[,1:8])

## ------------------------------------------------------------------------
str(nids[,1:8])

## ---- echo=FALSE, warning=FALSE, message=FALSE---------------------------
df<-data.frame(Operator = c("\\+","\\-","\\*","/","^ or **","<","<=",">",">=","==","!=","!x","x | y","x & y"), 
               Description=c("addition","subtraction","multiplication","division","exponentiation","less than", "less than or equal to","greater than","greater than or equal to","exactly equal to","not equal to","not x","x or y","x and y"))

library(knitr)
library(kableExtra)

kable(df,  format="html", escape = FALSE, caption = "Operators") %>% 
  kable_styling("striped", full_width = F, position = "center") %>%
  group_rows("Arithmetic Operators", 1, 5) %>%
  group_rows("Logical Operators", 6, 14)

## ------------------------------------------------------------------------
head(subset(nids, 
            subset = w1_r_best_age_yrs>90, 
            select = c(w1_r_best_age_yrs, w1_best_race, w1_r_b7)))

## ------------------------------------------------------------------------
library(tidyverse)

## ------------------------------------------------------------------------
head(nids[,c('w1_r_best_age_yrs', 'w1_best_race', 'w1_r_b7')])

## ------------------------------------------------------------------------
head(subset(nids, select=c(w1_r_best_age_yrs, w1_best_race, w1_r_b7)))

## ------------------------------------------------------------------------
nids %>% 
  select(w1_r_best_age_yrs, w1_best_race, w1_r_b7) %>% # pick columns
  head()

## ------------------------------------------------------------------------
#head(nids[nids$w1_best_race==3,])

## ------------------------------------------------------------------------
#head(subset (nids, subset=w1_best_race == 3))

## ------------------------------------------------------------------------
#nids %>%
#  filter(w1_best_race == 3) %>% # filter rows by values
#  head()

## ------------------------------------------------------------------------
nids[nids$w1_r_best_age_yrs > 90,c("w1_best_race")]

## ------------------------------------------------------------------------
subset(nids, subset=w1_r_best_age_yrs > 90,select=c(w1_best_race))

## ------------------------------------------------------------------------
nids %>% 
  filter(w1_r_best_age_yrs > 90) %>%
  select(w1_best_race)

## ------------------------------------------------------------------------
nids[nids$w1_r_best_age_yrs > 90 & !is.na(nids$w1_best_race),c("w1_best_race")]

## ------------------------------------------------------------------------
subset(nids, subset=w1_r_best_age_yrs > 90 & !is.na(w1_best_race),select=c(w1_best_race))

## ------------------------------------------------------------------------
nids %>%
  filter(w1_r_best_age_yrs > 90 & !is.na(w1_best_race)) %>%
  select(w1_best_race) 

## ------------------------------------------------------------------------
nids %>% 
  filter(w1_hhincome> 75000) %>%
  select(w1_best_race, w1_r_best_age_yrs, w1_hhincome) 

## ------------------------------------------------------------------------
nids %>% 
  filter(w1_hhincome> 75000) %>%
  select(hhid,w1_best_race, w1_r_best_age_yrs,w1_hhincome) 

## ------------------------------------------------------------------------
nids<-nids %>% arrange(w1_hhincome)

## ------------------------------------------------------------------------
nids %>% 
  filter(w1_hhincome> 75000) %>%
  select(hhid,w1_best_race, w1_r_best_age_yrs,w1_hhincome)

## ------------------------------------------------------------------------
nids<-nids %>% 
  mutate(temp=1)

## ------------------------------------------------------------------------
nids<-nids %>% 
  mutate(w1_best_race2=ifelse(w1_best_race==4,1,2))

## ------------------------------------------------------------------------
table(nids$w1_best_race2)

## ------------------------------------------------------------------------
nids$w1_best_race3<-NA # NA for all values of w1_best_race3
nids$w1_best_race3[nids$w1_best_race==4]<-1 # w1_best_race3 is 0 for all cases where w1_best_race==4
nids$w1_best_race3[nids$w1_best_race<4 & nids$w1_best_race>=1]<-2 # w1_best_race3 is 1 for all cases where w1_best_race!=4
table(nids$w1_best_race3)

## ------------------------------------------------------------------------
nids<-nids %>% 
  mutate(w1_best_race2=factor(w1_best_race2, levels=1:2, labels=c("White","Non-White")))
#nids$w1_best_race2<-factor(nids$w1_best_race2, levels=c(1,2), labels=c("White","Non-White"))

## ------------------------------------------------------------------------
table(nids$w1_best_race2)

## ------------------------------------------------------------------------
nids<-nids %>% 
  mutate(hhincome_govt = w1_hhgovt + w1_hhother)

## ------------------------------------------------------------------------
nids %>% 
  select(w1_a_n1_1) %>%
  head()

## ------------------------------------------------------------------------
nids %>% 
  select(w1_a_n1_1) %>%
  tail()

## ------------------------------------------------------------------------
nids<-nids %>%
  mutate(height = ifelse (w1_a_n1_1 >= 0 & w1_a_best_age_yrs >= 20, w1_a_n1_1/100, NA))

## ------------------------------------------------------------------------
summary(nids$height)

## ------------------------------------------------------------------------
nids %>% 
  filter(height<1) %>% #filter all height less than 1 meter
  select(w1_a_best_age_yrs, w1_a_b2, height) #pick to print data for these variables

## ------------------------------------------------------------------------
nids<-nids %>%
  mutate(weight = ifelse (w1_a_n2_1 >= 0 & w1_a_best_age_yrs >= 20, w1_a_n2_1, NA)) 

summary(nids$weight)

## ------------------------------------------------------------------------
nids<-nids %>%
  mutate(bmi = weight/height^2)

## ------------------------------------------------------------------------
nids %>% 
  filter(w1_a_best_age_yrs<20) %>% # filter children younger than 20 years
  filter(!is.na(bmi)) %>% # filter children whose BMI is not missing
  summarise(n=n()) # count how many are they

## ------------------------------------------------------------------------
nids %>% 
  filter(is.na(height) | is.na(weight)) %>% #filter those with missing height and missing weight
  filter(!is.na(bmi)) %>% # filter not missing BMI
  summarise(n=n()) #count

## ------------------------------------------------------------------------
nids %>%
  filter(!is.na(bmi)) %>%
  summarise(count = n())

## ------------------------------------------------------------------------
nids[1000,c("hhid")]

## ------------------------------------------------------------------------
nids[which(nids$hhid==101041),c("w1_r_best_age_yrs")]

## ------------------------------------------------------------------------
nrow(nids[which(nids$w1_best_race == 3 & nids$w1_r_best_age_yrs==50),])

#To see the hhid
nids[which(nids$w1_best_race == 3 & nids$w1_r_best_age_yrs==50),c("hhid")]

## ------------------------------------------------------------------------
table(nids$temp)

## ------------------------------------------------------------------------
nids<-nids %>% 
  mutate(temp2=50)

#Or

nids$temp2<-50


## ------------------------------------------------------------------------
nids<- nids%>% 
  mutate(head=ifelse(w1_r_b3 == 1,1,0))
#nids$head=ifelse(nids$w1_r_b3 == 1,1,0)

## ------------------------------------------------------------------------
nids<-nids %>%
  mutate(weight = ifelse (w1_a_n2_1 >= 0 & w1_a_best_age_yrs >= 20, w1_a_n2_1, NA)) 

summary(nids$weight)

## ----message=FALSE, warning=FALSE----------------------------------------
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

## ------------------------------------------------------------------------
nids%>%
  group_by(age_bins)%>%
  summarise(count = n())

## ------------------------------------------------------------------------
length(unique(nids$hhid))

## ------------------------------------------------------------------------
max(nids$w1_r_best_age_yrs, na.rm=TRUE)

## ------------------------------------------------------------------------
nrow(nids[which(nids$w1_r_best_age_yrs == 85 & nids$w1_r_b4 == 2),])

#OR

nids %>% 
  filter(w1_r_best_age_yrs == 85 & w1_r_b4 == 2) %>% 
  nrow

## ------------------------------------------------------------------------
nids<-nids %>% 
  mutate(newvar=ifelse(w1_best_race==1,1,2))

## ------------------------------------------------------------------------
#nids<-data.frame(nids$newvar)

#Or

#nids<-nids %>% 
#  select(newvar)

## ------------------------------------------------------------------------
print(sessionInfo(), locale = FALSE)

