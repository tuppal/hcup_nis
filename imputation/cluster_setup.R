#ensure we have packages necessary for code
local({r <- getOption("repos")
r["CRAN"] <- "http://cran.r-project.org"
options(repos=r)
})


path_packages = "/home/tuppal/R"
# path_packages = "C:/Cloud/Box Sync/HCUP Data/hcup/packages"
# install.packages(c("knitr","readxl", "digest",
#                    "ggplot2", "plyr","tidyverse","prodlim", 
#                    "data.table", "foreign", "summarytools", "survey",
#                    "kableExtra", "openxlsx", "surveydata", "margins",
#                    "data.table", "haven"), dependencies = TRUE,lib=path_packages)
                   #"parallel","car", "agricolae", "etm", "popEpi", "Epi", 
                   #"survival","dsr", #"scales", "RColorBrewer"))

#Packages<- c("knitr","readxl", "digest",
#             "ggplot2", "plyr","tidyverse","prodlim", 
#             "data.table", "foreign", "summarytools", "survey",
#             "kableExtra", "openxlsx", "surveydata", "margins",
#             "data.table", "haven")
             #"parallel","car", "agricolae", "etm", "popEpi", "Epi", 
             #"survival","dsr", #"scales", "RColorBrewer")
path_packages = "/home/tuppal/R/x86_64-redhat-linux-gnu-library/3.4/"
install.packages(c("knitr","readxl", "digest", "plyr", "tidyverse",
                   "data.table", "survey", "kableExtra", "openxlsx",
                  "data.table"), 
                 dependencies = TRUE,lib=path_packages)
.libPaths()
#invisible(lapply(Packages, library, character.only=T))
 library(knitr, lib.loc = path_packages)
 library(readxl, lib.loc = path_packages)
 library(digest, lib.loc = path_packages)
# library(ggplot2, lib.loc = path_packages)
 library(plyr, lib.loc = path_packages)
 library(tidyverse, lib.loc = path_packages)
# library(prodlim, lib.loc = path_packages)
 library(data.table, lib.loc = path_packages)
# library(foreign, lib.loc = path_packages)
# library(summarytools, lib.loc = path_packages)
 library(survey, lib.loc = path_packages)
# library(kableExtra, lib.loc = path_packages)
 library(openxlsx, lib.loc = path_packages)
# library(surveydata, lib.loc = path_packages)
# library(margins, lib.loc = path_packages)
 library(data.table, lib.loc = path_packages)
# library(haven, lib.loc = path_packages)

 

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

prop_se<-function(tot){
  b<-as.data.frame(as.tibble(tot[,1:3]))
  b$prop<-paste("(",round((b$all/(sum(b$all))*100), digits=1),"%",")",sep="")
  b<-b[c(1,2,4,3)]
  colnames(b)<-c("Variable", "n of events", "%", "se")
  return(b)
}

count_se<-function(tot){
  tot<-as.data.frame(tot)
  tot$all<-round(tot[,2], digits=0)
  tot$se<-round(tot[,3], digits=0)
  var_name<-colnames(tot)[1]
  colnames(tot)<-c("Variable", "n of events", "se")
  return(tot)}

#function to generate demographic characteristics using BRFSS data
char<-function(x){
  tot<-svyby(~all, ~x, brfss_design, svytotal)
  b<-prop(tot)
  b
  var_name<-colnames(tot)[1]
  var<-assign(paste0("count", "_", var_name), b)
  var
  colnames(var)<- c("Characteristics", "n", "%")
  return(var)
}

  
  repo<- "/home/tuppal/project/hcup_aim1"
  data_path <- paste0(repo, "/data")
  neds_diab_path<-paste0(data_path, "/hcup_diab/NEDS_diab_obj")
  neds_diab_obj<-dir(neds_diab_path)
  
  nis_diab_path<-paste0(data_path, "/hcup_diab/NIS_diab_obj")
  nis_diab_obj<-dir(nis_diab_path)
  
  sedd_diab_path<-paste0(data_path, "/hcup_diab/SEDD_diab_obj")
  sedd_diab_obj<-dir(sedd_diab_path)
  
  sid_diab_path<-paste0(data_path, "/hcup_diab/sid_diab_obj")
  sid_diab_obj<-dir(sid_diab_path)

  resource_path<-paste0(repo, "/resources")
  acs_path<-paste0(data_path, "/acs/acs_obj")
  acs_obj<-dir(acs_path)
  acs_5yr_path<-paste0(repo, "/data/acs/acs_5yr")
  acs_5yr_obj<-dir(acs_5yr_path)