set more off
clear
capture log close
log using puma2010.log,replace

*** puma2010.do
***
*** Applies June 2003 and 2013 metro/nonmetro definitions to 2010 Census PUMAs
*** Note that 2003 definition not available in this file for Puerto Rico
***
*** Creates: Metro_Nonmetro_PUMA_2010.dta
***
*** Input file 1: "PUMSEQ10_ALL.txt"  Source: see below.
***
*** Input files 2&3: "ruralurbancodes2003.dta" & "ruralurbancodes2013.dta" 
*** Source: converted from "RuralUrbanCodes2003.xls", "pr2003.xls"
*** and "RuralUrbanCodes2013.xls" 
*** http://www.ers.usda.gov/data-products/rural-urban-continuum-codes.aspx/
*** (USDA Economic Research Service)
*** 
*** Input file 4: "LTDB_2000_pop.dta" 
*** Source: "LTDB_Std_2000_fullcount" (Brown University: Longitudinal Tract Database)
*** http://www.s4.brown.edu/us2010/Researcher/LTBDDload/DataList.aspx
***
*** Author: Tom Hertz (THertz@ers.usda.gov) with help from Tim Parker of ERS.
***
*** Last updated 3/16/2016

********************************************************************************
*** CREATION OF PUMSEQ10_ALL.txt
********************************************************************************
/*
The file PUMSEQ10_ALL.txt aggregates the state-based 2010 PUMA equivalency files
(PUMSEQ10) files, which are located here:
http://www2.census.gov/geo/docs/reference/puma/

The summary level codes and their hierarchical sequencing is described here:
http://www2.census.gov/geo/pdfs/reference/puma/2010_PUMA_Equivalency_Summary_Levels.pdf

The codes are:

795 State-PUMA
	796 State-PUMA-County (or part)
		797 State-PUMA-County-County Subdivision (or part)
			798 State-PUMA-County-County Subdivision-Place/Remainder (or part)
				(only for the 20 states with governmentally functioning county subdivisions*)
				799 State-PUMA-County-County Subdivision-Place/Remainder-Census Tract

*Please note county subdivision codes are not included for the 30 states, the District of
Columbia, and Puerto Rico because they do not have governmentally functioning county
subdivisions (MCD). The 20 states with functioning MCDs are Connecticut, Illinois, Indiana,
Kansas, Maine, Massachusetts, Michigan, Minnesota, Missouri, Nebraska, New Hampshire, New
Jersey, New York, North Dakota, Ohio, Pennsylvania, Rhode Island, South Dakota, Vermont,
Wisconsin.

The record layout is here (field names are our own): 
http://www2.census.gov/geo/pdfs/reference/puma/2010_PUMA_Equivalency_Format_Layout.pdf

FIELD    		DESCRIPTION
level			Summary Level Code (described above)
fips_state		FIPS State Code
nsc_state		State National Standard Code
puma2010		PUMA Code (2010 Delineations)
fips_cnty		FIPS County Code
nsc_cnty		County National Standard Code
fips_subcnty	FIPS County Subdivision Code
nsc_subcnty		National Standard Code County Subdivision
fips_place		FIPS Place Code
nsc_place		National Standard Code Place
tract			Census Tract Code
pop2010			2010 Population Count
house2010		2010 Housing Unit Count
areaname		Area Name
*/


********************************************************************************
*** READ PUMSEQ10_ALL.txt INTO STATA FORMAT
********************************************************************************
*** Note: SUPERPUMAS, which were used in 2000, were eliminated in 2010.
*** PUMAS are now identified by state FIPS code + PUMA code

#delimit ;
infix int 	level			1-3 
	str2	fips_state 		4-5
	str8	nsc_state 		6-13  
	str5	puma2010		14-18
	str3	fips_cnty		19-21
	str8	nsc_cnty		22-29
	str5	fips_subcnty	30-34  
	str8	nsc_subcnty		35-42
	str5	fips_place		43-47
	str8	nsc_place		48-55
	str6	tract			56-61
	long	pop2010			62-70
	long	house2010		71-79
	str100	areaname		80-179 using PUMSEQ10_ALL.TXT;
#delimit cr
save PUMSEQ10_ALL,replace

********************************************************************************
*** In order to apply the 2003 OMB metro definition, we need 2000 population
*** estimates for each PUMA in 2010. This is done by using the LTDB to find
*** the 2000 population figures for each 2010 census tract. 
********************************************************************************

*** Confirm that tracts can be aggregated into counties
preserve
keep if level==796
sum pop2010
scalar pop10a=r(mean)*r(N)
sum pop2010 if fips_state~="72"
restore

preserve
keep if level==799
sum pop2010
scalar pop10b=r(mean)*r(N)
restore
di pop10a-pop10b

*** Extract tracts, confirm that although they often appear multiple times
*** (as different Census places), they are always in same PUMA. So OK to 
*** collapse to puma/county/tractid. Then merge to get pop2000 from LTDB
*** PR does not merge; a few others are missing in LTDB, not a big deal.
*** For these, assign pop2000=0.9*pop2010. Most have zero pop2010 anyway.
keep if level==799
gen str11 tractid=fips_state+fips_cnty+tract
gen str5 fipscode=fips_state+fips_cnty

keep tractid fipscode fips_state fips_cnty puma2010 pop2010
sort tractid
assert puma==puma[_n-1] if tractid==tractid[_n-1]
collapse (sum) pop2010,by(puma2010 fipscode fips_state fips_cnty tractid)
sum pop2010
scalar pop10c=r(mean)*r(N)
di pop10a-pop10c
sort tractid

merge tractid using LTDB_2000_pop.dta
tab _merge
sum pop2010 if _merge==1 & fips_state~="72",detail
replace pop2000=0.90*pop2010 if _merge==1 & fips_state~="72"
drop _merge


*** Map PUMA populations to each tract in PUMA
egen double pumapop2010=sum(pop2010),by(fips_state puma2010)
egen double pumapop2000=sum(pop2000),by(fips_state puma2010)

*** These are county totals to check later against ERS data
egen cntypop=sum(pop2010),by(fipscode)


********************************************************************************
*** MERGE IN ERS COUNTY DATA FILE "RuralUrbanCodes2003.dta" 
********************************************************************************

/* RECORD LAYOUT
fipscode = state plus county fips string 
state2 = 2-letter state abbreviation
cntyname = name of county 
rucc03 = RUCC code for 2003
erspop2000 = County population in 2000

Codes for RUCC's are as follows:

Metro counties:
1	Counties in metro areas of 1 million population or more
2	Counties in metro areas of 250,000 to 1 million population
3	Counties in metro areas of fewer than 250,000 population

Nonmetro counties:
4	Urban population of 20,000 or more, adjacent to a metro area
5	Urban population of 20,000 or more, not adjacent to a metro area
6	Urban population of 2,500 to 19,999, adjacent to a metro area
7	Urban population of 2,500 to 19,999, not adjacent to a metro area
8	Completely rural or less than 2,500 urban pop., adjacent to a metro area
9	Completely rural or less than 2,500 urban pop., not adjacent to a metro area
*/

*** Only problems are in Alaska; checked and they are all RUCC 9's
*** Keep the place file record, drop the ERS records
sort fipscode
sum pop2010
merge fipscode using ruralurbancodes2003
tab _merge
list if _merge~=3
drop if _merge==2
replace rucc03=9 if _merge==1
drop state2 cntyname _merge erspop2000
assert rucc03~=.
sum pop2010

********************************************************************************
*** MERGE IN ERS COUNTY DATA FILE "RuralUrbanCodes2013.dta" 
********************************************************************************
sort fipscode
merge fipscode using ruralurbancodes2013
tab _merge
assert _merge==3
assert erspop2010==cntypop
drop state2 erspop2010 cntyname _merge
assert rucc03~=.
sort fipscode


********************************************************************************
*** METRO CODING FOR PUMAS
********************************************************************************
gen metro03=rucc03<=3
gen metro13=rucc13<=3


*** mpop2000 is 2000 population from any metro03 tract
*** mpop2010 is 2010 population from any metro13 tract

*** mpopshare2000 is share of 2000 population in PUMA from metro 2003 tract
*** mpopshare2010 is share of 2010 population in PUMA from metro 2013 tract

gen double mpop2000temp=metro03*pop2000
gen double mpop2010temp=metro13*pop2010

egen double mpop2000=sum(mpop2000temp),by(fips_state puma2010)
egen double mpop2010=sum(mpop2010temp),by(fips_state puma2010)

gen mpopshare2000=mpop2000/pumapop2000
gen mpopshare2010=mpop2010/pumapop2010
drop mpop2010temp mpop2000temp


********************************************************************************
*** COLLAPSE TRACTS TO PUMAS (mpop* and pumapop* are already PUMA-level)
********************************************************************************
collapse (min) mpop* pumapop*,by(fips_state puma2010)
sum pumapop2010
scalar pop10d=r(mean)*r(N)
di pop10d-pop10a


********************************************************************************
*** CREATE METROPUMA VARIABLES
*** AND SAVE FINAL DATASET = Metro_Nonmetro_PUMA_2010.dta
********************************************************************************
gen byte metropuma03=(mpopshare2000>0.50)
gen byte metropuma13=(mpopshare2010>0.50)

*** RECODE fips_state to numeric and rename to statefip to match ACS
gen byte statefip = real(fips_state)
drop fips_state

*** RENAME puma2010 to puma to match ACS
rename puma2010 puma

label var statefip "State FIPS code"
label var puma	   "2010 PUMA ID (not unique without statefip prefix)"
label var mpop2000 "Metro03 population in PUMA in 2000"
label var mpop2010 "Metro13 population in PUMA in 2010"

label var pumapop2000 "Total population in PUMA in 2000"
label var pumapop2010 "Total population in PUMA in 2010"

label var mpopshare2000 "Share of PUMA that is Metro03"
label var mpopshare2010 "Share of PUMA that is Metro13"

label var metropuma03 "PUMA Majority Metro by 2003 Definition"
label var metropuma13 "PUMA Majority Metro by 2013 Definition"

keep statefip puma mpop2000 pumapop2000 mpopshare2000 metropuma03 ///
			 		   mpop2010 pumapop2010 mpopshare2010 metropuma13
						  
order statefip puma mpop2000 pumapop2000 mpopshare2000 metropuma03 ///
						mpop2010 pumapop2010 mpopshare2010 metropuma13

sort statefip puma
label data "Metro population shares for 2010 PUMAs"
d
sum
saveold Metro_Nonmetro_PUMA_2010,replace version(11)
outsheet using Metro_Nonmetro_PUMA_2010.csv,comma replace

********************************************************************************
*** SUMMARIZE RESULTS
********************************************************************************

*** Distribution of population according to metro pop shares of PUMA
gen mpcat2000=mpopshare2000
gen mpcat2010=mpopshare2010

recode mpcat2000 .000001/.20=.20 .20000001/.8 = .5 .800000001/.9999999=.99
recode mpcat2010 .000001/.20=.20 .20000001/.8 = .5 .800000001/.9999999=.99

table mpcat2000 if statefip~=72,c(n mpop2000 sum mpop2000 sum pumapop2000) f(%12.0f)
table mpcat2010 if statefip~=72,c(n mpop2010 sum mpop2010 sum pumapop2010) f(%12.0f)

tab statefip mpcat2000,miss
tab statefip mpcat2010,miss

*** Assess classification error rates
table metropuma13 if statefip~=72,c(sum mpop2010 sum pumapop2010) f(%12.0f)
table metropuma03 if statefip~=72,c(sum mpop2000 sum pumapop2000) f(%12.0f)

log close
