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


legend(order(1 "`: var label mpg'" 2 "`: var label rep78'"))

graph hbar (count), ///
over(vacc,label(labsize(small))) ///
over(month, label(labsize(small)) relabel(`r(relabel)')) ///
ytitle("Number of Respondents", size(small)) ///
title("Vaccination by income" ///
, span size(medium)) ///
blabel(bar) ///
intensity(25) legend(order(1 `: var label January'" 2 "`: var label February'" 3 " `: var label January'" 5 " `: var label January'" 6 " `: var label January'" 7 " `: var label January'"8" `: var label January' "9" `: var label January' ))
