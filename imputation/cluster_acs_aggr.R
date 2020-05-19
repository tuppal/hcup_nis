###Use cluster to generate 5-YR ESTIMATES by ZIP (could use period covered) IN ORDER TO CAPTURE MORE COUNTIES

#acs data to be allocated, using 5 year 
acs_tobeall<-readRDS(paste0(acs_5yr_path, acs_5yr_obj[1]))

acs_tobeall<-acs_tobeall %>%
  mutate(PERWT=PERWT/5)
#summary(acs_tobeall)
#apply NAs here?
#from Missourci Census Data Center: http://mcdc.missouri.edu/help/data-allocation/
acs_puma<-read_csv(paste0(resource_path, "/imputation/acs_zip/ZIP_PUMA.csv"))
colnames(acs_puma)<-c("STATE", "PUMA_s", "ZIP", "STAB", "ZIPNAME", "PUMA", "POP10", "AFACT")
acs_puma=acs_puma[-1,]
acs_puma %>%
  mutate(match_check=1)

#add STATEFIP code to ACS PUMA and fix width of values to allow for matching with equicalency file
acs_tobeall$PUMA=formatC(acs_tobeall$PUMA, width = 5, format = "d", flag = "0")
acs_tobeall$STATEFIP=formatC(acs_tobeall$STATEFIP, width = 2, format = "d", flag = "0")
acs_tobeall$PUMA1<-paste0(acs_tobeall$STATEFIP, acs_tobeall$PUMA)

#clean variables 
#create list of states in our datasets
states<-c("ARIZONA", "FLORIDA", "IOWA", "KENTUCKY", "MARYLAND", "NORTH CAROLINA", 
          "NEBRASKA", "NEW JERSEY", "NEW YORK", "UTAH", "VERMONT")
acs_tobeall<-acs_tobeall%>%
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
           EDUCD %in% c(65:90, 100:116) ~ "Some College or College Grad"),
         
         #create indicator for whether states are within available data
         in_data= ifelse(state_name %in% c(states), 1, 0),
         
         #only keep PUMAs for states that we are interested in
         PUMA = ifelse(in_data==1, PUMA1, NA)
  )

#reduce size of dataset for local testing, delete when processing on cluster
acs_tobeall<-acs_tobeall[sample(nrow(acs_tobeall), nrow(acs_tobeall)/4), ]

#test to make sure all of our PUMA are in acs_puma file from MCDC
count(acs_tobeall$in_data)
count(acs_tobeall$YEAR)

chck<-subset(acs_tobeall, in_data==1 & YEAR %in% c(2008,2011,2014))
check_puma<-ifelse(chck$PUMA %in% acs_puma$PUMA, T, F)
stopifnot(sum(chck_puma==F)=0))

#create our allocated dataset, to be aggregated - keep all observations in x, so all missing match will not provide values
acs_tobeaggr<-merge(acs_tobeall, acs_puma, by="PUMA", all.x=T)

#subset for variables to improve processing time
acs_design<-test %>% select(CLUSTER, STRATA, PERWT, RACE_co, EDUCD, state_name, in_data, PUMA, ZIP, AFACT, AGE)

library(survey)
library(srvyr)
#in cluster I believe you would merge the zips into the full file, take the large dataset and push into svy object, then aggregate by zip in syrvr
#with srvyr
acs_srvyr<- acs_design%>%
  as_survey_design(ids = CLUSTER, strata= STRATA, weight=PERWT, nest=T)
detach(package:plyr)

acs_puma_wt<-acs_srvyr %>%
  filter(state_name=="FLORIDA")%>%
  mutate(PUMA=as.numeric(PUMA),
         whi=ifelse(RACE_co=="White, non-hispanic",1,0),
         bla=ifelse(RACE_co=="Black, non-hispanic",1,0),
         hisp=ifelse(RACE_co=="Hispanic, any race",1,0),
         no_hs=ifelse(EDUCD %in% c(10:61), 1,0),
         hs=ifelse(EDUCD %in% c(62:64), 1,0),
         coll=ifelse(EDUCD %in% c(65:90, 100:116), 1,0),
         all=1) %>%
  group_by(PUMA) %>%
  summarise(mean_age=survey_mean(AGE),
            n_white= survey_total(whi),
            n_black= survey_total(bla),
            n_hisp= survey_total(hisp),
            n_nohs= survey_total(no_hs),
            n_hs= survey_total(hs),
            n_coll= survey_total(coll),           
            n = survey_total(all))

acs_puma_wt<-as.data.frame(acs_puma_wt$out)%>%
  select(-ends_with("_se"))
dim(acs_puma_wt)

#merge aggregated weighted puma counts by PUMA, select for variables needed to generate aggregated zip counts
merge_state<-acs_tobeaggr %>%
  dplyr::filter(state_name=="FLORIDA")
acs_puma<-merge(merge_state, acs_puma_wt, by="PUMA", type="left")
acs_puma<-acs_puma %>%
  select(c(PUMA, state_name, mean_age, n_white,n_black, n_hisp, n_nohs, n_hs, n_coll, n, ZIP, AFACT))

#aggregate by zip code
acs_wt_aggr<- acs_puma %>%
  dplyr::filter(state_name=="FLORIDA")%>%
  dplyr::mutate(AFACT=as.numeric(AFACT),
                n=as.numeric(n))%>%
  dplyr::arrange(ZIP)%>%
  dplyr::group_by(ZIP) %>%
  dplyr::summarise(#mean_age=mean(AGE),
    white_afact= sum(n_white*AFACT),
    black_afact= sum(n_black*AFACT),
    hisp_afact= sum(n_hisp*AFACT),
    nohs_afact= sum(n_nohs*AFACT),
    hs_afact= sum(n_hs*AFACT),
    coll_afact= sum(n_coll*AFACT),           
    n = sum(n*AFACT))%>%
  dplyr::mutate(prop_w=white_afact/n,
                prop_b=black_afact/n,
                prop_his=hisp_afact/n,
                prop_nohs=nohs_afact/n,
                prop_hs=hs_afact/n,
                prop_coll=coll_afact/n)

#test mutating then summing
test<-acs_puma %>%
  dplyr::filter(state_name=="FLORIDA")%>%
  dplyr::mutate(AFACT=as.numeric(AFACT),
                n=as.numeric(n))%>%
  dplyr::arrange(ZIP)%>%
  dplyr::mutate(
  white_afact1= (n_white*AFACT),
  black_afact1= (n_black*AFACT),
  hisp_afact1= (n_hisp*AFACT),
  nohs_afact1= (n_nohs*AFACT),
  hs_afact1= (n_hs*AFACT),
  coll_afact1= (n_coll*AFACT),           
  n1 = n*AFACT)%>%
  dplyr::group_by(ZIP) %>%
  dplyr::summarise(#mean_age=mean(AGE),
    white_afact= sum(white_afact1),
    black_afact= sum(black_afact1),
    hisp_afact= sum(hisp_afact1),
    nohs_afact= sum(nohs_afact1),
    hs_afact= sum(hs_afact1),
    coll_afact= sum(coll_afact1),           
    n = sum(n1))%>%
  dplyr::mutate(prop_w=white_afact/n,
                prop_b=black_afact/n,
                prop_his=hisp_afact/n,
                prop_nohs=nohs_afact/n,
                prop_hs=hs_afact/n,
                prop_coll=coll_afact/n)

  
  
getwd()
setwd(paste0(repo, "/imputation"))
dir.create(paste0(repo, "/imputation", "/acs_zip"))
acs_zip_path<-(paste0(repo, "/imputation", "/acs_zip/"))

saveRDS(acs_wt_aggr, paste0(acs_zip_path, "FL", "_2008","_zip.RDS"))
hist(acs_wt_aggr$n)
