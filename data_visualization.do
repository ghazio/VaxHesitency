*HW1 
*Ghazi Randhawa


clear
set more off
capture restore
capture log close

*--------------------
* Directory Configuration
*--------------------

	
*Ghazi Randhawa
if "`c(username)'" == "ghazi" {
    global root = "/Users/ghazi/Dropbox/ECON35_HW1_Ghazi_Randhawa"
    }
*
if "`c(username)'" == "tarang" {
    global root = "/Users/ghazi/Dropbox/ECON35_HW1_Ghazi_Randhawa"
    }
if "`c(username)'" == "" {
    global root = "/Users/ghazi/Dropbox/ECON35_HW1_Ghazi_Randhawa"
    }

global data = "$root/Data/LSMS Dar"
global output = "$root/Output"
global logs = "$root/logs"
	
*------------------
* Import data
*------------------

use "$data/lsms_household.dta", clear

*------------------
* 1.1):
*     
*------------------

* 1) browse to look if visit 1 outcome variable was read correctly
*    and then tabulate if correctly
bro visit1_out_mr visit2_out_mr visit3_out_mr
* browse some specific variables
tab visit1_out_mr
tab visit2_out_mr 
tab visit3_out_mr

* we can see that there are 1820 complete interviews in first visit, 446 in second, and 229 in the second one.

* 2) To show this, I would like to show that there is going to be a very 
*sewservise \ s5_sewservice
*sewage frequence \sewfrq
*watersource \s5_watersource
*garbage \

tab s5_sewservice
tab s5_sewfrq
tab s5_watersource
tab s5_garbage
tab s5_energy
tab s5_electricity
tab s5_fuel
tab s5_waterpress
tab s5_supplyweek s5_supplyperday
tab s5_toilet s5_toiletshare

tab s4_subpov s5_watersource
summarize s5_timewater s5_timewait

* 3) 
tab s4_subpov2 

* 4)
tab s4_subpov s4_subpov2


* 5) *first i clean the rent per month by replacing -98  

tab s5_rentmonth

replace s5_rentmonth =. if s5_rentmonth== -99
replace s5_rentmonth =. if s5_rentmonth== -98

  * a) Mean rent per month: 47
	  summarize(s5_rentmonth), detail
	  
  * b) Variance:  6.81e+09
  
  * c) Variance of mean rent per month: Variance/N=6.81e+09/1151
  
  * d) SE of mean rent per month: (6.81e+09/1151)/(1151)^2
  
  * e) 
    ci means s5_rentmonth, level(95)
	
* 6) We will construct confidence interval for proportions
	
	bro s5_electricityhh
	 
	describe s5_electricityhh 
	decode s5_electricityhh, generate(s5_electricityhh_str)
 	gen s5_electricityhh_trim = trim(s5_electricityhh_str)
 
    gen s5_electricityhh_bin = 1
	replace s5_electricityhh_bin =0 if s5_electricityhh_trim == "no"
    replace s5_electricityhh_bin =. if s5_electricityhh_trim == ""

	drop s5_electricityhh_trim s5_electricityhh s5_electricityhh_str
	
	
	tab s5_electricityhh_bin
    ci proportions s5_electricityhh_bin, level(95)
	
* 7) 
	bro dist_toCBD
	
	replace dist_toCBD = . if dist_toCBD == -99
	replace dist_toCBD = . if dist_toCBD == -98

	summarize(dist_toCBD),detail
	return list
	
* 8) I Create the histogram as follows:
    histogram dist_toCBD, width(1)
	
* 9) 
	summarize(dist_toCBD),detail
	return list
	scalar medi= r(p50)
	
	
	lab var dist_toCBD "1=above median dist to CBD, 0 = below median distance to CBD" 

	
	gen above_med_CBD_dist = 1 
	replace above_med_CBD_dist = 0 if dist_toCBD < medi
    replace above_med_CBD_dist = . if dist_toCBD == .
	
    tabstat s5_rentmonth, statistics( mean median sd) by(above_med_CBD_dist) save
	return list
	
	
  
	
	
	
* 10)

    *a)	
    mat high_rent=r(Stat1)
  	mat low_rent =r(Stat2)
	scalar mean_diff=high_rent[1,1]-low_rent[1,1] 
	scalar SE = ((high_rent[3,1])^2/477+(low_rent[3,1])^2/663)^0.5
	
	
	matrix list high_rent
	display high_rent[2,1]
	display mean_diff
	display SE
	
    *b) Not sure
		scalar SE = ((high_rent[3,1])^2/477+(low_rent[3,1])^2/663)^0.5

	
* 11)


	ttest s5_rentmonth, by(above_med_CBD_dist)
	return list
    
 *we can see that the Null hypothesis is valid according to the null hypothesis because it is above the 
 *cut-off value of alpha at 0.5. In practical terms, it means that the two groups of avove median CBD distance do not pay different rents..
 
 
 
 *12) 
 use "$data/s1_hhroster_share.dta", clear
 unique id
 
*each id represents a unique family group
 
 
 *13)
 bro
 bysort id: gen count=_n
 bysort id: gen count2=_N
 list id2
 tab count2 if count==1
*count counts the number of people in a household data that has the same id and count2 keeps track of the size of each family. When we call tab on it, it gives the number of each household with complete data.
 *14)
 merge m:1 id using "$data/lsms_household"
 drop if id2==.
 bro s1_hhrtnshp
 decode s1_hhrtnshp, generate(s1_hhrtnshp_str)
 gen s1_hhrtnshp_trim = trim(s1_hhrtnshp_str)

 drop if s1_hhrtnshp_trim != "head"
 

 
 
 
 *15)
	tab hwrkyn
	decode hwrkyn, generate(hwrkyn_str)
	drop hwrkyn
	
	gen hwrkyn = 1 
	replace hwrkyn = 0 if hwrkyn_str == "no"
    replace hwrkyn = . if hwrkyn_str == ""
    
	drop hwrkyn_str
	
	tab hwrkyn
	

*16) 
	regress hwrkyn dist_toCBD, r
	est store te1
	esttab te1
	
	regress hwrkyn dist_toCBD

	est store te2
	esttab te2


*17)
*The coeffecients do not vary but the standard errors in robust is higher than standard errors in non-robust results and confidence intervals for robust are higher too. It is because in non-robust regression, we assume heteroskediscity. 


*18)
   regress s1_age dist_toCBD, r
  *it shows that there is an increasing relationship between the age variable and the distance to cbd variable.
  
*19) 
   correlate dist_toCBD s1_age

*20) 
	*Given the correlation between the two variables of age and distance to CBD, we can figure that the sign of the bias between income of head of household and distance to CBD is positive.
	
*21) I think the coeffecient would increase towards 0 because some of the variane would be explained by the covariance between age and distance to central business district.

*22) 
	regress hwrkyn dist_toCBD s1_age
	*we can see that the 
   
*23)
    keep if hwrkyn!=. & dist_toCBD!=. & s1_age!=.
	regress dist_toCBD s1_age
	predict ehat1, res
* i think this stores the answer as an equation.
*24) 	
	regress hwrkyn ehat1
*------------------
* 2) Data exploration/manipulation
*------------------

* a) the unique command
unique patient_id

* b) labeling variables
label variable height "height of subject"

* c) rename variables
rename emplymnt_status_0unemployed_1for employment
rename num_household_members_other_than num_hh_members

* d) turn variables into binary variables
tab nutrition_support_yn //yuck!

*get rid of spaces at end of some text entries
gen nutrition_support_yn_trim = trim(nutrition_support_yn)
tab nutrition_support_yn nutrition_support_yn_trim, missing

*make a binary variable for nutrition supplements (anything not 'N' is a yes!)
 *note that third line below ensures that missing values stay missing in new variable
gen nutr_sup_yes = 1
replace nutr_sup_yes = 0 if nutrition_support_yn_trim=="N"
replace nutr_sup_yes = . if nutrition_support_yn_trim==""

 *crosscheck
tab nutr_sup_yes nutrition_support_yn_trim

 *make sure to label variables when you make them!
label variable nutr_sup_yes "dummy for nutrition supplements"
drop nutrition_support_yn nutrition_support_yn_trim

* e) destringing!: group variable should be read as a number... but it's not! "bro group" shows that the variable values show up red. Red = Stata thinks its text...
 * first check to make sure some letters aren't actually in the variable values...
tab group, missing
 * all good - this SHOULD be numerical! Let's convert it.
destring group, replace

* f) convert string variable for outcome to be numerical and useful
*tab outcome variable
tab outcome //yuck!
*make a new variable with ALL BLANK VALUES
gen unsuccessful=.
*now define values with replace and if commands
replace unsuccessful=1 if outcome=="D" | outcome=="F" | outcome=="LTFU" | outcome=="TF"
replace unsuccessful=0 if outcome=="C" | outcome=="TC"
*note the | here is an "or"... doing it this way helps save space in the coding!
*make sure to label variables when you make them!
lab var unsuccessful "1=bad,0=good,missing=TO or MD" //note TO is "transferred out" and MD is "misdiagnosed" - we want to omit these folks from any analysis as noted in the paper
*a good sanity check to make sure you didn't make a mistake is below!
tab unsuccessful outcome, missing
*looks good!

* g) order the data - variables now illogically ordered!
order patient_id outcome unsuccessful group

*------------------
* 3) Check randomization
*------------------

* In an experiment, demographics should not differ by condition? Let’s do a check!

ttest num_weight, by(group) unequal
ttest height, by(group) unequal
prtest female, by(group)
ttest female, by(group) unequal //similar but prtest preferred

*can also do this with a regression… [next time!]

*------------------
* 4) Save master dataset
*------------------
saveold "$data/kenya_tb_master", replace//save over the file 

*------------------
* 5) Recreate basic analysis
*------------------

*bar graph stuff
graph bar unsuccessful, over(group)

*kinda ugly... Here's a better way:

preserve
 *preserve is great. Saves the data in memory and lets you bring it back with restore later
 *lets you mess around with data (drop/cut stuff or otherwise manipulate it) but still be able to "bring back" what you had before 

prtest unsuccessful, by(group)
 *gives us the std errors to use in the high and low variable creation below

*first collapse the data to just be mean for each group!
collapse (mean) usuc=unsuccessful, by(group)

*make upper and lower bounds on the standard error around the mean
gen high=.
gen low=.
replace high=usuc+.0145796 if group==0
replace high=usuc+.0084263 if group==1
replace low=usuc-.0145796 if group==0
replace low=usuc-.0084263 if group==1

*make a nicer bar graph
*note: the "///" at the end of each line tells Stata that this line of code continues on the next line!
graph twoway (bar usuc group if group==0) ///
(bar usuc group if group==1) ///
(rcap high low group), legend(off) ///
ytitle("Percent Unsuccessful") ///
yscale(range(0 0.20)) ///
xlabel(0 "Control" 1 "Treatment") ///
ylabel(0 0.05 0.1 0.15 0.2) ///
xtitle("Treatment Condition") ///
title("Unsuccessful Outcome by Treatment")

restore //always remember to preserve first
 *and now we are back to what we had at line 122!


*log close	


