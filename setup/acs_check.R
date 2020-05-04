


yr<-mean(acs_design$variables$YEAR)
#acs_check
#2011 from American fact finder, https://data.census.gov/cedsci/table?q=populatin&hidePreview=true&tid=ACSDP1Y2011.DP05&vintage=2018&y=2011
if(year==2011){
check_var<-c("Weighted", "65-75", "75+", "Female", "Male")
check_val<-c(237681218, 22489229, 18895797, 122233040, 115448178)
nat_check_11<-data.frame("Characteristics"=acs_check_var, "n"=acs_check_val)
rm(check_var, check_val, nat_check_11)

fl_check_var<-c("Weighted", "65-75", "75+", "Female", "Male")
fl_check_val<-c(15062592, 1777707, 1581688, 7786742, 7275850)
fl_check_11<-data.frame("Characteristics"=acs_check_var, "n"=acs_check_val)

ut_check_var<-c("Weighted", "65-75", "75+", "Female", "Male")
ut_check_val<-c(1936143, 143300, 115024, 971816, 964327)
ut_check_11<-data.frame("Characteristics"=acs_check_var, "n"=acs_check_val)
}else if(year==2014){
#acs_check
#2014 from American fact finder, https://data.census.gov/cedsci/table?q=populatin&hidePreview=true&tid=ACSDP1Y2011.DP05&vintage=2018&y=2011

acs_check_var<-c("Weighted", "65-75", "75+", "Female", "Male")
acs_check_val<-c(245279633, 26418204, 19796689, 126005451, 119274182)
acs_check_14<-data.frame("Characteristics"=acs_check_var, "n"=acs_check_val)
rm(acs_check_var, acs_check_val)

ne_check_var<-c("Weighted", "65-75", "75+", "Female", "Male")
ne_check_val<-c(1413626, 145233, 125444, 718206, 695420)
ne_check_14<-data.frame("Characteristics"=acs_check_var, "n"=acs_check_val)

md_check_var<-c("Weighted", "65-75", "75+", "Female", "Male")
md_check_val<-c(4625232, 479017, 343154, 2419617, 2205615)
md_check_14<-data.frame("Characteristics"=acs_check_var, "n"=acs_check_val)

}else if(year==2016){
#acs_check
#2016 from American fact finder, https://data.census.gov/cedsci/table?q=populatin&hidePreview=true&tid=ACSDP1Y2011.DP05&vintage=2018&y=2011

acs_check_var<-c("Weighted", "65-75", "75+", "Female", "Male")
acs_check_val<-c(249489772, 28681808, 20533357, 27454727, 21760438)
acs_check_16<-data.frame("Characteristics"=acs_check_var, "n"=acs_check_val)
rm(acs_check_var, acs_check_val)

nc_check_var<-c("Weighted", "65-75", "75+", "Female", "Male")
nc_check_val<-c(7849894, 944866, 623725, 4093519, 3756375)
nc_check_16<-data.frame("Characteristics"=acs_check_var, "n"=acs_check_val)

ny_check_var<-c("Weighted", "65-75", "75+", "Female", "Male")
ny_check_val<-c(15565903, 1715037, 1315744, 8119421, 7446482)
ny_check_16<-data.frame("Characteristics"=acs_check_var, "n"=acs_check_val)

}else if(year==2017){
#acs_check
#2017 from American fact finder, https://data.census.gov/cedsci/table?q=populatin&hidePreview=true&tid=ACSDP1Y2011.DP05&vintage=2018&y=2011

acs_check_var<-c("Weighted", "65-75", "75+", "Female", "Male")
acs_check_val<-c(252070495, 29731876, 21083836, 129341135, 122729360)
acs_check_17<-data.frame("Characteristics"=acs_check_var, "n"=acs_check_val)
rm(acs_check_var, acs_check_val)

nj_check_var<-c("Weighted", "65-75", "75+", "Female", "Male")
nj_check_val<-c(7026848, 801569, 614903, 808608, 607864)
nj_check_17<-data.frame("Characteristics"=acs_check_var, "n"=acs_check_val)

az_check_var<-c("Weighted", "65-75", "75+", "Female", "Male")
az_check_val<-c(5383542, 701165, 499685, 2728146, 2655396)
az_check_17<-data.frame("Characteristics"=acs_check_var, "n"=acs_check_val)
}else(print("next"))

