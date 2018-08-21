## ------------------------------------------------------------------------
library(foreign)
library(tidyverse)

nids<-read.dta("./data/nids.dta", convert.factors=FALSE)

nids<-nids%>% 
  arrange(hhid, pid)%>%
  group_by(hhid) %>%
  mutate(hhrestrict = 1:n()) %>%
  mutate(hhrestrict = ifelse(hhrestrict==1,1,0))


#Class
nids$class<-NA
nids$class[which(nids$w1_fwag<=1500)]<-1
nids$class[which(nids$w1_fwag>1500 & nids$w1_fwag<=4500)]<-2
nids$class[which(nids$w1_fwag>4500)]<-3

nids$class<-factor(nids$class, levels=1:3, labels = c("Lower Class","Middle Class","Upper Class"))


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

#Valid BMI values
nids<-nids%>%
  mutate(bmi_valid = ifelse(bmi > 15 & bmi < 50,1,NA))

#BMI bins
nids$bmi.bins.nolabel<-NA
nids$bmi.bins.nolabel[which(nids$bmi>=15 & nids$bmi<18.5)]<-1
nids$bmi.bins.nolabel[which(nids$bmi>=18.5 & nids$bmi<25)]<-2
nids$bmi.bins.nolabel[which(nids$bmi>=25 & nids$bmi<30)]<-3
nids$bmi.bins.nolabel[which(nids$bmi>=30 & nids$bmi<=50)]<-4

nids$bmi.bins<-factor(nids$bmi.bins.nolabel, levels=1:4, labels = c("Underweight","Normal", "Overweight", "Obese"))

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

#Rename
nids <- nids%>%
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
cor(nids[nids$hhrestrict==1,c("w1_hhincome","w1_h_expenditure")], use="complete.obs")

## ------------------------------------------------------------------------
nids %>% 
  filter(hhrestrict==1) %>% 
  ungroup() %>% 
  select(w1_hhincome,w1_h_expenditure) %>%
  cor() #check cor arguments if you want to change the default

## ------------------------------------------------------------------------
library(scales)
nids%>%
  filter(hhrestrict==1)%>%
  select(w1_h_expenditure, w1_hhincome)%>%
  ggplot(., aes(x = w1_hhincome, y = w1_h_expenditure)) + 
  geom_point() + 
  scale_x_continuous(breaks=seq(0,150000,50000), labels = comma) +
  scale_y_continuous(breaks=seq(0,150000,50000), labels = comma) +
  xlab("Household monthly income - full imputations") + ylab("Household Expenditure with full imputations")+
  theme_classic()

## ------------------------------------------------------------------------
nids%>%
  filter(hhrestrict==1)%>%
  select(w1_h_expenditure, w1_hhincome)%>%
  ggplot(., aes(x = w1_hhincome, y = w1_h_expenditure)) + 
  geom_point() + 
  scale_x_continuous(breaks=seq(0,150000,50000), labels = comma) +
  scale_y_continuous(breaks=seq(0,150000,50000), labels = comma) +
  xlab("Household monthly income - full imputations") + ylab("Household Expenditure with full imputations") +
  stat_smooth(method = "lm", se = FALSE, colour = "blue") +
  theme_classic()

## ------------------------------------------------------------------------
scatter<-nids%>%
  filter(hhrestrict==1)%>%
  select(w1_h_expenditure, w1_hhincome)

ggplot(scatter, aes(x = w1_hhincome, y = w1_h_expenditure)) + 
  geom_point() + 
  scale_x_continuous(breaks=seq(0,150000,50000), labels = comma) +
  scale_y_continuous(breaks=seq(0,150000,50000), labels = comma) +
  xlab("Household monthly income - full imputations") + ylab("Household Expenditure with full imputations") +
  stat_smooth(method = "lm", se = FALSE, colour = "blue") +
  geom_point(data = subset(scatter, w1_h_expenditure > 130000), aes(x = w1_hhincome, y = w1_h_expenditure), colour="red") +
  stat_smooth(data = subset(scatter, w1_h_expenditure < 130000), method = "lm", se = FALSE, colour = "green") +
  theme_classic()

## ------------------------------------------------------------------------
library(ggalt)
ggplot(scatter, aes(x = w1_hhincome, y = w1_h_expenditure)) + 
  geom_point() + 
  scale_x_continuous(breaks=seq(0,150000,50000), labels = comma) +
  scale_y_continuous(breaks=seq(0,150000,50000), labels = comma) +
  xlab("Household monthly income - full imputations") + ylab("Household Expenditure with full imputations") +
  stat_smooth(method = "lm", se = FALSE, colour = "blue") +
  stat_smooth(data = scatter %>% filter(w1_h_expenditure < 130000), method = "lm", se = FALSE, colour = "green") +
  geom_encircle(data = scatter %>% filter(w1_h_expenditure > 130000),
                aes(x = w1_hhincome, y = w1_h_expenditure), 
                color="red", 
                size=2, 
                expand=0.01) +
  theme_classic()

## ------------------------------------------------------------------------
scatter<-scatter %>% 
  mutate(spend=ifelse(w1_h_expenditure < w1_hhincome,1,2)) %>% 
  mutate(spend=factor(spend, levels=1:2,labels=c("expend<income", "expend>income"))) 

  ggplot(scatter, aes(x = w1_hhincome, y = w1_h_expenditure)) +
    geom_point(aes(x = w1_hhincome, y = w1_h_expenditure, color=spend)) +
    scale_color_manual(values=c("red","blue")) + 
    stat_smooth(method = "lm", se = FALSE, colour = "green") +
    stat_smooth(data = subset(scatter, w1_h_expenditure < w1_hhincome), method = "lm", se = FALSE, colour = "orange") + 
    scale_x_continuous(breaks=seq(0,150000,50000), labels = comma) +
    scale_y_continuous(breaks=seq(0,150000,50000), labels = comma) +
    xlab("Household monthly income") + ylab("Household Expenditure") +
    theme_classic()

## ------------------------------------------------------------------------
lm0 <- lm(w1_h_expenditure ~ w1_hhincome, data = nids %>% filter(hhrestrict==1))

## ------------------------------------------------------------------------
#anova(lm0)
summary(lm0)

## ------------------------------------------------------------------------
summary(lm0)$coefficients

## ------------------------------------------------------------------------
1115.014 + 0.6145542*5000

## ------------------------------------------------------------------------
attributes(lm0)

## ------------------------------------------------------------------------
nids2<-subset(nids,subset=hhrestrict==1, select=c(hhid, w1_hhincome,w1_h_expenditure))
lm0 <- lm(w1_h_expenditure ~ w1_hhincome, data = nids2)
nids2$yhat<-lm0$fitted.values

## ------------------------------------------------------------------------
head(nids2, n=20L)

## ------------------------------------------------------------------------
ggplot(nids2, aes(x = w1_hhincome, y = yhat)) +
  geom_point(aes(x = w1_hhincome, y = yhat), colour="blue") +
  scale_x_continuous(breaks=seq(0,150000,50000), labels = comma) +
  scale_y_continuous(breaks=seq(0,80000,20000), labels = comma) +
  xlab("Household monthly income") + ylab("Predicted household expenditure") +
  theme_classic()

## ------------------------------------------------------------------------
ggplot(nids2, aes(x = w1_hhincome, y = w1_h_expenditure)) +
  geom_point(aes(x = w1_hhincome, y = w1_h_expenditure), colour="blue") +
  geom_point(aes(x = w1_hhincome, yhat), colour="green", size = 3) +
  stat_smooth(method = "lm", se = FALSE, colour = "red") + 
  scale_x_continuous(breaks=seq(0,150000,50000), labels = comma) +
  scale_y_continuous(breaks=seq(0,150000,50000), labels = comma) +
  xlab("Household monthly income - full imputations") + ylab("Expenditure (Actual & Predicted)") +
  theme_classic()

## ------------------------------------------------------------------------
corr2.df<-nids[nids$bmi_valid==1,c("bmi","age_adult")]
cor(corr2.df,use="complete.obs")

## ------------------------------------------------------------------------
ggplot(corr2.df, aes(x = age_adult, y = bmi)) +
  geom_point(aes(x = age_adult, y = bmi), colour="blue") +
  stat_smooth(method = "lm", formula = y ~ x, se = FALSE, colour = "red") + 
  stat_smooth(method = "gam", formula= y ~ s(x, k = 3), se = FALSE, colour = "green", aes(colour = "polynomial")) +
  scale_x_continuous(breaks=seq(20,100,20), labels = comma) +
  scale_y_continuous(breaks=seq(10,50,10), labels = comma) +
  xlab("age in years - adults") + ylab("BMI") +
  theme_classic()

## ------------------------------------------------------------------------
bmi_age_df<-corr2.df%>%
  group_by(age_adult)%>%
  summarise(bmi_age = mean(bmi, na.rm = T)) #use mutate if you want to generate a new var as opposed to summarising

## ------------------------------------------------------------------------
head(bmi_age_df, n=20L)

## ------------------------------------------------------------------------
ggplot(bmi_age_df, aes(x = age_adult, y = bmi_age)) +
  geom_point(aes(x = age_adult, y = bmi_age), colour="blue") +
  xlab("Age") + ylab("Mean BMI (by age_adult)") +
  theme_classic()

## ------------------------------------------------------------------------
nids%>%
  group_by(age_bins, gender)%>%
  summarise(Mean = mean(bmi, na.rm=TRUE)) %>% 
  na.omit() %>% 
  arrange(gender, age_bins)

## ------------------------------------------------------------------------
fb60<-nids[nids$bmi_valid==1 & nids$age_adult < 60 & nids$w1_a_b2 == 2,c("bmi","age_adult")]
cor(fb60, use="complete.obs")

## ------------------------------------------------------------------------
fo60<-nids[nids$bmi_valid==1 & nids$age_adult > 60 & nids$w1_a_b2 == 2,c("bmi","age_adult")]
cor(fo60, use="complete.obs")

## ------------------------------------------------------------------------
mb60<-nids[nids$bmi_valid==1 & nids$age_adult < 60 & nids$w1_a_b2 == 1,c("bmi","age_adult")]
cor(mb60, use="complete.obs")

## ------------------------------------------------------------------------
mo60<-nids[nids$bmi_valid==1 & nids$age_adult > 60 & nids$w1_a_b2 == 1,c("bmi","age_adult")]
cor(mo60, use="complete.obs")

## ------------------------------------------------------------------------
nids %>% 
  filter(bmi_valid==1) %>% 
  select(bmi,age_adult, gender) %>% 
  ungroup() %>% 
  mutate(age_adult_2=ifelse(age_adult < 60,1,2)) %>% 
  mutate(age_adult_2=factor(age_adult_2, labels=c("Under 60", "Over 60"))) %>% 
  group_by(age_adult_2,gender) %>% 
  summarize(corr=cor(bmi, age_adult))

## ------------------------------------------------------------------------
lm1 <- lm(bmi~age_adult, data = subset(nids,subset=bmi_valid==1, select=c(bmi,age_adult)))
summary(lm1)

## ------------------------------------------------------------------------
lm2 <- lm(bmi~age_adult, data = subset(nids,subset=age_adult < 40 & bmi_valid==1, select=c(bmi,age_adult)))
lm3 <- lm(bmi~age_adult, data = subset(nids,subset=age_adult >=40 & age_adult <60 & bmi_valid == 1, select=c(bmi,age_adult)))
lm4 <- lm(bmi~age_adult, data = subset(nids,subset=age_adult >= 60 & bmi_valid == 1, select=c(bmi,age_adult)))

## ---- message=FALSE, warning=FALSE---------------------------------------
library(stargazer)
stargazer(lm2,lm3,lm4, type="text", model.numbers = FALSE, column.labels = c("<Under 40","40-60","Over 60"))

## ------------------------------------------------------------------------
lm5 <- lm(bmi~age_adult, data = subset(nids,subset=bmi_valid == 1 & age_adult < 40 & w1_a_b2 == 1, select=c(bmi,age_adult)))
summary(lm5)

## ------------------------------------------------------------------------
lm6 <- lm(bmi~age_adult, data = subset(nids,subset=bmi_valid == 1 & age_adult < 40 & w1_a_b2 == 2, select=c(bmi,age_adult)))
summary(lm6)

## ------------------------------------------------------------------------
q1<-data.frame(subset(nids, subset=hhrestrict==1, select=c(w1_hhsizer,w1_h_expf)))
cor(q1[,c("w1_hhsizer","w1_h_expf")],use="complete.obs")

## ------------------------------------------------------------------------
q2 <- lm(w1_h_expf~w1_hhsizer, data = subset(nids,subset=hhrestrict==1, select=c(w1_hhsizer,w1_h_expf)))
summary(q2)

## ------------------------------------------------------------------------
q3 <- lm(w1_h_expf~w1_hhincome, data = subset(nids,subset=hhrestrict==1, select=c(w1_hhincome,w1_h_expf)))
summary(q3)
print(q3)

## ------------------------------------------------------------------------
bmiage<-subset(nids, subset=(age_adult > 20 & age_adult < 40), select=c(bmi, age_adult, gender))

#Generating a BMI variable giving mean BMI by age and gender to individuals of a common age-gender group 
bmiage<-bmiage%>%
  group_by(age_adult, gender)%>%
  summarise(bmi_age_gen=mean(bmi, na.rm=TRUE))

ggplot(bmiage, aes(x = age_adult, y = bmi_age_gen, group = gender, color = gender)) +
  geom_point() + 
  stat_smooth(method = "lm", se = FALSE) +
  scale_color_manual(values = c("red","blue")) +
  labs(x ="Age in years - adults", y  ="BMI", title = "Comparing mean BMI by age & gender groupings", color = "Gender") +
  theme_classic()

## ------------------------------------------------------------------------
anova(lm0)

## ---- echo=FALSE, out.width = "80%"--------------------------------------
knitr::include_graphics("./images/reg0.png")

## ------------------------------------------------------------------------
summary(lm0)

## ------------------------------------------------------------------------
print(sessionInfo(), locale = FALSE)

