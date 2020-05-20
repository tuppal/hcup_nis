#acs download
if (!require("ipumsr")){install.packages('ipumsr')}
library(ipumsr)

acs_path<-paste0(data_path, "acs_obj")

ddi <- read_ipums_ddi(paste0(data_path, "acs/ipums/usa_00005.xml"))
data<-read_ipums_micro(ddi)
count(data$YEAR)

yrs<-c(2008, 2011, 2014, 2016, 2017)

x<-subset(data, YEAR==yrs[1])
saveRDS(x, file=paste0(acs_path, "/", paste0("acs_", yrs[1], ".RDS")))
rm(x)

x<-subset(data, YEAR==yrs[2])
saveRDS(x, file=paste0(acs_path, "/", paste0("acs_", yrs[2], ".RDS")))
rm(x)

x<-subset(data, YEAR==yrs[3])
saveRDS(x, file=paste0(acs_path, "/", paste0("acs_", yrs[3], ".RDS")))
rm(x)

x<-subset(data, YEAR==yrs[4])
saveRDS(x, file=paste0(acs_path, "/", paste0("acs_", yrs[4], ".RDS")))
rm(x)

x<-subset(data, YEAR==yrs[5])
saveRDS(x, file=paste0(acs_path, "/", paste0("acs_", yrs[1], ".RDS")))
rm(x)

#acs_5yr download/setup
acs_5yr_path

ddi <- read_ipums_ddi(paste0(acs_5yr_path, "usa_00005.xml"))
data<-read_ipums_micro(ddi)
data<-subset(data,YEAR %in% c(2008,2009,2010,2011,2012))
saveRDS(data, paste0(acs_5yr_path, "acs_5yr.RDS"))
rm(data)