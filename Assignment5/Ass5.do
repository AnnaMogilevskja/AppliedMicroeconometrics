* Applied Microeconometrics - Assignment 5

use "C:/Users/Anna/OneDrive/Dokumente/Tinbergen/TI_Year2/TI_2022_B1/AppliedMicroeconometrics/FlowSpells.dta"

* drop all that are not sick
keep if sptype == 2

*** Question 1
* simple listing of the survivor function
stset splength, failure(dest)
stdes
sts list

* Plot the hazard rate and the survivor function
sts graph, hazard 
sts graph

* Make separate plots for the first two weeks and for the first year
sts graph, tmax(14)
sts graph, tmax(365)
sts graph, hazard tmax(14)
sts graph, hazard tmax(365)

* Plot the hazard by different subgroups
sts graph, hazard by(gender)
sts graph, hazard by(marstat)
sts graph, hazard by(contract)
sts graph, hazard by(public)
sts graph, hazard by(catholic)
sts graph, hazard by(protest)
sts graph, hazard by(special)
sts graph, hazard by(urban)

* Test whether the survival curves are the same for the different subgroups
* https://stats.oarc.ucla.edu/stata/seminars/stata-survival/
* For the categorical variables we will use the log-rank test of equality across strata which is a non-parametric test. 
* For the continuous variables we will use a univariate Cox proportional hazard regression which is a semi-parametric model. 
* We will consider including the predictor if the test has a p-value of 0.2 – 0.25 or less.

* Categorial Variables
sts test gender, logrank 
* include gender
sts test marstat, logrank
* include marstat
sts test contract, logrank
* icnlude contract
sts test public, logrank
* include public
sts test catholic, logrank
* include catholic
sts test protest, logrank
* include protest
sts test special, logrank
* include special
sts test urban, logrank
* include urban
sts test lowgroup, logrank
* include lowgroup
sts test province, logrank
* include province
sts test merged, logrank
* include merged

* Continuous Variables
stcox birthyr, nohr
* include birthyr
stcox hours, nohr
* include hours
stcox classize, nohr
* include classize
stcox schsize, nohr
* include schsize
stcox teachnr, nohr
* include teachnr
stcox avgfem, nohr
* include avgfem
stcox avgage, nohr
* include avgage
stcox avglowgr, nohr
* include avglowgr
stcox avgten, nohr
* include avgten
stcox avgmar, nohr
* do not include avgmar
stcox avgclass, nohr
* include avgclass

*** Question 2
* Weibull and Exponential
generate married = 1 if marstat == 2
generate fixed = 1 if contract == 1
generate half = 1 if contract == 3
generate city = 1 if urban > 3

streg gender, distribution(exponential) cl(schoolid) nohr
streg gender, distribution(weibull) cl(schoolid) nohr
stcurve, hazard 

streg gender public, distribution(exponential) cl(schoolid) nohr
streg gender public, distribution(weibull) cl(schoolid) nohr
stcurve, hazard 

streg gender public special, distribution(exponential) cl(schoolid) nohr
streg gender public special, distribution(weibull) cl(schoolid) nohr
stcurve, hazard 

streg gender public special city, distribution(exponential) cl(schoolid) nohr
streg gender public special city, distribution(weibull) cl(schoolid) nohr
stcurve, hazard 


streg gender public special city classize, distribution(exponential) cl(schoolid) nohr
streg gender public special city classsize, distribution(weibull) cl(schoolid) nohr
stcurve, hazard 

streg gender public special city classize teachnr, distribution(exponential) cl(schoolid) nohr
streg gender public special city classsize teachnr, distribution(weibull) cl(schoolid) nohr
stcurve, hazard 

streg gender public special city classize teachnr schsize, distribution(exponential) cl(schoolid) nohr
streg gender public special city classize teachnr schsize, distribution(weibull) cl(schoolid) nohr
stcurve, hazard 

streg gender public special city classize teachnr schsize hours, distribution(exponential) cl(schoolid) nohr
streg gender public special city classize teachnr schsize hours, distribution(weibull) cl(schoolid) nohr
stcurve, hazard 

* Weibull for male/female
* https://www.stata.com/manuals/ststreg.pdf

streg public special city classize teachnr schsize hours, distribution(weibull) ancillary(gender)

streg public special city classize teachnr schsize hours if gender == 1, distribution(weibull)
streg public special city classize teachnr schsize hours if gender == 2, distribution(weibull)


* Weibull other subgroups

streg gender public city classize teachnr schsize hours if special, distribution(weibull)
streg gender public city classize teachnr schsize hours if !special, distribution(weibull)

streg gender public special city classize teachnr schsize hours if catholic, distribution(weibull)
streg gender public special city classize teachnr schsize hours if !catholic, distribution(weibull)

streg gender public special city classize teachnr schsize hours if protest, distribution(weibull)
streg gender public special city classize teachnr schsize hours if !protest, distribution(weibull)

* PWC
* https://www.stata.com/manuals/ststsplit.pdf
* create new id
gen str_schoolid = string(int(schoolid),"%01.0f") // %02.0f because 'country' is two digits
gen str_teachid = string(int(teachid),"%01.0f")
egen uniqueid = concat(str_schoolid str_teachid)
destring uniqueid, replace


stset splength, id(uniqueid) failure(dest)
stsplit sickdur, at(2 30 90) 

generate dur1 = 1 if sickdur == 2
generate dur2 = 1 if sickdur == 30
generate dur3 = 1 if sickdur == 90

* does not work yet
streg gender public special city classize teachnr schsize hours dur1 dur2, distribution(exponential) cl(schoolid) nohr
