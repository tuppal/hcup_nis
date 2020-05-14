#prep acs 
x<-readRDS(paste0(acs_path, "/", acs_obj[1]))
#no nas? check coding of variables in ddi
acs_zip<-read_xlsx(paste0(resource_path, "/imputation/acs_zip/acs_zip.xlsx"))
acs_puma<-read_csv(paste0(resource_path, "imputation/acs_zip/ZIP_PUMA.csv"))
acs_tract<-read_xlsx(paste0(resource_path, "/imputation/acs_zip/ZIP_TRACT.xlsx"))
colnames(x)

colnames(acs_puma)<-c("STATE", "PUMA_s", "ZIP", "STAB", "ZIPNAME", "PUMA", "POP10", "AFACT")
acs_puma=acs_puma[-1,]
acs_puma

x$puma<-X$PUMA
x$PUMA=formatC(x$PUMA, width = 5, format = "d", flag = "0")
x$STATEFIP=formatC(x$STATEFIP, width = 2, format = "d", flag = "0")
x$PUMA<-paste0(x$STATEFIP, x$PUMA)
chck<-merge(x, acs_puma, by="PUMA")
gc()
x

count(x$COUNTYFIP)

#hcup datasets
x<-readRDS("C:/Users/teg83/Documents/GitHub/hcup_nis/data/hcup_diab/NEDS_diab_obj/neds_2016_diab.RDS")
dim(x)

nrow(x)
nrow(x$variables)
ncol(x$variables)
colnames(x$variables)
install.paka

sid_path
data_path
install.packages("mi")
library(mi)
install.packages("VIM")
library(VIM)
x<-readRDS("C:/Users/teg83/Documents/GitHub/hcup_nis/data/hcup_diab/SID_diab_obj/vt_sidc_2014_diab.RDS")
vars<-c("PAY1", "RACE", "PL_NCHS", "FEMALE", "AGE")

colnames(x[vars])
summary(x)

mice_plot<-aggr(x[vars], col=c('navyblue', 'orange'),
  numbers=T, sortvars=T,
  labels=names(x[vars]), cex.axis=.7,
  gap=3, ylab=c("Missing data", "Pattern"))

y<-mi::missing_data.frame(x)
y[["RACE"]]<-update(y[["RACE"]], "type", list("ordered-categorical"))

show(y)

y<-mi::change(y, y=c("RACE", "PAY1", "PAY2"), what= "type", to = c("unordered-categorical"))
count(x$)

