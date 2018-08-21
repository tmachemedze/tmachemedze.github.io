## ------------------------------------------------------------------------
library(foreign)
library(tidyverse)

nids<-read.dta("./data/nids.dta", convert.factors=FALSE)

nids<-nids%>% 
  arrange(hhid, pid)%>%
  group_by(hhid) %>%
  mutate(hhrestrict = 1:n()) %>%
  mutate(hhrestrict = ifelse(hhrestrict==1,1,0))

###Creating a BMI variable - from chapter 2 ***

#Height
nids<-nids %>%
  mutate(height = ifelse (w1_a_n1_1 >= 0 & w1_a_best_age_yrs >= 20, w1_a_n1_1/100, NA))

#Weight
nids<-nids %>%
  mutate(weight = ifelse (w1_a_n2_1 >= 0 & w1_a_best_age_yrs > 20, w1_a_n2_1, NA)) 

#BMI
nids<-nids %>%
  mutate(bmi = weight/height^2)

#Age
nids<-nids%>%
  mutate(age_adult = ifelse(w1_a_best_age_yrs<0,NA, w1_a_best_age_yrs))

#Age bins
nids$age_bins<-NA
nids$age_bins[which(nids$w1_r_best_age_yrs>=20 & nids$w1_r_best_age_yrs<=29)]<-1
nids$age_bins[which(nids$w1_r_best_age_yrs>29 & nids$w1_r_best_age_yrs<=39)]<-2
nids$age_bins[which(nids$w1_r_best_age_yrs>39 & nids$w1_r_best_age_yrs<=49)]<-3
nids$age_bins[which(nids$w1_r_best_age_yrs>49 & nids$w1_r_best_age_yrs<=59)]<-4
nids$age_bins[which(nids$w1_r_best_age_yrs>59 & nids$w1_r_best_age_yrs<=69)]<-5
nids$age_bins[which(nids$w1_r_best_age_yrs>69 & nids$w1_r_best_age_yrs<=120)]<-6

nids$age_bins <- factor(nids$age_bins, levels = 1:6, labels = c("20 - 29 yrs","30 - 39 yrs", "40 - 49 yrs", "50 - 59 yrs", "60 - 69 yrs", "70 - 120 yrs"))

nids <- nids%>%
  rename(race = w1_best_race,
        age = w1_r_best_age_yrs,
        gender = w1_r_b4,
        province = w1_hhprov, 
        hhincome = w1_hhincome) %>% 
  mutate(gender = factor(gender, levels = 1:2, labels = c("Male", "Female")),
         race = factor(race, levels = 1:4, labels = c("African", "Coloured","Asian", "White")),
         province = factor(province, levels=1:9, labels = c("Western Cape","Eastern Cape","Northern Cape","Free State","KwaZulu-Natal","North West","Gauteng","Mpumalanga","Limpopo")),
         w1_hhgeo = factor(w1_hhgeo, levels = 1:4, labels = c("Rural formal", "Tribal authority areas","Urban formal", "Urban informal")))

## ------------------------------------------------------------------------
library(scales)
ggplot(nids, aes(x = w1_fwag, y = (..count..)/sum(..count..)*100)) + 
  geom_histogram() + 
  scale_x_continuous(breaks=seq(0,90000,10000), labels = comma) + 
  xlab("Earnings in Rand") +
  ylab("Percent") +
  ggtitle("Monthly Take Home Pay") +
  theme_classic()


## ------------------------------------------------------------------------
summary(nids$w1_fwag)

## ------------------------------------------------------------------------
nids<-nids %>% 
  mutate(class = case_when(
    w1_fwag<=1500 ~ 1,
    w1_fwag>1500 & w1_fwag<=4500 ~ 2,
    w1_fwag>4500 ~ 3
  )) %>% 
  mutate(class=factor(class, levels=1:3, labels = c("Lower Class","Middle Class","Upper Class")))

## ------------------------------------------------------------------------
table(nids$class)

## ------------------------------------------------------------------------
nids %>% 
  filter(!is.na(class)) %>% 
  group_by(class) %>% 
  summarise(freq=n()) %>%
  mutate(percent = round(freq/sum(freq)*100,2), cum_percent = round(cumsum(freq)/sum(freq)*100,2))

## ------------------------------------------------------------------------
summary(nids$w1_fwag)

## ------------------------------------------------------------------------
by(nids[, c("w1_fwag")], nids$race, summary)

## ------------------------------------------------------------------------
nids %>% 
  select(hhid,race, w1_fwag) %>% 
  group_by(race) %>% 
  summarise(min=min(w1_fwag, na.rm=TRUE), 
            median=median(w1_fwag, na.rm=TRUE),
            mean=mean(w1_fwag, na.rm=TRUE),
            max=max(w1_fwag, na.rm=TRUE),
            std.dev=sd(w1_fwag, na.rm=TRUE))

## ------------------------------------------------------------------------
nids$agegrp<-NA
nids$agegrp[which(nids$age>=0 & nids$age<=20)]<-1
nids$agegrp[which(nids$age>20 & nids$age<=40)]<-2
nids$agegrp[which(nids$age>40 & nids$age<=60)]<-3
nids$agegrp[which(nids$age>60 & nids$age<=120)]<-4

## ------------------------------------------------------------------------
nids$agegrp<-factor(nids$agegrp, levels=1:4, labels=c("0 - 20 yrs", "21 - 40 yrs","41 - 60 yrs", "60+ yrs"))

## ------------------------------------------------------------------------
nids%>%
  group_by(agegrp)%>%
  summarise(Mean=mean(w1_fwag, na.rm=TRUE), 
       Std.Dev=sd(w1_fwag, na.rm=TRUE), 
       Min=min(w1_fwag, na.rm=TRUE),
       Max=max(w1_fwag, na.rm=TRUE))

## ------------------------------------------------------------------------
summary(nids$w1_fwag)

## ------------------------------------------------------------------------
nids%>%
  group_by(w1_best_edu) %>%
  summarise(n=n())

## ------------------------------------------------------------------------
nids%>%
  filter(age >= 21 & !is.na(age))%>%
  group_by(w1_best_edu) %>%
  summarise(n=n())%>%
  print()

## ---- echo=FALSE, bestedu, fig.cap="Education codes"---------------------
knitr::include_graphics("./images/best_edu.png")

## ------------------------------------------------------------------------
nids$educ.new<-nids$w1_best_edu
nids$educ.new[which(nids$w1_best_edu == 25)]<-0

## ------------------------------------------------------------------------
nids$educ.new[which(nids$w1_best_edu <0)]<-NA

## ------------------------------------------------------------------------
nids$educ.new[which(nids$w1_best_edu == 24)]<-NA

## ------------------------------------------------------------------------
nids$educ.new[which(nids$w1_best_edu == 13 | nids$w1_best_edu == 16)]<-10
nids$educ.new[which(nids$w1_best_edu == 14 | nids$w1_best_edu == 17)]<-11
nids$educ.new[which(nids$w1_best_edu == 15)]<-12

## ------------------------------------------------------------------------
nids$educ.new[which(nids$w1_best_edu == 18)]<-13
nids$educ.new[which(nids$w1_best_edu == 18)]<-13
nids$educ.new[which(nids$w1_best_edu == 19)]<-14
nids$educ.new[which(nids$w1_best_edu == 20)]<-15
nids$educ.new[which(nids$w1_best_edu == 21 | nids$w1_best_edu == 22)]<-16
nids$educ.new[which(nids$w1_best_edu == 23)]<-17

## ------------------------------------------------------------------------
nids%>%
  group_by(educ.new)%>%
  summarise(n=n())

## ------------------------------------------------------------------------
nids%>%
  ggplot(., aes(x=educ.new)) + 
  geom_histogram(aes(y = ..count..*100/sum(..count..)), binwidth=0.5)+ 
  xlab("Recoded education") + 
  ylab("Percent") +
  theme_classic()

## ------------------------------------------------------------------------
summary(nids$educ.new)

## ------------------------------------------------------------------------
nids%>%
  filter(age >= 21 & !is.na(age))%>%
  select(educ.new)%>%
  ungroup() %>% 
  summarise(Mean=mean(educ.new, na.rm=T))

## ------------------------------------------------------------------------
nids%>%
  filter(age == 23 & !is.na(age))%>%
  select(educ.new)%>%
  ungroup() %>% 
  summarise(Mean=mean(educ.new, na.rm=T))

## ------------------------------------------------------------------------
set.seed(123) 
d1<-data.frame(dist="distr1", value=rnorm(10000, 4500, 1000))
d2<-data.frame(dist="distr2", value=rnorm(10000, 4500, 500))

df<-rbind(d1,d2)

ggplot(df, aes(x=value, y=..count../sum(..count..))) + 
  geom_histogram() +
  facet_grid(.~dist) +
  labs(x="Income distribution", y="Fraction") +
  theme_minimal()

## ------------------------------------------------------------------------
nids%>%
  group_by(race)%>%
  summarise(Mean=mean(w1_fwag, na.rm=TRUE), 
            Std.Dev=sd(w1_fwag, na.rm=TRUE), 
            Min=min(w1_fwag, na.rm=TRUE), 
            Max=max(w1_fwag, na.rm=TRUE))

## ------------------------------------------------------------------------
nids<-nids%>%
  arrange(hhid)%>%
  mutate(w1_hhsizer2 = ifelse(hhrestrict == 1, w1_hhsizer, NA))

## ------------------------------------------------------------------------
nids%>%
  ungroup() %>% 
  summarise(Mean=mean(w1_hhsizer2, na.rm=TRUE), 
            Std.Dev=sd(w1_hhsizer2, na.rm=TRUE), 
            Min=min(w1_hhsizer2, na.rm=TRUE), 
            Max=max(w1_hhsizer2, na.rm=TRUE))

## ------------------------------------------------------------------------
nids%>%
  group_by(w1_hhgeo)%>%
  summarise(Mean=mean(w1_hhsizer2, na.rm=TRUE), 
            Std.Dev=sd(w1_hhsizer2, na.rm=TRUE), 
            Min=min(w1_hhsizer2, na.rm=TRUE), 
            Max=max(w1_hhsizer2, na.rm=TRUE))
#by(nids[, c("w1_hhsizer2")], nids$w1_hhgeo, summary)

## ------------------------------------------------------------------------
nids<-nids%>%
  mutate(w1_fwag2 = ifelse(w1_fwag>50000,NA, w1_fwag))

## ------------------------------------------------------------------------
summary(nids[,c("w1_fwag", "w1_fwag2")])

## ------------------------------------------------------------------------
by(nids[, c("w1_fwag", "w1_fwag2")], nids$race, summary)

## ------------------------------------------------------------------------
nids%>%
  ggplot(., aes(x=w1_fwag)) +
  geom_histogram(aes(y = ..density..), binwidth=0.1, labels = comma) +
  scale_x_log10() +
  labs(x="Natural Log of Income",y ="Density") +
  theme_classic()

## ------------------------------------------------------------------------
summary(nids$race) #summary factor returns the frequencies
summary(as.numeric(nids$race))

## ------------------------------------------------------------------------
summary(nids$race)

## ------------------------------------------------------------------------
table(nids$w1_a_e4_code)

## ------------------------------------------------------------------------
nids %>% 
  group_by(w1_a_e4_code) %>% 
  summarise(freq=n()) %>% 
  na.omit()

## ---- echo=FALSE, occup, fig.cap="Occupational Codes"--------------------
knitr::include_graphics("./images/occup.png")

## ------------------------------------------------------------------------
summary(nids$w1_a_e4_code)

## ------------------------------------------------------------------------
table(nids$w1_a_m5)

## ------------------------------------------------------------------------
nids<-nids%>%
  mutate(satisfaction = ifelse(w1_a_m5<0,NA,w1_a_m5))

## ------------------------------------------------------------------------
summary(nids$satisfaction)

## ------------------------------------------------------------------------
nids%>%
  group_by(w1_hhgeo)%>%
  summarise(Mean=mean(satisfaction, na.rm=TRUE),
       Std.Dev=sd(satisfaction, na.rm=TRUE), 
       Min=min(satisfaction, na.rm=TRUE),
       Max=max(satisfaction, na.rm=TRUE))

## ------------------------------------------------------------------------
summary(nids$bmi)

## ------------------------------------------------------------------------
nids%>%
  filter(bmi < 15 | (bmi > 50 & !is.na(bmi)))%>%
  nrow
         
#nrow(subset(nids, bmi < 15 | (bmi > 50 & !is.na(bmi))))

## ------------------------------------------------------------------------
nids%>%
  select(weight, height, bmi)%>%
  filter(bmi < 15 | bmi > 50)%>%
  head(20)

#head(subset(nids,subset=(bmi < 15 | (bmi > 50 & bmi<=max(bmi))), select=c(weight, height, bmi)) )

## ------------------------------------------------------------------------
summary(nids$bmi)

## ------------------------------------------------------------------------
summary(subset(nids, subset=(bmi >15 & bmi < 50), select=c(bmi)))
#summary(nids[nids$bmi >15 & nids$bmi < 50,c("bmi")])

## ------------------------------------------------------------------------
nids<-nids%>%
  mutate(bmi_valid = ifelse(bmi > 15 & bmi < 50,1,NA))

## ------------------------------------------------------------------------
nids$bmi.bins.nolabel<-NA
nids$bmi.bins.nolabel[which(nids$bmi>=15 & nids$bmi<18.5)]<-1
nids$bmi.bins.nolabel[which(nids$bmi>=18.5 & nids$bmi<25)]<-2
nids$bmi.bins.nolabel[which(nids$bmi>=25 & nids$bmi<30)]<-3
nids$bmi.bins.nolabel[which(nids$bmi>=30 & nids$bmi<=50)]<-4

## ------------------------------------------------------------------------
nids$bmi.bins<-factor(nids$bmi.bins.nolabel, levels=1:4, labels = c("Underweight","Normal", "Overweight", "Obese"))

## ------------------------------------------------------------------------
nids%>%
  select(bmi, bmi.bins.nolabel, bmi.bins)%>%
  head(15)

## ------------------------------------------------------------------------
#by(nids[,c("bmi")], nids$race, summary)
nids%>%
  group_by(race)%>%
  summarise(Mean=mean(bmi, na.rm=TRUE),
       Std.Dev=sd(bmi, na.rm=TRUE), 
       Min=min(bmi, na.rm=TRUE),
       Max=max(bmi, na.rm=TRUE))

## ------------------------------------------------------------------------
nids%>%
  group_by(age_bins)%>%
  summarise(Mean=mean(bmi, na.rm=TRUE),
       Std.Dev=sd(bmi, na.rm=TRUE), 
       Min=min(bmi, na.rm=TRUE),
       Max=max(bmi, na.rm=TRUE)) %>% 
  na.omit()

## ------------------------------------------------------------------------
nids%>%
  filter(!is.na(race))%>%
  ggplot(., aes(x=age_adult)) +
  geom_histogram( aes(y = ..density..), binwidth = 1) +
  labs(x="Age in years - adults", y = "Density") +
  facet_wrap(~race) +
  theme_classic()

## ------------------------------------------------------------------------
print(sessionInfo(), locale = FALSE)

