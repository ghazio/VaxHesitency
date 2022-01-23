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

if "`c(username)'" == "taran" {
	global root = "C:\Users\taran\Dropbox/Final_Project_ECON35"
	}

if "`c(username)'" == "bdboh" {
    global root = "/Users/bdboh/Dropbox/Final_Project_ECON35"
    }
global data = "$root/Data/"
global output = "$root/Output"
global logs = "$root/logs"
	
*------------------
* Import data
*------------------

use "$data/cleaned.DTA", clear

*------------------
* 1.1): EDA
*     
*------------------

*-------------------------------------------
*simple Regression 1.2: (X) Insurance on (Y)vaccination 
*-------------------------------------------

reg vacc insured, r
est store simplest_regression

*-------------------------------------------
*Regression 1.3: (X) Insurance on (Y)vaccination with controls: income, fullemployment, age
*-------------------------------------------
reg vacc insured income fullemploy age, r
est store multi_regression_norace


*-------------------------------------------
*Regression 1.4: (X) Insurance on (Y)vaccination with controls: income, fullemployment, age, race
*-------------------------------------------

*idea for race control: add black and hispanic and add the others as one 'other' variable?
 

reg vacc insured income fullemploy age black hispanic asian, r
est store multi_regression_race

*Store the three regressions
//esttab simplest_regression multi_regression_norace multi_regression_race  using "$output/firstoutputs.rtf", mtitles("Simple Regreesion" "Multilinear regression with income, employment, and age" "Multilinear regression with age income fullemployment and race") stats(N r2 F, labels("Observations" "R-squared" "F-stat"))


*TODO: figure out how to use the fixed effect command, maybe ask bhanot

*-------------------------------------------
*Regression 1.5: Fixed Effects:(X) Insurance on (Y)vaccination with controls: income, fullemployment, age, black, hispanic
*-------------------------------------------
gen insuredblack = insured*black

quietly xi: reg vacc insured income fullemploy age black hispanic asian stateexp insuredblack i.month i.cstate, r
est store fixedeffects
*esttab fixedeffects, keep(insured income age fullemploy black hispanic) stats(N r2 F, labels("Observations" "R-Squared" "F-stat"))


esttab simplest_regression multi_regression_norace multi_regression_race  fixedeffects using "$output/firstoutputs6.rtf", mtitles("Simple Regreesion" "Multilinear regression with income, employment, and age" "Multilinear regression with age income fullemployment and race" "Multilinear regression with fixed effects") keep(insured income age fullemploy black hispanic asian insuredblack stateexp) stats(N r2 F, labels("Observations" "R-squared" "F-stat"))


*-------------------------------------------
*Regression 1.5: Public and Private Fixed Effects:(X) Insurance on (Y)vaccination with controls: income, fullemployment, age, black, hispanic
*-------------------------------------------

quietly xi: reg vacc public_ins income fullemploy age black hispanic asian stateexp insuredblack i.month i.cstate, r
est store publicfe

quietly xi: reg vacc private_ins income fullemploy age black hispanic asian stateexp insuredblack i.month i.cstate, r
est store privatefe

esttab publicfe privatefe using "$output/publicoutputs1.rtf", mtitles("Multilinear regression on public insurance with fixed effects" "Multilinear regression on private insurance with fixed effect") keep(public_ins private_ins income age fullemploy black hispanic asian insuredblack stateexp) stats(N r2 F, labels("Observations" "R-squared" "F-stat"))





*TODO: Internation effects


*----------------------|
*Logistic   Regressions|
*----------------------|

logit vacc insured
est store simplest_regression_logit

logit vacc insured i.income fullemploy age
est store multinorace_logit


logit vacc insured i.income fullemploy age black asian hispanic
est store multiwithrace_logit


esttab simplest_regression_logit multinorace_logit multiwithrace_logit using "$output/secondoutputs.rtf", mtitles("Simple logistic regression" "Multilinear logistic regression with income fixed effects, employment, and age" "Multilinear logistic regression with income fixed effects, age, fullemployment, and race") keep(insured fullemploy age black asian hispanic) stats(N r2 F, labels("Observations" "R-squared" "F-stat"))













