#imp_test
x<-readRDS(paste0(acs_path, "/", acs_obj[1]))
#no nas? check coding of variables in ddi
acs_zip<-read_xlsx(paste0(resource_path, "/imputation/acs_zip/acs_zip.xlsx"))
acs_puma<-read_csv(paste0(resource_path, "/imputation/acs_zip/ZIP_PUMA.csv"))
acs_tract<-read_xlsx(paste0(resource_path, "/imputation/acs_zip/ZIP_TRACT.xlsx"))
colnames(x)

colnames(acs_puma)<-c("STATE", "PUMA_s", "ZIP", "STAB", "ZIPNAME", "PUMA", "POP10", "AFACT")
acs_puma=acs_puma[-1,]
acs_puma

x$puma<-X$PUMA
x$PUMA=formatC(x$PUMA, width = 5, format = "d", flag = "0")
x$STATEFIP=formatC(x$STATEFIP, width = 2, format = "d", flag = "0")
x$PUMA<-paste0(x$STATEFIP, x$PUMA)
#

x<-x%>%
  mutate(state_name = factor(STATEICP, levels = 
                               c(1, 2, 3, 4, 5, 6, 11, 12, 13, 14, 21, 22, 23, 24, 25, 31, 32, 33, 34, 35, 36, 37, 40,
                                 41, 42, 43, 44, 45, 46, 47, 48, 49, 51, 52, 53, 54, 56, 61, 62, 63, 64, 65, 66, 67, 
                                 68, 71, 72, 73, 81, 82, 83, 96, 97, 98, 99),
                             labels = c("CONNETICUT", "MAINE", "MASSACHUSETTS", "NEW HAMPSHIRE", "RHODE ISLAND", 
                                        "VERMONT", "DELAWARE", "NEW JERSEY", "NEW YORK", "PENNSYLVANIA", "ILLINOIS", 
                                        "INDIANA", "MICHIGAN", "OHIO", "WISCONSIN", "IOWA", "KANSAS", "MINNESOTA", 
                                        "MISSOURI", "NEBRASKA", "NORTH DAKOTA", "SOUTH DAKOTA", "VIRGINIA", "ALABAMA",
                                        "ARKANSAS", "FLORIDA", "GEORGIA", "LOUISIANA", "MISSISSIPPI", "NORTH CAROLINA",
                                        "SOUTH CAROLINA", "TEXAS", "KENTUCKY", "MARYLAND", "OKLAHOMA", "TENNESSEE", 
                                        "WEST VIRGINA", "ARIZONA", "COLORADO", "IDAHO", "MONTANA", "NEVADA", 
                                        "NEW MEXICO", "UTAH", "WYOMING", "CALIFORNIA", "OREGON", "WASHINGTON",
                                        "ALASKA", "HAWAII", "PUERTO RICO", "STATE GROUPINGS", "MIL. RSERVATIONS", 
                                        "D.C.", "NOT IDENTIFIED")),
         HISP_c=factor(HISPAN,
                       levels=
                         c(0, 1, 2, 3, 4, 9),
                       labels= c("Not Hispanic", "Mexican", "Puerto Rican", "Cuban", "Other", "Not Reported")),
         
         HISP=ifelse(HISPAN %in% c(0,9), 0, ifelse(HISPAN %in% c(1:4), 1, NA)),
         
         RACE_co=case_when(
           HISP==1 ~ "Hispanic, any race", 
           RACE==1 & HISP==0 ~ "White, non-hispanic", 
           RACE==2 & HISP==0 ~ "Black, non-hispanic", 
           RACE %in% c(3:9) ~ "Other"),
         
         EDU=case_when(
           EDUCD %in% c(10:61) ~ "Did not graduate High School",
           EDUCD %in% c(62:64) ~ "High School graduate",
           EDUCD %in% c(65:90, 100:116) ~ "Some College or College Grad"))

prop_white<-function(x){
  var<-count(x$RACE_co=="White, non-hispanic")
  var_t<-var[2,]
  count<-sum(var$freq)
  var_t[,2]/count
}
x$propw=prop_white(x)
x$propw

x<-x[sample(nrow(x), nrow(x)/4), ]
chck<-merge(x, acs_puma, by="PUMA")
acs_puma$PUMA
x$PUMA

detach(package:plyr)
test<-chck %>%
  filter(state_name=="FLORIDA")%>%
  mutate(ZIP=as.numeric(ZIP),
         whi=ifelse(RACE_co=="White, non-hispanic",1,0),
         bla=ifelse(RACE_co=="Black, non-hispanic",1,0),
         hisp=ifelse(RACE_co=="Hispanic, any race",1,0),
         no_hs=ifelse(EDU=="Did not graduate High School", 1,0),
         hs=ifelse(EDU=="High School graduate", 1,0),
         coll=ifelse(EDU=="Some College or College Grad", 1,0)) %>%
  group_by(chck$ZIP) %>%
  summarise(mean_age=mean(AGE),
            n_white= sum(whi),
            n_black= sum(bla),
            n_hisp= sum(hisp),
            n_nohs= sum(no_hs),
            n_hs= sum(hs),
            n_coll= sum(coll),           
            n = n()) %>%
  mutate(prop_w=n_white/n,
         prop_b=n_black/n,
         prop_his=n_hisp/n,
         prop_nohs=n_nohs/n,
         prop_hs=n_hs/n,
         prop_coll=n_coll/n,
         med_inc=median(INCWAGE))

chck$AFACT<-as.numeric(chck$AFACT)
test<-chck %>%
  filter(state_name=="FLORIDA")%>%
  mutate(ZIP=as.numeric(ZIP),
         whi=ifelse(RACE_co=="White, non-hispanic",1,0),
         bla=ifelse(RACE_co=="Black, non-hispanic",1,0),
         hisp=ifelse(RACE_co=="Hispanic, any race",1,0),
         no_hs=ifelse(EDU=="Did not graduate High School", 1,0),
         hs=ifelse(EDU=="High School graduate", 1,0),
         coll=ifelse(EDU=="Some College or College Grad", 1,0)) %>%
  group_by(chck$ZIP) %>%
  summarise(mean_age=mean(AGE),
            n_white= sum(whi*AFACT),
            n_black= sum(bla*AFACT),
            n_hisp= sum(hisp*AFACT),
            n_nohs= sum(no_hs*AFACT),
            n_hs= sum(hs*AFACT),
            n_coll= sum(coll*AFACT),           
            n = n())%>%
  mutate(prop_w=n_white/n,
         prop_b=n_black/n,
         prop_his=n_hisp/n,
         prop_nohs=n_nohs/n,
         prop_hs=n_hs/n,
         prop_coll=n_coll/n,
         med_inc=median(chck$INCWAGE))


test2<-chck %>%
  filter(state_name=="FLORIDA")%>%
  mutate(ZIP=as.numeric(ZIP),
         whi=ifelse(RACE_co=="White, non-hispanic",1,0)) %>%
  group_by(ZIP, RACE_co) %>%
  tally()


x<-chck %>%
  group_by(ZIP) %>%
  summarise(prop_white=,
            prop_black=,
            prop_hispanic=,
            prop_hs=
              mean_age=mean(AGE),
  )
