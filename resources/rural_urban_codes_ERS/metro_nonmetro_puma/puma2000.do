set more off
clear
capture log close
log using puma2000.log,replace

*** puma2000.do
***
*** Applies June 2003 metro/nonmetro definition to 2000 Census PUMAs (approximately)
***
*** Input file #1: "census2000place.txt"  Source: aggregation of state files from 
*** http://www2.census.gov/census_2000/datasets/PUMS/FivePercent/  (US Census Bureau)
***
*** Input file #2: "ruralurbancodes2003.dta" 
*** Source: converted from "RuralUrbanCodes2003.xls" and "pr2003.xls"
*** located at http://www.ers.usda.gov/Data/RuralUrbanContinuumCodes/ (USDA Economic Research Service)
*** 
*** Output files: "Metro_Nonmetro_PUMA_2000.dta"
***
*** Author: Tom Hertz (THertz@ers.usda.gov) with help from Tim Parker and Lorin Kusmin of ERS.
***
*** Last updated 3/17/2016


***
*** STEP ONE: CREATION OF census2000place.txt
***

/*
The file census2000place.txt aggregates the 5% Public Use Microdata Sample Equivalency (PUMEQ5) files
for the 50 states and the District of Columbia.  The header blocks have been removed and are replicated below.
The text file is in strict column format (see infix statement below for record layout).  A few blank lines were deleted.

The header record reads as follows:

 This 5% Public Use Microdata Sample Equivalency (PUMEQ5) file is intended to help users understand the relationships
 between standard Census 2000 geographic concepts (counties, county subdivisions, places, and census tracts) and the
 SuperPUMA and PUMA geographic units of the 5% PUMS data files.

 Each PUMEQ5 file delineates the summary level codes specific to the PUMS geography, and has its own set of summary
 level code and hierarchical sequencing, as described below:

 780 State-SuperPUMA-PUMA
     781 State-SuperPUMA-PUMA-County (or part)
         782 State-SuperPUMA-PUMA-County-County Subdivision (or part) (20 states with functioning county subdivisions)
             783 State-SuperPUMA-PUMA-County-County Subdivision-Place/Remainder (or part)
                 784 State-SuperPUMA-PUMA-County-County Subdivision-Place/Remainder-Census Tract

 Please note that in the New England states, there may be more than one summary level 781 record within a single
 PUMA, since these areas may exist in more than one metropolitan area/nonmetropolitan area.  Please also
 note that county subdivision codes are not used in the 30 states, the District of Columbia, and Puerto Rico,
 that have no functioning county subdivisions. Census tracts are shown only when a place has parts in more than
 one PUMA.

 The fields and content of the PUMEQ5 file is described below:

   FIELD     DESCRIPTION

     A       Summary Level Code (described above)
     B       FIPS State Code
     C       SuperPUMA Code
     D       PUMA Code
     E       FIPS County Code
     F       FIPS County Subdivision Code
     G       FIPS Place Code
     H       Central City Indicator:
               0 = Not in central city
               1 = In central city
     I       Census Tract Code
     J       Metropolitan Statistical Area/Consolidated Statistical Area Code
     K       Primary Metropolitan Statistical Area Code
     L       Census 2000 100% Population Count
     M       Area Name

*/


***
*** STEP TWO: READ census2000place.txt INTO STATA FORMAT
***           

#delimit ;
infix int 	level			2-4 
	str2	fips_state 		6-7  
	str5	superpuma 		9-13  
	str5	puma			15-19  
	str3	fips_cnty		21-23  
	str5	fips_sub_cnty	25-29  
	str5	fips_place		31-35 
	str1	centralcity		37  
	str6	tract			39-44 
	str4 	msa_csa		46-49
	str4	pmsa			51-54
	long	pop2000		56-63
	str60	name			65-124 using "C:\Users\thertz\Documents\ERS Projects\2000 Metro PUMAs\census2000place.txt";
#delimit cr


*** CREATE UNIQUE CODES FOR PUMAS THAT CORRESPOND TO STANDARD FORMAT (STRING VARIABLES)
*** DITTO FOR FIPS COUNTY CODES
gen str10 pumacode=superpuma+puma
gen str5 fipscode=fips_state+fips_cnty

*** CONFIRM THAT PUMA LEVEL AND COUNTY LEVEL RECORDS BOTH
*** SUM TO FULL US POPULATION
*** THAT MEANS WE CAN DROP MORE DETAILED RECORDS
egen double poptot=sum(pop2000), by(level)
table level,c(mean poptot) f(%15.0f)
drop poptot
drop if level > 781

*** MAP PUMA POPULATIONS TO EACH COUNTY OR COUNTY FRAGMENT IN PUMA
gen double pop780=pop2000 if level==780
egen double pumapop2000=sum(pop780),by(pumacode)
drop pop780

*** CONFIRM THAT POPULATIONS OF ALL COUNTIES AND COUNTY FRAGMENTS ADD TO TOTAL IN PUMA
gen double p781=pop2000 if level==781
egen pumacntytot=sum(p781), by(pumacode)
assert pumacntytot==pumapop2000
drop pumacntytot

*** THESE ARE CROSS-PUMA COUNTY TOTAL POPS TO CHECK LATER
egen cntypop=sum(p781),by(fipscode)
drop p781 

*** KEEP ONLY COUNTY OR COUNTY FRAGMENT RECORDS
*** SORT AND SAVE TO MERGE WITH COUNTY DATASET

keep if level==781
drop fips_sub_cnty - pmsa
sort fipscode
save census2000_puma_cnty,replace


***
*** STEP 3: MERGE IN ERS COUNTY DATA FILE "RuralUrbanCodes2003.xls" 
*** ONLY STRAY IS BROOMFIELD COUNTY, BUT IT MAY BE DROPPED WITHOUT ALTERING POPULATION

merge fipscode using ruralurbancodes2003
tab _merge
list if _merge==2
drop if _merge==2
drop name _merge 
sort fipscode

*** 
*** STEP 4: METRO CODING FOR PUMAS
*** 

*** FLAG METRO COUNTIES
gen metro=rucc03<=3

*** mpop is population from a metro county or county fragment
*** mpoptot is total population in PUMA that comes from any metro county (on all records for that puma)
*** mpopshare is share of population in PUMA that comes from metro county (on all records for that puma)

gen double mpop=metro*pop2000
egen double mpop2000=sum(mpop),by(pumacode)
gen mpopshare2000=mpop2000/pumapop2000


*** COLLAPSE TO PUMA LEVEL
collapse (min) mpop2000 pumapop2000 mpopshare2000,by(fips_state state2 pumacode)

***
*** CREATE METROPUMA VARIABLE, RENAME VARIABLES 
*** AND SAVE FINAL DATASET 
***

gen byte metropuma03=(mpopshare>0.50)
gen str5 superpuma=substr(pumacode,1,5)
gen str5 puma=substr(pumacode,6,5)

sort pumacode

*** RECODE fips_state to numeric and rename to statefip to match ACS
gen byte statefip = real(fips_state)
drop fips_state

keep statefip superpuma puma mpop2000 pumapop2000 mpopshare2000 metropuma03
label var statefip "State FIPS code"
label var superpuma "2000 Super PUMA"
label var puma "2000 PUMA (not unique without superpuma or statefip)"
label var mpop2000 "Metro03 population in PUMA in 2000"
label var pumapop2000 "Total population in PUMA in 2000"
label var mpopshare2000 "Share of PUMA that is Metro03"
label var metropuma03 "PUMA Majority Metro by 2003 Definition"

order statefip puma superpuma mpop2000 pumapop2000 mpopshare2000 metropuma03
sort statefip puma
d
sum
saveold Metro_Nonmetro_PUMA_2000,replace version(11)
outsheet using Metro_Nonmetro_PUMA_2000.csv,comma replace


********************************************************************************
*** SUMMARIZE RESULTS
********************************************************************************

*** Distribution of population according to metro pop shares of PUMA
gen mpcat2000=mpopshare2000
recode mpcat2000 .000001/.20=.20 .20000001/.8 = .5 .800000001/.9999999=.99
table mpcat2000 if statefip~=72,c(n mpop2000 sum mpop2000 sum pumapop2000) f(%12.0f)
tab statefip mpcat2000,miss

*** Assess classification error rates
table metropuma03 if statefip~=72,c(sum mpop2000 sum pumapop2000) f(%12.0f)

log close
