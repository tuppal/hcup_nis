#getting zip demographics from census
acs_racetable_path<-paste0(repo, "/imputation/acs_tablezip/race")
acs_racetableobj<-dir(acs_racetable_path)
var_names<-read.csv(paste0(acs_racetable_path, "/",acs_racetableobj[grep("metadata", acs_racetableobj)]))
#remove margin of error
var_names<-var_names%>%
  mutate(GEO_ID=as.character(var_names$GEO_ID),
  margin=grepl("DP05_\\d{4}M", var_names$GEO_ID),
  pctmargin=grepl("DP05_\\d{4}PM", var_names$GEO_ID),
  marg=ifelse(margin==T|pctmargin==T, T,F))%>%
  subset(., marg==F)
#select for estimates you are interested in 
var_names<-var_names%>%
  #remove sex and age variables
  mutate(sexandage=grepl("SEX AND AGE", var_names$id),
         total_pop=grepl("Estimate!!RACE!!Total population", var_names$id),
         racew=grepl("DP05_0059", var_names$GEO_ID),
         raceb=grepl("DP05_0060", var_names$GEO_ID),
         hisp=grepl("DP05_0066", var_names$GEO_ID),
         nohisp=grepl("DP05_0071", var_names$GEO_ID))%>%
  subset(., sexandage==F) %>%
  subset(., total_pop==T | racew==T | raceb == T | hisp==T | nohisp==T)%>%
  select(-(c(total_pop, racew, raceb, hisp, nohisp, margin, marg, sexandage, pctmargin, X)))

acs_racetableobj
#subset census table for variables of interest
acs_zip<-read.csv(paste0(acs_racetable_path, "/",acs_racetableobj[grep("data_with_overlays", acs_racetableobj)]))
acs_zip<-as.data.table(acs_zip)
acs_zip<- acs_zip %>%
  select(c("NAME", var_names$GEO_ID))%>%
  separate(., "NAME", c("drop", "ZCTA"), " ") %>%
  select(-c("drop"))
colnames(acs_zip)=c("ZCTA", "tot_pop", "n_white", "%_white", "n_black", "%_black", "n_hisp", "%_hisp", "n_nohisp", "%_nohisp")
dem_acs_zip=acs_zip[-1,]

#repeat for education
#getting zip demographics from census
acs_eductable_path<-paste0(repo, "/imputation/acs_tablezip/education")
acs_eductableobj<-dir(acs_eductable_path)
acs_eductableobj
var_names<-read.csv(paste0(acs_eductable_path, "/",acs_eductableobj[grep("metadata", acs_eductableobj)]))
#remove margin of error
var_names<-var_names%>%
  mutate(GEO_ID=as.character(var_names$GEO_ID),
         margin=grepl("DP02_\\d{4}M", var_names$GEO_ID),
         pctmargin=grepl("DP02_\\d{4}PM", var_names$GEO_ID),
         marg=ifelse(margin==T|pctmargin==T, T,F))%>%
  subset(., marg==F)
#select for estimates you are interested in 
var_names<-var_names %>%
  mutate(hs=grepl("DP02_0066PE", var_names$GEO_ID),
         coll=grepl("DP02_0067PE", var_names$GEO_ID))
var_names<-subset(var_names, hs==T|coll==T)
        
var_names<-var_names %>%
  select(-(c(hs, coll, X, margin, marg, pctmargin)))

acs_eductableobj
#subset census table for variables of interest
acs_zip<-read.csv(paste0(acs_eductable_path, "/",acs_eductableobj[grep("data_with_overlays", acs_eductableobj)]))
acs_zip<- acs_zip %>%
  select(c("NAME", var_names$GEO_ID))%>%
  separate(., "NAME", c("drop", "ZCTA"), " ") %>%
  select(-c("drop"))
colnames(acs_zip)=c("ZCTA", "%_hs", "%_bach")
edu_acs_zip=acs_zip[-1,]


#now, finally with income data
acs_inctable_path<-paste0(repo, "/imputation/acs_tablezip/income")
acs_inctableobj<-dir(acs_inctable_path)
acs_inctableobj
var_names<-read.csv(paste0(acs_inctable_path, "/",acs_inctableobj[grep("metadata", acs_inctableobj)]))
#remove margin of error
var_names<-var_names%>%
  mutate(GEO_ID=as.character(var_names$GEO_ID),
         margin=grepl("DP03_\\d{4}M", var_names$GEO_ID),
         pctmargin=grepl("DP03_\\d{4}PM", var_names$GEO_ID),
         marg=ifelse(margin==T|pctmargin==T, T,F))%>%
  subset(., marg==F)
#select for estimates you are interested in 
var_names<-var_names %>%
  mutate(medinc=grepl("DP03_0062E", var_names$GEO_ID))
var_names<-subset(var_names, medinc==T)

var_names<-var_names %>%
  select(-(c(hs, coll, X, margin, marg, pctmargin)))

acs_inctableobj
#subset census table for variables of interest
acs_zip<-read.csv(paste0(acs_inctable_path, "/",acs_inctableobj[grep("data_with_overlays", acs_inctableobj)]))
acs_zip<- acs_zip %>%
  select(c("NAME", var_names$GEO_ID))%>%
  separate(., "NAME", c("drop", "ZCTA"), " ") %>%
  select(-c("drop"))
colnames(acs_zip)=c("ZCTA", "medinc")
inc_acs_zip=acs_zip[-1,]

#merge by zip
merge1<-merge(dem_acs_zip, edu_acs_zip, by="ZCTA")
zip_data<-merge(merge1, inc_acs_zip, by="ZCTA")
rm(merge1)
summary(zip_data)

#drop n and population size, change missing to NA
zip_data$`%_white`= ifelse(zip_data$`%_white`== "-", NA, zip_data$`%_white`)
zip_data$`%_white`= ifelse(zip_data$`%_white`== "-", NA, zip_data$`%_white`)
zip_data$`%_black`= ifelse(zip_data$`%_black`== "-", NA, zip_data$`%_black`)
zip_data$`%_hisp`= ifelse(zip_data$`%_hisp`== "-", NA, zip_data$`%_hisp`)
zip_data$`%_nohisp`= ifelse(zip_data$`%_nohisp`== "-", NA, zip_data$`%_nohisp`)
zip_data$`%_hs`= ifelse(zip_data$`%_hs` %in% c("-", "null"), NA, zip_data$`%_hs`)
zip_data$`%_bach`= ifelse(zip_data$`%_bach`%in% c("-", "null"), NA, zip_data$`%_bach`)
zip_data$medinc= ifelse(zip_data$medinc== "-", NA, zip_data$medinc)

#count zips with missing data
count(is.na(zip_data))
#32067 zip codes have all data, and 369 (1.11%) have no data at all
514+130+40+369
#1053 zip codes, or about 3.2% have at least one missing data; only 1.11% of zips missing race data
saveRDS(zip_data, paste0(repo, "/imputation/acs_tablezip/zip_demtable.RDS"))
rm(zip_data)
acs_table<-readRDS(paste0(repo, "/imputation/acs_tablezip/zip_demtable.RDS"))