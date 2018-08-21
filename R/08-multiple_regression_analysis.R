## ------------------------------------------------------------------------
library(foreign)
library(tidyverse)

nids<-read.dta("./data/nids.dta", convert.factors=FALSE)

nids<-nids%>% 
  arrange(hhid, pid)%>%
  group_by(hhid) %>%
  mutate(hhrestrict = 1:n()) %>%
  mutate(hhrestrict = ifelse(hhrestrict==1,1,0))

#Education
nids$educ.new<-nids$w1_best_edu
nids$educ.new[which(nids$w1_best_edu == 25)]<-0
nids$educ.new[which(nids$w1_best_edu <0)]<-NA
nids$educ.new[which(nids$w1_best_edu == 24)]<-NA
nids$educ.new[which(nids$w1_best_edu == 13 | nids$w1_best_edu == 16)]<-10
nids$educ.new[which(nids$w1_best_edu == 14 | nids$w1_best_edu == 17)]<-11
nids$educ.new[which(nids$w1_best_edu == 15)]<-12
nids$educ.new[which(nids$w1_best_edu == 18)]<-13
nids$educ.new[which(nids$w1_best_edu == 18)]<-13
nids$educ.new[which(nids$w1_best_edu == 19)]<-14
nids$educ.new[which(nids$w1_best_edu == 20)]<-15
nids$educ.new[which(nids$w1_best_edu == 21 | nids$w1_best_edu == 22)]<-16
nids$educ.new[which(nids$w1_best_edu == 23)]<-17

#Age
nids$age<-nids$w1_r_best_age_yrs[!is.na(nids$w1_r_best_age_yrs)]

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
nids%>%
  group_by(educ.new)%>%
  summarise(n=n())

## ------------------------------------------------------------------------
nids<-nids %>% 
  mutate(sample1=ifelse(age>=25 & age<=60,1,0))

## ------------------------------------------------------------------------
cor(subset(nids, subset=sample1==1, select=c(w1_fwag, educ.new)), use="complete.obs")

## ------------------------------------------------------------------------
lm <- lm(w1_fwag~educ.new, data = nids %>% filter(sample1==1))
summary(lm)

## ------------------------------------------------------------------------
scatter<-data.frame(subset(nids, subset=sample1==1, select=c(educ.new, w1_fwag)))
scatter<-na.omit(scatter)
 
ggplot(scatter, aes(x = educ.new, y = w1_fwag)) + 
  geom_point() + 
  stat_smooth(method = "lm", se = FALSE, colour = "red") +
  xlab("Recoded education") + 
  ylab("Monthly take home pay") +
  theme_classic()

## ------------------------------------------------------------------------
scatter$yhat<-lm$fitted.values
scatter%>%
  group_by(educ.new)%>%
  mutate(meanwage=mean(w1_fwag))%>%
  gather(key = type,value=value, -educ.new, -w1_fwag)%>% #reshaping the data using tidyr functions
  ggplot(., aes(educ.new,value, color = type)) +
  geom_point() +
  geom_line() +
  scale_color_manual(values = c("blue","red"))+
  theme_classic()

## ------------------------------------------------------------------------
lm2 <- lm(w1_fwag~age+educ.new, data = nids %>% filter(sample1==1))
summary(lm2)

## ---- out.width = "80%", echo=FALSE--------------------------------------
knitr::include_graphics("./images/reg1.png")

## ------------------------------------------------------------------------
dum<-nids %>% 
  filter(sample1==1) %>% 
  select(hhid, pid, hhrestrict, w1_best_race, age, educ.new, w1_fwag, w1_r_b4, gender, race) %>% 
  na.omit()

lmx <- lm(w1_fwag~age+gender, data = dum)
summary(lmx)
dum$prediction<-lmx$fitted.values

ggplot(dum, aes(x = age, y = prediction, color=gender))+
geom_point() + 
xlab("Age in years") + 
  ylab("Fitted values") +
  theme_classic()

## ---- out.width = "80%", echo=FALSE--------------------------------------
knitr::include_graphics("./images/reg2.png")

## ------------------------------------------------------------------------
lmz <- lm(w1_fwag~age*gender, data = dum)
summary(lmz)
dum$prediction<-lmz$fitted.values

ggplot(dum, aes(x = age, y = prediction, color=gender)) +
  geom_point() + 
  xlab("Age in years") + 
  ylab("Fitted values") +
  theme_classic()

## ------------------------------------------------------------------------
lm5 <- lm(w1_fwag~educ.new+age+relevel(race, "White")*gender, data = dum)

## ----message = F, warning = FALSE----------------------------------------
library(stargazer)
#summary(lm5)
stargazer(lm5, type = "text")

## ------------------------------------------------------------------------
nids%>%
  group_by(educ.new)%>%
  summarise(Mean = mean(w1_fwag, na.rm=TRUE), sd=sd(w1_fwag, na.rm=TRUE))

## ---- echo=FALSE---------------------------------------------------------
scatter<-na.omit(data.frame(subset(nids, subset=sample1==1, select=c(educ.new, w1_fwag))))

lm <- lm(w1_fwag~educ.new, data = scatter)

scatter$yhat<-lm$fitted.values
scatter%>%
  group_by(educ.new)%>%
  mutate(meanwage=mean(w1_fwag))%>%
  gather(key = type,value=value, -educ.new, -w1_fwag)%>%
  ggplot(., aes(educ.new,value, color = type)) +
  geom_point() +
  geom_line() +
  scale_color_manual(values=c("blue","red")) +
  xlab("Recoded education") +
  theme_classic()

## ------------------------------------------------------------------------
kernel<-nids %>% 
  filter(sample1==1) %>% 
  select(hhid, w1_fwag, educ.new, sample1, age, race, gender) %>% 
  na.omit()

library(scales)
ggplot(kernel, aes(x = w1_fwag)) +
  geom_density() +
  scale_y_continuous(breaks=seq(0,0.0003,0.0001), labels = comma) +
  scale_x_continuous(breaks=seq(0,100000,20000), labels = comma) +
  labs(x="Monthly take home pay from main job including BRACKETS") +
  theme_classic()

## ------------------------------------------------------------------------
kernel$lnwage<-log(kernel$w1_fwag)
ggplot(kernel, aes(x = lnwage)) +
  geom_density() +
  theme_classic()

## ------------------------------------------------------------------------
lmy <- lm(lnwage~educ.new, data = subset(kernel, subset=sample1 ==1))
summary(lmy)

## ------------------------------------------------------------------------
kernel$lnwage<-log(kernel$w1_fwag)

lmy <- lm(lnwage~educ.new, data = subset(kernel, subset=sample1==1))
summary(lmy)

kernel$lmyhat<-lmy$fitted.values   #other predict options

kernel%>%
  filter(sample1==1)%>%
  group_by(educ.new)%>%
  mutate(meanlnwage=mean(lnwage), lmyhat=lmyhat)%>%
  select(educ.new, lmyhat, meanlnwage)%>%
  gather(key = type,value=value, -educ.new)%>%
  ggplot(., aes(educ.new,value, color = type)) +
  geom_point() +
  geom_line() +
  scale_color_manual(values=c("red","blue")) +
  xlab("Recoded education") +
  theme_classic()

## ------------------------------------------------------------------------
lmy <- lm(lnwage~educ.new+age+relevel(race, "White")*gender, data = subset(kernel, subset=sample1==1))
#summary(lmy)
stargazer(lmy, type="text")

## ------------------------------------------------------------------------
kernel%>%
  group_by(age)%>%
  summarise(mean.wage.age=mean(w1_fwag, na.rm=TRUE))%>%
  ggplot(., aes(x = age, y = mean.wage.age)) + 
  geom_point() + 
  xlab("Age in years") + 
  ylab("meanwage_age") +
  theme_classic()

## ------------------------------------------------------------------------
kernel<-kernel%>%
  mutate(age2 = age*age)
  
lmy <- lm(lnwage~educ.new+age+age2+relevel(race, "White")+gender, data = kernel)
#summary(lmy)
stargazer(lmy, type="text")

## ------------------------------------------------------------------------
lmz <- lm(w1_fwag~age, data = kernel)
kernel$lmzhat<-lmz$fitted.values

kernel%>%
  group_by(age)%>%
  mutate(mean.wage.age=mean(w1_fwag, na.rm=TRUE))%>%
  select(age, mean.wage.age, lmzhat)%>%
  gather(key = type,value=value, -age)%>%
  ggplot(., aes(age,value, color = type)) +
  geom_point() + 
  scale_color_manual(values=c("red","blue")) +
  xlab("Age in years") +
  theme_classic()

## ------------------------------------------------------------------------
kernel<-kernel%>%
  mutate(age2 = age*age)

lmz <- lm(w1_fwag~age + age2, data = kernel)
kernel$lmzhat<-lmz$fitted.values

kernel%>%
  group_by(age)%>%
  mutate(mean.wage.age=mean(w1_fwag, na.rm=TRUE))%>%
  select(age, mean.wage.age, lmzhat)%>%
  gather(key = type,value=value, -age)%>%
  ggplot(., aes(age,value, color = type)) +
  geom_point() +
  scale_color_manual(values=c("red","blue")) +
  xlab("Age in years") +
  theme_classic()

## ------------------------------------------------------------------------
print(sessionInfo(), locale = FALSE)

