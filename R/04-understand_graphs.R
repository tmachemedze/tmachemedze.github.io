## ----message=FALSE, warning=FALSE----------------------------------------
library(tidyverse)
library(foreign)
nids<-read.dta("./data/nids.dta", convert.factors=FALSE)

nids <- nids%>%
  arrange(hhid, pid)%>%
  #Tag hhid
  group_by(hhid) %>%
  mutate(hhrestrict = 1:n()) %>%
  mutate(hhrestrict = ifelse(hhrestrict==1,1,0))

## ------------------------------------------------------------------------
#We rename some variables for ease of use.
nids<-nids %>% 
 mutate(race = w1_best_race,
        age = w1_r_best_age_yrs,
        gender = w1_r_b4,
        province = w1_hhprov, 
        hhincome = w1_hhincome) %>% 
  mutate(gender = factor(gender, levels = 1:2, labels = c("Male", "Female")),
         race = factor(race, levels = 1:4, labels = c("African", "Coloured","Asian", "White")),
         province = factor(province, levels=1:9, labels = c("Western Cape","Eastern Cape","Northern Cape","Free State","KwaZulu-Natal","North West","Gauteng","Mpumalanga","Limpopo")),
         w1_hhgeo = factor(w1_hhgeo, levels = 1:4, labels = c("Rural formal", "Tribal authority areas","Urban formal", "Urban informal")))

## ------------------------------------------------------------------------
ggplot(data=nids, aes(x = w1_h_expenditure)) + geom_histogram()

## ---- message=FALSE, warning=FALSE---------------------------------------
library(scales)
ggplot(data=nids, aes(x = w1_h_expenditure)) +
  geom_histogram(binwidth = 3100) +
  scale_x_continuous(breaks=seq(0,150000,50000), labels = comma) + 
  xlab("Household Expenditure with full imputations") +
  ylab("Percent") +
  ggtitle("Percent distribution of household expenditure") +
  theme_classic()

## ------------------------------------------------------------------------
nids<-rename(nids, food = w1_h_expf) 

## ------------------------------------------------------------------------
nids%>% 
  filter(hhrestrict==1) %>% 
  ggplot(., aes(x = food, y = (..count..)/sum(..count..)*100)) +  # to create a density
  scale_x_continuous(breaks=seq(0,15000,5000), labels = comma) + 
  geom_histogram(binwidth = 400) +
  xlab("Household Food Expenditure (full imputations)") +
  ylab("Percent") +
  ggtitle("Percent distribution of household food expenditure") +
  theme_classic()

## ------------------------------------------------------------------------
nids%>%filter(food>5000 & hhrestrict==1) %>%nrow

## ------------------------------------------------------------------------
nids%>%
  filter(food<5000 & hhrestrict==1)%>% 
  ggplot(., aes(x = food, y = (..count..)/sum(..count..)*100)) + 
  scale_x_continuous(breaks=seq(0,5000,1000), labels = comma) + 
  geom_histogram(binwidth = 130) +
  xlab("Household Food Expenditure (full imputations)") +
  ylab("Percent") +
  ggtitle("Percent distribution of household food expenditure") +
  theme_classic()

## ------------------------------------------------------------------------
nids%>%
  filter(food<5000 & hhrestrict==1)%>% 
  ggplot(., aes(x = food, y = (..count..)/sum(..count..)*100)) + 
  scale_x_continuous(breaks=seq(0,5000,1000), labels = comma) + 
  geom_histogram(binwidth = 130) +
  labs(x = "Expenditure in Rand", 
       y = "Percent",
       title = "Total Monthly Household Food Expenditure \n (full imputations)", 
       caption="Source: 2008 data from National Income Dynamics Study") +
  theme_classic()

## ------------------------------------------------------------------------
nids%>%
  filter(food<5000 & hhrestrict==1 & !is.na(race))%>%
  ggplot(., aes(x = food, y = ..density..)) + 
  scale_x_continuous(breaks=seq(0,5000,1000), labels = comma) + 
  geom_histogram(binwidth = 130) +
  labs(x = "Expenditure in Rand", 
       y = "Density",
       title = "Total Monthly Household Food Expenditure \n (full imputations)", 
       caption="Source: 2008 data from National Income Dynamics Study") +
  scale_y_continuous(labels = percent_format()) +
  facet_wrap(~race, ncol=2) +
  theme_classic()

## ------------------------------------------------------------------------
nids<-nids %>%
  mutate(adult20 = ifelse(age>=20 & !is.na(age),1,0))

## ------------------------------------------------------------------------
nids%>%
  ungroup() %>% 
  filter(adult20==1) %>%
  select(w1_a_j29) %>%
  summary

## ------------------------------------------------------------------------
nids<-nids%>%
  mutate(eversmoke = ifelse((w1_a_j26==1 | w1_a_j27==1) & adult20==1,1,0))

## ------------------------------------------------------------------------
nids%>%
  filter(!is.na(w1_a_j29) & eversmoke!=1 & adult20==1) %>%
  nrow

## ------------------------------------------------------------------------
nids%>%
  filter(!is.na(w1_a_j29) & eversmoke!=1 & adult20==1)%>%
  select(w1_a_j29)

## ------------------------------------------------------------------------
nids%>%
  filter(w1_a_j29 <0 & adult20==1)%>%
  nrow

## ------------------------------------------------------------------------
nids<-nids%>%
  mutate(smoking_age = ifelse(w1_a_j29 > 0 & !is.na(w1_a_j29) & adult20==1,w1_a_j29,NA))

## ------------------------------------------------------------------------
ggplot(nids, aes(x=smoking_age, y = ..density..)) +
  geom_histogram(binwidth = 1.7714286) +
  xlab("Smoking age") +
  theme_classic()

## ------------------------------------------------------------------------
nids %>% 
  ggplot(., aes(x=smoking_age, y = ..density..)) +
  geom_histogram(binwidth = 1.7714286) + #binwidth chosen to replicate the stata output
  xlab("Smoking age") +
  facet_wrap(~gender) +
  theme_classic()

## ------------------------------------------------------------------------
#ggplot(nids, aes(x=smoking_age, y = (..count..)/sum(..count..))) +
#  geom_histogram(binwidth = 1.7714286) +
#  xlab("Smoking age") +
#  facet_wrap(~gender)

## ------------------------------------------------------------------------
ggplot(nids, aes(x = factor(1), fill = gender)) +
  geom_bar(width = 1) + coord_polar(theta = "y") + 
  scale_fill_grey(start=0, end=0.5) +
  theme_classic()

## ------------------------------------------------------------------------
nids%>%
  filter(age==0 | age==1)%>%
  select(gender)%>%
  ggplot(., aes(x = factor(1), fill = gender)) +
  geom_bar(width = 1) + 
  coord_polar(theta = "y") + 
  scale_fill_grey(start=0, end=0.5)+
  theme_classic()

## ------------------------------------------------------------------------
nids %>% 
  group_by(province,race) %>% 
  summarise(freq=n()) %>% 
  group_by(province) %>% 
  mutate(percent = round(freq/sum(freq)*100,2))  %>% 
  ggplot(., aes(x=factor(1), y=percent, fill = race)) +
  geom_bar(stat = "identity",width = 1) +
  facet_wrap(~province) +
  labs(x="",y="") +
  coord_polar(theta = "y") +
  theme_classic()

## ------------------------------------------------------------------------
nids %>% 
  group_by(province,race) %>% 
  summarise(freq=n()) %>% 
  na.omit() %>% 
  group_by(province) %>% 
  mutate(percent = round(freq/sum(freq)*100,2))  %>% 
  ggplot(., aes(x=factor(1), y=percent, fill = race)) +
  geom_bar(stat = "identity",width = 1) +
  facet_wrap(~province) +
  labs(x="",y="") +
  coord_polar(theta = "y") +
  theme_classic()

## ------------------------------------------------------------------------
table(nids$w1_hhgeo)

## ------------------------------------------------------------------------
nids %>% 
  group_by(w1_hhgeo) %>% 
  summarise(freq=n()) %>%
  mutate(percent = round(freq/sum(freq)*100,2), cum_percent = round(cumsum(freq)/sum(freq)*100,2))

## ------------------------------------------------------------------------
nids%>%
  ggplot(., aes(x = factor(1), fill = w1_hhgeo)) +
  geom_bar(width = 1) + 
  coord_polar(theta = "y")+
  theme_classic()

## ------------------------------------------------------------------------
nids$smoke.agecat<-NA
nids$smoke.agecat[which(nids$smoking_age>=0 & nids$smoking_age<=15)]<-1
nids$smoke.agecat[which(nids$smoking_age>16 & nids$smoking_age<=19)]<-2
nids$smoke.agecat[which(nids$smoking_age>20 & nids$smoking_age<=29)]<-3
nids$smoke.agecat[which(nids$smoking_age>30 & nids$smoking_age<=67)]<-4

nids$smoke.agecat<-factor(nids$smoke.agecat, levels = 1:4, labels = c("<16","16-19","20-29","30+"))

## ------------------------------------------------------------------------
nids%>%
  filter(!is.na(smoke.agecat))%>%
  ggplot(., aes(x = factor(1), fill = smoke.agecat)) +
  geom_bar(width = 1) + 
  coord_polar(theta = "y")+
  theme_classic()

## ------------------------------------------------------------------------
nids %>% 
  group_by(gender,smoke.agecat) %>% 
  summarise(freq=n()) %>% 
  na.omit() %>% 
  group_by(gender) %>% 
  mutate(percent = round(freq/sum(freq)*100,2))  %>% 
  ggplot(., aes(x=factor(1), y=percent, fill = smoke.agecat)) +
  geom_bar(stat = "identity",width = 1) +
  facet_grid(.~gender) +
  labs(x="",y="") +
  coord_polar(theta = "y")+
  theme_classic()

## ------------------------------------------------------------------------
nrow(subset(nids, subset=smoke.agecat=="<16"))

## ------------------------------------------------------------------------
nrow(subset(nids, subset=smoking_age==17))
nrow(subset(nids, subset=smoking_age==18))
nrow(subset(nids, subset=smoking_age==19))

## ------------------------------------------------------------------------
nids<-nids%>%
  mutate(satisfaction = ifelse(w1_a_m5>=1, w1_a_m5, NA))

## ------------------------------------------------------------------------
nids%>%
  group_by(race)%>%
  summarise(msatis = mean(satisfaction, na.rm=TRUE))%>%
  ggplot(., aes(x = race, y = msatis)) + geom_bar(stat = "identity", width=.3) +
  xlab("Race") + ylab("Mean satisfaction") +
  theme_classic()

## ------------------------------------------------------------------------
nids%>%
  filter(!is.na(race))%>%
  group_by(race)%>%
  summarise(msatis = mean(satisfaction, na.rm=TRUE))%>%
  ggplot(., aes(x = race, y = msatis)) + geom_bar(stat = "identity", width=.3) +
  xlab("Race") + ylab("Mean satisfaction") +
  theme_classic()

## ------------------------------------------------------------------------
nids%>%
  group_by(gender)%>%
  summarise(msatis = mean(satisfaction, na.rm=TRUE))%>%
  ggplot(., aes(x = gender, y = msatis)) + geom_bar(stat = "identity", width=.3) +
  xlab("Race") + ylab("Mean satisfaction") +
  theme_classic()

## ------------------------------------------------------------------------
nids%>%
  filter(!is.na(race))%>%
  group_by(race, gender)%>%
  summarise(msatis = mean(satisfaction, na.rm=TRUE))%>%
  ggplot(., aes(x = race, y = msatis)) + geom_bar(stat = "identity", width=.3) +
  xlab("Race") + ylab("Mean satisfaction") +
  facet_wrap(~gender, ncol=2) +
  theme_classic()

## ------------------------------------------------------------------------
nids%>%
  filter(!is.na(race))%>%
  group_by(race, gender)%>%
  summarise(msatis = mean(satisfaction, na.rm=TRUE))%>%
  ggplot(., aes(x = race, y = msatis)) + geom_bar(stat = "identity", width=.5) +
  labs(x = "Population group", y = "Satisfaction Scale (1 - 10)",title = "Mean Satisfaction \n by Race and Gender") +
  facet_wrap(~gender, ncol=2) +
  geom_text(aes(label=round(msatis,2)), vjust=1.4, color="white") +
  theme_classic() 

## ------------------------------------------------------------------------
nids%>%
  group_by(race, gender)%>%
  summarise(msatis = mean(satisfaction, na.rm=TRUE))%>%
  na.omit() %>% 
  ggplot(., aes(x = gender, y = msatis)) + geom_bar(stat = "identity", width=.5) +
  labs(x = "Population group", y = "Satisfaction Scale (1 - 10)",title = "Mean Satisfaction \n by Race and Gender") +
  geom_text(aes(label=round(msatis,2)), vjust=1.4, color="white") +
  ggtitle("Mean Satisfaction \n by Race and Gender") +
  facet_grid(~race) +
  theme_classic()

## ---- echo=FALSE, alcohol, out.height="100%",fig.cap="Labels for alcohol consumption"----
knitr::include_graphics("./images/alcohol.png")

## ------------------------------------------------------------------------
nids%>% 
  filter(adult20==1)%>%
  group_by(w1_a_j31)%>%
  summarise(n=n())

## ------------------------------------------------------------------------
#
nids$alc<-NA
#People who have never drunk alcohol
nids$alc[nids$w1_a_j31 ==1 & nids$adult20==1]<-1 

#People who drink rarely (no longer, or less than once a week)
nids$alc[(nids$w1_a_j31 == 2 | nids$w1_a_j31 == 3| nids$w1_a_j31==4) & nids$adult20==1]<-2 

#Frequent drinkers: between 1 and 4 days a week.
nids$alc[(nids$w1_a_j31 == 5 | nids$w1_a_j31 == 6) & nids$adult20==1]<-3

#Very frequent drinkers: more than 5 days a week.
nids$alc[(nids$w1_a_j31 == 7 | nids$w1_a_j31 == 8) & nids$adult20==1]<-4

## ------------------------------------------------------------------------
nids<-nids %>%
  mutate(alc = ifelse(adult20==1, alc, NA)) %>%
  mutate(alc = factor(alc, levels = 1:4, labels = c("Never drank alcohol", "Drink rarely","Frequent drinkers", "Very frequent drinkers")))

## ------------------------------------------------------------------------
nids%>%
  filter(!is.na(alc)) %>%
  ggplot(., aes(x = alc, fill=alc)) +
  geom_bar(aes(y = ..count../sum(..count..))) + 
  xlab("Alcohol consumption") + ylab("Proportion of sample") +
  theme_classic() +
  theme(axis.text.x=element_text(angle=90))

## ------------------------------------------------------------------------
nids%>%
  filter(!is.na(alc) & !is.na(race))%>%
  ggplot(.) +
  stat_count(aes(x= alc, y= ..prop.., group = race)) +
  xlab("Alcohol consumption") + ylab("Proportion of sample") +
  facet_wrap(~race, ncol=2) +
  theme_classic() +
  theme(axis.text.x=element_text(angle=90))

## ------------------------------------------------------------------------
print(sessionInfo(), locale = FALSE)

