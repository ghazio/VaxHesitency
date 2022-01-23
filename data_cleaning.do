*Project Work
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
    global root = "/Users/ghazi/Dropbox/Final_Project_ECON35"
    }
*
*if "`c(username)'" == "tarang" {
*    global root = "/Users/ghazi/Dropbox/ECON35_HW1_Ghazi_Randhawa"
*    }

if "`c(username)'" == "bdboh" {
    global root = "/Users/bdboh/Dropbox/Final_Project_ECON35"
    }


global data = "$root/Data"
global output = "$root/Output"
global logs = "$root/Logs"
	
*------------------
* Import data
*------------------
insheet using "$data/Roper_January.DTA", comma clear


use "$data/Roper_January.DTA", clear

*------------------
* 1.1): We have a look at the different answers to questions of interest
*     
*------------------

*1.1): Vaccine Questions
fre VACC1 
//fre Q11 vaches Q12 Q21 Q23 vacheski Q25 VACHES_2 Q35A Q35B flu

*1.2) Demographic Questions
fre race hispanic income rsex employ age cstate

*1.3) Insurance Questions
fre coverage covtype //covselfo has a very low response rate

*All variables in 1.2 and 1.3 match from February to September, except: 
*	STATE1 is labeled as STATE_NU in April... TODO: rename STATE_NU to STATE1
*	rgender is labeled as rsex in Feb and Jan...


*1.4) Insurance of Differen


* Append monthly data from January to September

gen month="1"

append using "$data/Roper_February.DTA"
replace month="2" if month==""

* force is used here to override a type match error for an irrelevant variable
append using "$data/Roper_March.DTA", force
replace month="3" if month==""

append using "$data/Roper_April.DTA", force
replace month="4" if month==""

append using "$data/Roper_May.DTA", force
replace month="5" if month==""

append using "$data/Roper_June.DTA", force
replace month="6" if month==""

append using "$data/Roper_July.DTA", force
replace month="7" if month==""

append using "$data/Roper_September.DTA", force
replace month="9" if month==""

*------------------
* CLEANING
*------------------

* Create binary variables
gen female = .
	replace female=1 if rsex==2 				| rgender==2
	replace female=0 if rsex==1 | rsex==3 		| rgender==1 | rgender==3
gen white = 0
	replace white=1 if race==1
	replace white=. if race==99
gen black = 0
	replace black=1 if race==2
	replace black=. if race==99
gen asian = 0
	replace asian=1 if race==3
	replace asian=. if race==99

* Convert existing variable 'hispanic' into a binary variable
replace hispanic = . if hispanic==8 | hispanic==9
replace hispanic=1 if hispanic==1
replace hispanic=0 if hispanic==2

* NOTE: here, I lumped a lot of nuance (e.g. part time; retired; student) into 
*	0, i.e. not fully employed. See fre employ.
gen fullemploy = 0
	replace fullemploy=1 if employ==1
	replace fullemploy=. if employ==98 | employ==99

* To distinguish from fullemploy=0, I created a backup variable for people
*	actively seeking employment
gen unemploy = 0
	replace unemploy=1 if employ==3
	replace unemploy=. if employ==98 | employ==99

* Remove 'Refused' and 'I don't know' responses
replace income = . if income==98 | income==99
replace age=. if age==99
	
gen vacc = .
	replace vacc=1 if VACC1==1
	replace vacc=0 if VACC1==2
	
gen insured = .
	replace insured=1 if coverage==1
	replace insured=0 if coverage==2

* I think this may be all we need for separating out public insurance
gen public_ins = .
	replace public_ins=1 if covtype==4 | covtype==5 //Medicare and Medicaid
	replace public_ins=0 if insured==0 //Everyone who has no insurance
	
* NOTE: I considered employer-provided insurance as private. Up for debate
gen private_ins = .
	replace private_ins=1 if covtype<=3 | covtype==7 //Private and employer
	replace private_ins=0 if insured==0 //Everyone who has no insurance
	
	
gen medicaid = 0
	replace public_ins=1 if covtype==5 //Medicaid
	replace public_ins=. if covtype==98 | covtype==99 //Don't know and Refused

	
* Drop unneeded variables	
keep female white black asian hispanic fullemploy unemploy income age cstate ///
		vacc insured public_ins private_ins	month stateexp medicaid
	
save "$data/cleaned.DTA", replace
	
