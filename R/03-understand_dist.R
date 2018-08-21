## ------------------------------------------------------------------------
library(tidyverse)
library(foreign)

nids<-read.dta("./data/nids.dta", convert.factors=FALSE)

#sink(file="./sink/chapter3.txt")
#table(nids$w1_hhincome)
#sink()

## ------------------------------------------------------------------------
nids<-nids %>%
  mutate(white = ifelse(w1_best_race==4,1,0))

## ------------------------------------------------------------------------
nids %>%
  select(hhid, w1_r_best_age_yrs)%>%
  arrange(hhid) %>%
  head(10)

## ------------------------------------------------------------------------
nids %>%
  select(hhid, w1_hhincome)%>%
  arrange(hhid) %>%
  head(10)

## ------------------------------------------------------------------------
dim(nids)

## ------------------------------------------------------------------------
nrow(nids)

## ------------------------------------------------------------------------
nids %>% 
  filter(w1_r_b4==2) %>% #filter females
  count

## ------------------------------------------------------------------------
nids<-nids%>% #assign the nids object to nids
  arrange(hhid, pid)%>% #sort by hhid then pid
  group_by(hhid) %>% #group by hhid
  mutate(hhrestrict = 1:n()) %>% # create hhrestrict that is numbered individuals within the group by variable
  mutate(hhrestrict = ifelse(hhrestrict==1,1,0)) #make hhrestrict 1 for only the first observation

## ------------------------------------------------------------------------
nids %>%
  select(hhid, hhrestrict) %>%
  head(20)

## ------------------------------------------------------------------------
head(nids[,c("hhid", "hhrestrict")], n = 20L)

## ------------------------------------------------------------------------
nids%>%
  filter(hhrestrict==1)%>%
  nrow

## ------------------------------------------------------------------------
nids%>%
  select(hhid, w1_hhincome, hhrestrict)%>%
  arrange(hhid) %>%
  head(25)

## ------------------------------------------------------------------------
nids<-nids%>%
  mutate(hhincome2 = ifelse(hhrestrict==1, w1_hhincome, NA))

## ------------------------------------------------------------------------
nids %>% 
  select(hhid, w1_hhincome,hhincome2, hhrestrict) %>% 
  head(25)

## ------------------------------------------------------------------------
table(nids$w1_best_race)

## ------------------------------------------------------------------------
nids<-nids %>% 
  mutate(w1_best_race=factor(w1_best_race, levels=1:4,labels=c("African","Coloured","Asian_Indian","White")))

## ------------------------------------------------------------------------
table(nids$w1_best_race)

## ------------------------------------------------------------------------
nids%>%
  group_by(w1_best_race)%>%
  summarise(freq=n()) %>%
  mutate(percent = round(freq/sum(freq)*100,2), cum_percent = round(cumsum(freq)/sum(freq)*100,2)) 

## ------------------------------------------------------------------------
nids%>%
  group_by(w1_best_race)%>%
  summarise(freq=n()) %>%
  na.omit() %>% #remove category for missing
  mutate(percent = round(freq/sum(freq)*100,2), cum_percent = round(cumsum(freq)/sum(freq)*100,2)) 

## ---- echo=FALSE, roof, out.height="100%",fig.cap="Labels for main material used for roof"----
knitr::include_graphics("./images/roof.png")

## ------------------------------------------------------------------------
nids%>%
  group_by(w1_h_d3_1)%>%
  summarise(freq=n()) %>%
  mutate(percent = round(freq/sum(freq)*100,2), cum_percent = round(cumsum(freq)/sum(freq)*100,2)) 

## ------------------------------------------------------------------------
nids<-nids%>%
  mutate(mat = ifelse(w1_h_d3_1>0 , w1_h_d3_1, NA))

## ------------------------------------------------------------------------
nids%>%
  group_by(mat)%>%
  summarise(freq=n()) %>%
  na.omit() %>% 
  mutate(cum_freq = cumsum(freq), percent = round(freq/sum(freq)*100,2), cum_percent = round(cumsum(freq)/sum(freq)*100,2)) 

## ------------------------------------------------------------------------
nids%>%
  filter(hhrestrict==1)%>%
  group_by(mat)%>%
  summarise(freq=n()) %>%
  na.omit() %>% 
  mutate(cum_freq = cumsum(freq), percent = round(freq/sum(freq)*100,2), cum_percent = round(cumsum(freq)/sum(freq)*100,2))

## ---- echo=FALSE, satis, fig.cap="Labels for life satisfaction levels"----
knitr::include_graphics("./images/satisfaction.png")

## ------------------------------------------------------------------------
nids%>%
  group_by(w1_a_m5)%>%
  summarise(freq=n()) %>%
  mutate(cum_freq = cumsum(freq), percent = round(freq/sum(freq)*100,2), cum_percent = round(cumsum(freq)/sum(freq)*100,2))

## ---- echo=FALSE, quest, out.height="80%",fig.cap="Labels for questionnaire type"----
knitr::include_graphics("./images/quest_typ.png")

## ------------------------------------------------------------------------
nids%>%
  filter(w1_quest_typ == 1) %>% 
  group_by(w1_a_m5)%>%
  summarise(freq=n()) %>%
  mutate(cum_freq = cumsum(freq), percent = round(freq/sum(freq)*100,2), cum_percent = round(cumsum(freq)/sum(freq)*100,2))

## ---- echo=FALSE, refusal, fig.cap="Labels for refusals"-----------------
knitr::include_graphics("./images/refusal.png")

## ------------------------------------------------------------------------
nids%>%
  group_by(w1_a_a21)%>%
  summarise(freq=n()) %>%
  mutate(percent = round(freq/sum(freq)*100,2), cum_percent = round(cumsum(freq)/sum(freq)*100,2))

## ------------------------------------------------------------------------
nids<-nids %>% 
  mutate(refusal_dummy=ifelse(is.na(w1_a_a21),0,1))

## ------------------------------------------------------------------------
nids%>%
  group_by(refusal_dummy)%>%
  summarise(freq=n())

## ------------------------------------------------------------------------
nids %>% 
  filter(w1_quest_typ == 1 & refusal_dummy == 0) %>% 
  group_by(w1_a_m5) %>% 
  summarise(freq=n()) %>%
  mutate(percent = round(freq/sum(freq)*100,2), cum_percent = round(cumsum(freq)/sum(freq)*100,2))

## ---- echo=FALSE, c110, fig.cap="Labels for question C1.10"--------------
knitr::include_graphics("./images/c110.png")

## ------------------------------------------------------------------------
nids %>% 
  group_by(w1_a_c1_10) %>% 
  summarise(freq=n()) %>%
  mutate(percent = round(freq/sum(freq)*100,2), cum_percent = round(cumsum(freq)/sum(freq)*100,2))

## ------------------------------------------------------------------------
nids %>% 
  filter(!is.na(w1_a_m5)) %>% 
  group_by(w1_a_m5) %>% 
  summarise(freq=n()) %>%
  mutate(percent = round(freq/sum(freq)*100,2), cum_percent = round(cumsum(freq)/sum(freq)*100,2))

## ------------------------------------------------------------------------
#nids %>% 
#  select(w1_a_m5) %>% 
#  filter(w1_a_m5>5) %>%
#  View

## ------------------------------------------------------------------------
nids %>% 
  filter(!is.na(w1_a_m5) & w1_a_m5 >0) %>% 
  group_by(w1_a_m5) %>% 
  summarise(freq=n()) %>%
  mutate(percent = round(freq/sum(freq)*100,2), cum_percent = round(cumsum(freq)/sum(freq)*100,2))

## ------------------------------------------------------------------------
print(sessionInfo(), locale = FALSE)

