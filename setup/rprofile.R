
knitr::opts_chunk$set(echo = TRUE)
if(!require(knitr)){
  install.packages("knitr")
  library(knitr)
}
if(!require(comorbidity)){
  install.packages("comorbidity")
  library(comorbidity)
}
if(!require(readxl)){
  install.packages("readxl")
  library(readxl)
}
if(!require(digest)){
  install.packages("digest")
  library(digest)
}
if(!require(ggplot2)){
  install.packages("ggplot2")
  library(ggplot2)
}
if(!require(pheatmap)){
  install.packages("pheatmap")
  library(pheatmap)
}
if(!require(tidyverse)){
  install.packages("tidyverse")
  library(tidyverse)
}
if(!require(prodlim)){
  install.packages("prodlim")
  library(prodlim)
}
if(!require(recipes)){
  install.packages("recipes")
  library(recipes)
}
if(!require(data.table)){
  install.packages("data.table")
  library(data.table)
}
if(!require(RColorBrewer)){
  install.packages("RColorBrewer")
  library(RColorBrewer)
}
if(!require(foreign)){
  install.packages("foreign")
  library(foreign)
}
if(!require(tidyverse)){
  install.packages("tidyverse")
  library(tidyverse)
}
if(!require(plyr)){
  install.packages("plyr")
  library(plyr)
}
if(!require(summarytools)){
  install.packages("summarytools")
  library(summarytools)
}
if(!require(survey)){
  install.packages("survey")
  library(survey)
}
if(!require(dsr)){
  install.packages("dsr")
  library(dsr)
}
if(!require(kableExtra)){
  install.packages("kableExtra")
  library(kableExtra)
}
if(!require(magrittr)){
  install.packages("magrittr")
  library(magrittr)
}
if(!require(scales)){
  install.packages("scales")
  library(scales)
}
if(!require(openxlsx)){
  install.packages("openxlsx")
  library(openxlsx )
}
if(!require(surveydata)){
  install.packages("surveydata")
  library(surveydata )
}
if(!require(margins)){
  install.packages("margins")
  library(margins )
}
if(!require(car)){
  install.packages("car")
  library(car )
}
if(!require(agricolae)){
  install.packages("agricolae")
  library(agricolae )
}
if(!require(etm)){
  install.packages("etm")
  library(etm )
}
if(!require(popEpi)){
  install.packages("popEpi")
  library(popEpi )
}
if(!require(Epi)){
  install.packages("Epi")
  library(Epi )
}
if(!require(survival)){
  install.packages("survival")
  library(survival )
}
if(!require(data.table)){
  install.packages("data.table")
  library(data.table )
}
if(!require(haven)){
  install.packages("haven")
  library(haven )
}
if(!require(haven)){
  install.packages("parallel")
  library(parallel)
}
detectCores()


#function to generate proportions
perc<-function(x){paste("(",round((x/(sum(x))*100), digits=1),"%",")",sep="")}
#function to place number in parenthesis
prnth<-function(x){paste0("(", x,")")}
#define function to coerce numbers into thousands (simplify reading millions in tables)
thou_round<-function(x){
  x<-round(x, digits=-3)
  x<-x/1000
}
thou_noround<-function(x){
  x<-x/1000
}

prop<-function(tot){
  b<-as.data.frame(as.tibble(tot[,1:2]))
  b$prop<-paste("(",round((b$all/(sum(b$all))*100), digits=1),"%",")",sep="")
  colnames(b)<-c("Variable", "n of events", "%")
  return(b)
}


if(Sys.info()["user"]=="TUPPAL"){
  repo<- "C:/Users/TUPPAL/merck/hcup_NIS/"
  data_path <- "H:/Job/Merck/HCUP_data/hcup_sas/sid_sas/"
  nis_list <- dir(data_path)
  az_sid<- paste0(data_path, "AZ_c")
  fl_sid<- paste0(data_path, "FL_c")
  ia_sid<- paste0(data_path, "IA_c")
  ky_sid<- paste0(data_path, "KY_c")
  md_sid<- paste0(data_path, "MD_c")
  nc_sid<- paste0(data_path, "NC_c")
  ne_sid<- paste0(data_path, "NE_c")
  nj_sid<- paste0(data_path, "NJ_c")
  ny_sid<- paste0(data_path, "NY_c")
  ut_sid<- paste0(data_path, "UT_c")
  vt_sid<- paste0(data_path, "VT_c")

  sed_path <- "H:/Job/Merck/HCUP_data/hcup_sas/sedd_sas/"
  az_sedd<- paste0(data_path, "AZ_c")
  fl_sedd<- paste0(data_path, "FL_c")
  ia_sedd<- paste0(data_path, "IA_c")
  ky_sedd<- paste0(data_path, "KY_c")
  md_sedd<- paste0(data_path, "MD_c")
  nc_sedd<- paste0(data_path, "NC_c")
  ne_sedd<- paste0(data_path, "NE_c")
  nj_sedd<- paste0(data_path, "NJ_c")
  ny_sedd<- paste0(data_path, "NY_c")
  ut_sedd<- paste0(data_path, "UT_c")
  vt_sedd<- paste0(data_path, "VT_c")


  nis_path <- "H:/Job/Merck/HCUP_data/nis_sas/"
  nis_list <- dir(nis_path)
  NIS_2008<- paste0(nis_path, "2008")
  NIS_2011<- paste0(nis_path, "2011")
  NIS_2014<- paste0(nis_path, "2014")
  NIS_2016<- paste0(nis_path, "2016")
  
  neds_path <- "H:/Job/Merck/HCUP_data/neds_sas/"
  neds_list <- dir(neds_path)
  NEDS_2008<- paste0(neds_path, "2008")
  NEDS_2011<- paste0(neds_path, "2011")
  NEDS_2014<- paste0(neds_path, "2014")
  NEDS_2016<- paste0(neds_path, "2016")
}

getwd()
if(Sys.info()["user"]=="teg83"){
  repo<- "C:/Users/teg83/Documents/GitHub/merck/hcup_NIS/"
  data_path <- paste0(repo, "Data")
  nis_list <- dir(data_path)
  az_sid<- paste0(data_path, "AZ_c")
  fl_sid<- paste0(data_path, "FL_c")
  ia_sid<- paste0(data_path, "IA_c")
  ky_sid<- paste0(data_path, "KY_c")
  md_sid<- paste0(data_path, "MD_c")
  nc_sid<- paste0(data_path, "NC_c")
  ne_sid<- paste0(data_path, "NE_c")
  nj_sid<- paste0(data_path, "NJ_c")
  ny_sid<- paste0(data_path, "NY_c")
  ut_sid<- paste0(data_path, "UT_c")
  vt_sid<- paste0(data_path, "VT_c")
  
  data_path <- "C:/Users/TUPPAL/merck/sedd/"
  nis_list <- dir(data_path)
  az_sedd<- paste0(data_path, "AZ_c")
  fl_sedd<- paste0(data_path, "FL_c")
  ia_sedd<- paste0(data_path, "IA_c")
  ky_sedd<- paste0(data_path, "KY_c")
  md_sedd<- paste0(data_path, "MD_c")
  nc_sedd<- paste0(data_path, "NC_c")
  ne_sedd<- paste0(data_path, "NE_c")
  nj_sedd<- paste0(data_path, "NJ_c")
  ny_sedd<- paste0(data_path, "NY_c")
  ut_sedd<- paste0(data_path, "UT_c")
  vt_sedd<- paste0(data_path, "VT_c")
  
  nis_path <- "H:/Job/Merck/HCUP_data/hcup_sas/nis_sas/NIS/"
  nis_list <- dir(nis_path)
  NIS_2008<- paste0(nis_path, "2008_c")
  NIS_2011<- paste0(nis_path, "2011_c")
  NIS_2014<- paste0(nis_path, "2014_c")
  NIS_2016<- paste0(nis_path, "2016_c")
  
  neds_path <- "H:/Job/Merck/HCUP_data/hcup_sas/neds_sas/"
  neds_list <- dir(neds_path)
  NEDS_2008<- paste0(neds_path, "2008")
  NEDS_2011<- paste0(neds_path, "2011")
  NEDS_2014<- paste0(neds_path, "2014")
  NEDS_2016<- paste0(neds_path, "2016")
}

if(Sys.info()["user"]=="starsdliu"){
  repo<- "/Users/starsdliu/Desktop/Rollins School of Public Health Research/Diabetes Program - Dr. Ali and Teg/MEPS Data/MEPS/ACSC_ED"
  data_path <- paste0(repo, "Data")
  nis_list <- dir(fc_path)
}

#If not one of the above users, enter user name and location of REPO and remove # to run code

#if(Sys.info()["user"]=="*ENTER USER NAME HERE"){
#  repo<- *ENTER REPO LOCATION HERE*
#data_path <- paste0(repo, "Data")
#nis_list <- dir(fc_path)
#}