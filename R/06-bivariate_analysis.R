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
  mutate(weight = ifelse (w1_a_n2_1 >= 0 & w1_a_best_age_yrs >= 20, w1_a_n2_1, NA)) 

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
summary(nids$w1_fwag)

## ------------------------------------------------------------------------
nids%>%
  arrange(hhid)%>%
  select(hhid, pid, w1_h_expf)%>%
  head(20)

## ------------------------------------------------------------------------
nids%>%
  arrange(hhid)%>%
  select(hhid, pid, w1_h_expf, w1_hhsizer)%>%
  head(20)

## ------------------------------------------------------------------------
nids%>%
  arrange(hhid)%>%
  select(hhid, pid, w1_h_expf, w1_hhincome)%>%
  head(20)

## ------------------------------------------------------------------------
nids%>%
  group_by(w1_r_b4)%>%
  summarise(n=n())

## ------------------------------------------------------------------------
nids%>%
  group_by(w1_a_j1)%>%
  summarise(n=n())

## ---- echo=FALSE,out.height="80%" , phealth, fig.cap="Labels for Perceived Health Status"----
knitr::include_graphics("./images/phealth.png")

## ------------------------------------------------------------------------
table(nids$w1_a_j1)

## ----message = F, warning = F--------------------------------------------
nids$phealth<-ifelse(nids$w1_a_j1>0, nids$w1_a_j1, NA)
nids$phealth<-factor(nids$phealth, levels=1:5, labels=c("Excellent", "Very Good", "Good", "Fair", "Poor"))
table(nids$phealth)

## ------------------------------------------------------------------------
library(gmodels)
CrossTable(nids$phealth, nids$gender)

## ---- echo=FALSE, best_edu, fig.cap="Education codes"--------------------
knitr::include_graphics("./images/best_edu.png")

## ------------------------------------------------------------------------
nids$uni<-1
nids$uni[nids$w1_r_b7 == 20 | nids$w1_r_b7 == 21 | nids$w1_r_b7 == 22 | nids$w1_r_b7 == 23]<-2
nids$uni[nids$w1_r_b7<0 | is.na(nids$w1_r_b7)]<-NA
nids$uni<-factor(nids$uni, levels=1:2, labels= c("no bachelor degree","bachelor degree"))
table(nids$uni)

## ------------------------------------------------------------------------
nids %>% 
  filter(w1_fwag >0 & !is.na(w1_fwag)) %>% 
  group_by(uni) %>% 
  summarise(mean_inc=mean(w1_fwag, na.rm=TRUE),
            sd_inc=sd(w1_fwag, na.rm=TRUE),
            N=n())

## ------------------------------------------------------------------------
table(nids$class)

## ------------------------------------------------------------------------
CrossTable(nids$uni, nids$class)

## ------------------------------------------------------------------------
nids<-nids%>%
  group_by(hhid)%>%
  mutate(maxage = max(w1_r_best_age_yrs, na.rm = T))

## ------------------------------------------------------------------------
head(nids[,c("hhid", "w1_r_best_age_yrs", "maxage")], n = 25L)

## ------------------------------------------------------------------------
nids_max_age<-nids%>%
  filter(hhrestrict==1)

#CrossTable(nids_max_age$maxage, nids_max_age$w1_hhgeo, expected = FALSE, prop.r = FALSE, prop.c = FALSE, prop.t = FALSE,prop.chisq = FALSE)

## ------------------------------------------------------------------------
nids_max_age$w1_hhgeo1<-nids_max_age$w1_hhgeo
levels(nids_max_age$w1_hhgeo1)<-c('RF','TAA','UF','UI')
CrossTable(nids_max_age$maxage, nids_max_age$w1_hhgeo1, expected = FALSE, prop.r = FALSE, prop.c = FALSE, prop.t = FALSE,prop.chisq = FALSE)

## ------------------------------------------------------------------------
nids_max_age80<-nids_max_age%>%
  filter(maxage>80)
  
CrossTable(nids_max_age80$maxage, nids_max_age80$w1_hhgeo1, expected = FALSE, prop.r = FALSE, prop.c = FALSE, prop.t = FALSE,prop.chisq = FALSE)

## ------------------------------------------------------------------------
tothh<-nids_max_age %>% 
  group_by(w1_hhgeo) %>% 
  summarise(hh=n())
tothh

## ------------------------------------------------------------------------
tothh80<-nids_max_age80 %>% 
  group_by(w1_hhgeo) %>% 
  summarise(hh80=n())
tothh80

## ------------------------------------------------------------------------
hh<-cbind(tothh80,tothh[,2])
hh

hh %>% 
  mutate(percent=round(hh80/hh*100,2))

## ------------------------------------------------------------------------
nids<-nids%>%
  mutate(age1 = ifelse(age>0, age, NA))%>%
  group_by(hhid)%>%
  mutate(avgage = mean(age1, na.rm=T))

## ------------------------------------------------------------------------
nids<-nids%>%
  mutate(hrace = if_else(w1_r_b3==1, w1_best_race,NA_integer_)) %>% 
  group_by(hhid)%>%
  mutate(hhrace = max(hrace, na.rm=TRUE))

table(nids$hhrace)

## ------------------------------------------------------------------------
nids<-nids%>%
  mutate(hhrace = factor(hhrace, levels = 1:4, labels=c("African","Coloured","Asian_Indian","White")))

## ------------------------------------------------------------------------
#nids_max_hhrace_age<-nids%>%
#  filter(hhrestrict==1)%>%
#  select(hhrace, avgage)
  
#CrossTable(nids_max_hhrace_age$avgage, nids_max_hhrace_age$hhrace, expected = FALSE, prop.r = FALSE, prop.c = FALSE, prop.t = FALSE,prop.chisq = FALSE)

## ------------------------------------------------------------------------
nids%>%
  group_by(hhrace)%>%
  summarise(Mini = min(avgage, na.rm=TRUE),
            Mean = mean(avgage, na.rm=TRUE),
            Median = median(avgage, na.rm=TRUE),
            Max = max(avgage, na.rm=TRUE),
            N = n())

## ------------------------------------------------------------------------
nids%>%
  group_by(hhrace)%>%
  summarise(Mini = min(avgage, na.rm=T),
            Mean = mean(avgage, na.rm=T),
            Median = median(avgage, na.rm=T),
            Max = max(avgage, na.rm=T),
            Std.dev = sd(avgage, na.rm=T),
            N = n())

## ------------------------------------------------------------------------
nids$race.gender<-paste(nids$race,nids$gender, sep = "-")

## ------------------------------------------------------------------------
CrossTable(nids$race, nids$gender, expected = FALSE, prop.r = FALSE, prop.c = FALSE, prop.t = FALSE,prop.chisq = FALSE)

## ------------------------------------------------------------------------
mytable <- xtabs(~race+gender, data=nids)
ftable(mytable)

## ------------------------------------------------------------------------
nids%>%
  group_by(race.gender)%>%
  summarise(n=n())

## ------------------------------------------------------------------------
CrossTable(nids$w1_a_m5, nids$race.gender, expected = FALSE, prop.r = FALSE, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE)

# Other options - (table(A,B))
# mycrosstab<-table(nids$w1_a_m5, nids$race.gender)
# mycrosstab #print table
# 
# margin.table(mycrosstab, 1) # A frequencies (summed over B) 
# margin.table(mycrosstab, 2) # B frequencies (summed over A)
# 
# round(prop.table(mycrosstab),3) # cell percentages
# round(prop.table(mycrosstab, 1),3) # row percentages 
# round(prop.table(mycrosstab, 2),3) # column percentages

## ------------------------------------------------------------------------
nids_temp<-nids %>% 
  filter(w1_a_m5>0 & !is.na(race))
CrossTable(nids_temp$w1_a_m5, nids_temp$race.gender, expected = FALSE,prop.r = FALSE, prop.c = TRUE, prop.t = FALSE,prop.chisq = FALSE)

## ------------------------------------------------------------------------
nids<-nids%>%
  group_by(hhid)%>%
  mutate(tot_fwag=sum(w1_fwag, na.rm=TRUE))

## ------------------------------------------------------------------------
#subset to match extract from the Stata course
head(subset(nids, subset=hhid>=101066, select=c(hhid,tot_fwag, w1_hhwage)), n=20L)

## ------------------------------------------------------------------------
nids$dl<-nids$w1_a_h35
nids$dl[nids$w1_a_h35<0]<-NA

nids$mv<-nids$w1_a_g4
nids$mv[nids$w1_a_g4<0]<-NA

nids$mv<-factor(nids$mv, levels = 1:2, labels = c("Yes","No"))
nids$dl<-factor(nids$dl, levels = 1:2, labels = c("Yes","No"))

CrossTable(nids$dl, nids$mv, digits=3, max.width = 5, expected=FALSE, prop.r=TRUE, prop.c=TRUE,prop.t=FALSE, prop.chisq=TRUE, chisq = TRUE, missing.include=FALSE,format=c("SAS","SPSS"))

## ------------------------------------------------------------------------
table(nids$w1_a_m6)

## ------------------------------------------------------------------------
nids$lh<-nids$w1_a_m6
nids$lh[nids$w1_a_m6<0 | nids$w1_a_m6>3]<-NA

nids$es<-nids$w1_a_e1
nids$es[nids$w1_a_e1<0]<-NA

nids$lh<-factor(nids$lh, levels = 1:3, labels = c("Happier","The same", "Less happy"))
nids$es<-factor(nids$es, levels = 1:2, labels = c("Yes","No"))

CrossTable(nids$lh, nids$es, digits=4, max.width = 5, expected=FALSE, prop.r=TRUE, prop.c=TRUE, prop.t=TRUE, prop.chisq=TRUE, chisq = TRUE, missing.include=FALSE,format=c("SAS"))

## ------------------------------------------------------------------------
nids<-nids%>%
  mutate(w1_hhprov = factor(w1_hhprov, levels=1:9, labels = c("Western Cape","Eastern Cape","Northern Cape","Free State","KwaZulu-Natal","North West","Gauteng","Mpumalanga","Limpopo")))

CrossTable(nids$w1_hhprov, nids$lh, digits=4, max.width = 6, expected=FALSE, prop.r=TRUE, prop.c=FALSE, prop.t=FALSE, prop.chisq=FALSE, chisq = FALSE, missing.include=FALSE,format=c("SAS","SPSS"))

## ------------------------------------------------------------------------
CrossTable(nids$w1_hhprov, nids$lh)    #Will give you all stats

## ------------------------------------------------------------------------
nids%>%
  group_by(lh)%>%
  summarise(mean = mean(w1_hhincome, na.rm=T), sd = sd(w1_hhincome, na.rm=T), n=n()) %>% 
  na.omit()

## ------------------------------------------------------------------------
happiness<-nids%>%
  rename(level_happiness=lh) %>% 
  group_by(level_happiness, province)%>%
  summarise(mean = mean(w1_hhincome, na.rm=T), sd = sd(w1_hhincome, na.rm=T), n=n()) %>% 
  na.omit()

## ------------------------------------------------------------------------
knitr::kable(
  head(happiness, 27), booktabs = TRUE,
  caption = 'Summary level of happiness by province and household income'
)

## ------------------------------------------------------------------------
CrossTable(nids$lh, nids$w1_hhgeo, digits=4, max.width = 5, expected=FALSE, prop.c=TRUE, prop.r=FALSE, prop.t=FALSE, prop.chisq=FALSE, chisq = TRUE, missing.include=FALSE)    #Will give you all stats

## ------------------------------------------------------------------------
nids$child.dummy<-0
nids$child.dummy[nids$w1_quest_typ == 2]<-1

## ------------------------------------------------------------------------
nids1<-nids%>%
  select(hhid, pid, w1_hhsizer, w1_hhincome, child.dummy, bmi, gender,bmi_valid)%>%
  mutate(hh.children=sum(child.dummy, na.rm=TRUE))%>%
  mutate(hh.adults = w1_hhsizer- hh.children)

## ------------------------------------------------------------------------
head(nids1)

## ------------------------------------------------------------------------
nids1<-nids1%>%
  mutate(hhsize.adultequiv=hh.adults + 0.5*hh.children)

## ------------------------------------------------------------------------
nids1<-nids1%>%
  mutate(hh.pcinc=w1_hhincome/hhsize.adultequiv)

## ------------------------------------------------------------------------
ggplot(nids1, aes(hh.pcinc, bmi)) +
  geom_point() +
  labs(x="House per capita income",y="Respondent's Body Mass Index", title="Scatterplot of BMI and pc hh_income") +
  theme_classic()

## ------------------------------------------------------------------------
ggplot(nids1 %>% filter(bmi_valid == 1 & hh.pcinc < 13000), aes(hh.pcinc, bmi)) +
  geom_point() + 
  stat_smooth(method = "lm", size=1, formula = y ~ x, se = FALSE) +
  theme_classic()

## ------------------------------------------------------------------------
ggplot(nids1 %>% filter(bmi_valid == 1 & hh.pcinc < 13000 & !is.na(gender)), aes(hh.pcinc, bmi, color = gender)) +
  geom_point() + 
  stat_smooth(method = "lm", size=1, formula = y ~ x, se = FALSE) +
  scale_color_manual(values = c("blue", "red")) +
  ggtitle("Comparing BMI and income (by gender)") +
  ylab("BMI") +
  theme_classic()

## ------------------------------------------------------------------------
nids1$inc.cat<-NA
nids1$inc.cat[which(nids1$hh.pcinc<2500)]<-1
nids1$inc.cat[which(nids1$hh.pcinc>=2500 & nids1$hh.pcinc<5000)]<-2
nids1$inc.cat[which(nids1$hh.pcinc>=5000 & nids1$hh.pcinc<10000)]<-3
nids1$inc.cat[which(nids1$hh.pcinc>=10000 & nids1$hh.pcinc <=max(nids1$hh.pcinc))]<-4
 
nids1$inc.cat<-factor(nids1$inc.cat,
                       levels = 1:4,
                       labels = c("<2500", "250-4999", "5000-9999", "10000+"))

## ------------------------------------------------------------------------
nids1%>%
  group_by(inc.cat, gender)%>%
  summarise(mbmi = mean(bmi, na.rm=T)) %>% 
  arrange(gender,inc.cat)

## ----message=F, warning=F------------------------------------------------
library(mgcv)
nids1%>%
  filter(bmi_valid == 1 & hh.pcinc < 13000 & gender=="Female")%>%
  ggplot(., aes(x = hh.pcinc, y = bmi)) +
  geom_point() +
  stat_smooth(method = "lm", formula = y ~ x, se = FALSE, colour = "blue", aes(colour = "linear")) +
  stat_smooth(method = "gam", formula= y ~ s(x, k = 3), size = 1, se = FALSE, colour = "red", aes(colour = "polynomial")) +
  ggtitle("Comparing BMI and income(for women)") +
  theme_classic()

## ------------------------------------------------------------------------
print(sessionInfo(), locale = FALSE)

