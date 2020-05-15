#ensure we have packages necessary for code
local({r <- getOption("repos")
r["CRAN"] <- "http://cran.r-project.org"
options(repos=r)
})

path_packages = "/home/tuppal/R"
# path_packages = "C:/Cloud/Box Sync/HCUP Data/hcup/packages"
install.packages(c("knitr","comorbidity","readxl", "digest",
                   "ggplot2", "tidyverse","prodlim", "data.table", 
                   "RColorBrewer", "foreign", "tidyverse", "plyr",
                   "summarytools", "survey", "dsr", "kableExtra", 
                   "magrittr", "scales", "openxlsx", "surveydata", 
                   "margins", "car", "agricolae", "etm", "popEpi", 
                   "Epi", "survival", "data.table", "haven", "parallel"
                   ), dependencies = TRUE,lib=path_packages)


Packages<- c("knitr","comorbidity","readxl", "digest",
             "ggplot2", "tidyverse","prodlim", "data.table", 
             "RColorBrewer", "foreign", "tidyverse", "plyr",
             "summarytools", "survey", "dsr", "kableExtra", 
             "magrittr", "scales", "openxlsx", "surveydata", 
             "margins", "car", "agricolae", "etm", "popEpi", 
             "Epi", "survival", "data.table", "haven", "parallel")

invisible(lapply(Packages, library, character.only=T))


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

  
  repo<- "/home/tuppal/project/hcup_nis"
  data_path <- paste0(repo, "/data")
  neds_diab_path<-paste0(data_path, "/hcup_diab/NEDS_diab_obj")
  neds_diab_obj<-dir(neds_diab_path)
  
  repo<- "C:/Users/teg83/Documents/GitHub/hcup_nis"
  data_path <- paste0(repo, "/data")
  nis_diab_path<-paste0(data_path, "/hcup_diab/NIS_diab_obj")
  nis_diab_obj<-dir(nis_diab_path)
  
  repo<- "C:/Users/teg83/Documents/GitHub/hcup_nis"
  data_path <- paste0(repo, "/data")
  sedd_diab_path<-paste0(data_path, "/hcup_diab/SEDD_diab_obj")
  sedd_diab_obj<-dir(sedd_diab_path)
  
  repo<- "C:/Users/teg83/Documents/GitHub/hcup_nis"
  data_path <- paste0(repo, "/data")
  sid_diab_path<-paste0(data_path, "/hcup_diab/sid_diab_obj")
  sid_diab_obj<-dir(sid_diab_path)

  resource_path<-paste0(repo, "/resources")