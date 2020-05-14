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

