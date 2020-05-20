#acs_5yr download/setup
if (!require("ipumsr")){install.packages('ipumsr')}
library(ipumsr)

acs_5yr_path

ddi <- read_ipums_ddi(paste0(acs_5yr_path, "usa_00005.xml"))
data<-read_ipums_micro(ddi)


saveRDS(data, paste0(acs_5yr_path, "acs_5yr.RDS"))