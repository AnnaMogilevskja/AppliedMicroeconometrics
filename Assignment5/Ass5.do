* Applied Microeconometrics - Assignment 5

 use "/Users/julian/Documents/Current/Applied Microeconometrics/GitHub/Assignment5/FlowSpells.dta"
* drop all that are not sick
keep if sptype == 2

*** Question 1
* simple listing of the survivor function
stset splength, failure(dest)
stdes
sts list

* Plot the hazard rate and the survivor function
sts graph, hazard 
graph export "/Users/julian/Documents/Current/Applied Microeconometrics/GitHub/Assignment5/Q1_hazard.png"
sts graph
graph export "/Users/julian/Documents/Current/Applied Microeconometrics/GitHub/Assignment5/Q1_survivor.png"


* Make separate plots for the first two weeks and for the first year
sts graph, tmax(14)
graph export "/Users/julian/Documents/Current/Applied Microeconometrics/GitHub/Assignment5/Q1_survivor14.png"
sts graph, tmax(365)
graph export "/Users/julian/Documents/Current/Applied Microeconometrics/GitHub/Assignment5/Q1_survivor365.png"
sts graph, hazard tmax(14)
graph export "/Users/julian/Documents/Current/Applied Microeconometrics/GitHub/Assignment5/Q1_hazard14.png"
sts graph, hazard tmax(365)
graph export "/Users/julian/Documents/Current/Applied Microeconometrics/GitHub/Assignment5/Q1_hazard365.png"


* Plot the hazard by different subgroups
sts graph, hazard by(gender)
graph export "/Users/julian/Documents/Current/Applied Microeconometrics/GitHub/Assignment5/gender.png"
sts graph, hazard by(marstat)
graph export "/Users/julian/Documents/Current/Applied Microeconometrics/GitHub/Assignment5/marital.png"
sts graph, hazard by(contract)
graph export "/Users/julian/Documents/Current/Applied Microeconometrics/GitHub/Assignment5/contract.png"
sts graph, hazard by(public)
graph export "/Users/julian/Documents/Current/Applied Microeconometrics/GitHub/Assignment5/public.png"
sts graph, hazard by(catholic)
graph export "/Users/julian/Documents/Current/Applied Microeconometrics/GitHub/Assignment5/catholic.png"
sts graph, hazard by(protest)
graph export "/Users/julian/Documents/Current/Applied Microeconometrics/GitHub/Assignment5/protestant.png"
sts graph, hazard by(special)
graph export "/Users/julian/Documents/Current/Applied Microeconometrics/GitHub/Assignment5/special.png"
sts graph, hazard by(urban)
graph export "/Users/julian/Documents/Current/Applied Microeconometrics/GitHub/Assignment5/urban.png"


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

streg gender public special , distribution(exponential) cl(schoolid) nohr
streg gender public special , distribution(weibull) cl(schoolid) nohr
stcurve, hazard 


streg gender public special  classize, distribution(exponential) cl(schoolid) nohr
streg gender public special  classize, distribution(weibull) cl(schoolid) nohr
stcurve, hazard 

streg gender public special  classize teachnr, distribution(exponential) cl(schoolid) nohr
streg gender public special  classize teachnr, distribution(weibull) cl(schoolid) nohr
stcurve, hazard 

streg gender public special  classize teachnr schsize, distribution(exponential) cl(schoolid) nohr
streg gender public special  classize teachnr schsize, distribution(weibull) cl(schoolid) nohr
stcurve, hazard 

streg gender public special  classize teachnr schsize hours, distribution(exponential) cl(schoolid) nohr
streg gender public special  classize teachnr schsize hours, distribution(weibull) cl(schoolid) nohr
stcurve, hazard 

* Weibull for male/female
* https://www.stata.com/manuals/ststreg.pdf

streg public special  classize teachnr schsize hours if gender == 1, distribution(weibull)
streg public special  classize teachnr schsize hours if gender == 2, distribution(weibull)


* Weibull other subgroups

streg gender public  classize teachnr schsize hours if special, distribution(weibull)
streg gender public  classize teachnr schsize hours if !special, distribution(weibull)

streg gender public special  classize teachnr schsize hours if catholic, distribution(weibull)
streg gender public special  classize teachnr schsize hours if !catholic, distribution(weibull)

streg gender public special  classize teachnr schsize hours if protest, distribution(weibull)
streg gender public special  classize teachnr schsize hours if !protest, distribution(weibull)

* PWC
* https://www.stata.com/manuals/ststsplit.pdf
* create new id

gen id = _n

stset splength, id(id) failure(dest)
stsplit sickdur, at(2 30 90) 

generate dur1 = 1 if sickdur == 2
replace dur1 = 0 if missing(dur1)
generate dur2 = 1 if sickdur == 30
replace dur2 = 0 if missing(dur2)
generate dur3 = 1 if sickdur == 90
replace dur3 = 0 if missing(dur3)

streg gender public special classize teachnr schsize hours dur1 dur2 dur3, distribution(exponential) cl(schoolid) nohr
stcurve, survival

stsplit sickdur2, at(2 20 30 40 50 60 70 90 110 130 150 170 190 210 230 250 270 290 310 330) 
generate duur1 = 1 if sickdur2 == 2
replace duur1 = 0 if missing(duur1)
generate duur2 = 1 if sickdur2 == 20
replace duur2 = 0 if missing(duur2)
generate duur3 = 1 if sickdur2 == 30
replace duur3 = 0 if missing(duur3)
generate duur4 = 1 if sickdur2 == 40
replace duur4 = 0 if missing(duur4)
generate duur5 = 1 if sickdur2 == 50
replace duur5 = 0 if missing(duur5)
generate duur6 = 1 if sickdur2 == 60
replace duur6 = 0 if missing(duur6)
generate duur7 = 1 if sickdur2 == 70
replace duur7 = 0 if missing(duur7)
generate duur8 = 1 if sickdur2 == 90
replace duur8 = 0 if missing(duur8)
generate duur9 = 1 if sickdur2 == 110
replace duur9 = 0 if missing(duur9)
generate duur10 = 1 if sickdur2 == 130
replace duur10 = 0 if missing(duur10)
generate duur11 = 1 if sickdur2 == 150
replace duur11 = 0 if missing(duur11)
generate duur12 = 1 if sickdur2 == 170
replace duur12 = 0 if missing(duur12)
generate duur13 = 1 if sickdur2 == 190
replace duur13 = 0 if missing(duur13)
generate duur14 = 1 if sickdur2 == 210
replace duur14 = 0 if missing(duur14)
generate duur15 = 1 if sickdur2 == 230
replace duur15 = 0 if missing(duur15)
generate duur16 = 1 if sickdur2 == 250
replace duur16 = 0 if missing(duur16)
generate duur17 = 1 if sickdur2 == 270
replace duur17 = 0 if missing(duur17)
generate duur18 = 1 if sickdur2 == 290
replace duur18 = 0 if missing(duur18)
generate duur19 = 1 if sickdur2 == 310
replace duur19 = 0 if missing(duur19)
generate duur20 = 1 if sickdur2 == 330
replace duur20 = 0 if missing(duur20)

streg gender public special classize teachnr schsize hours duur1 duur2 duur3 duur4 duur5 duur6 duur7 duur8 duur9 duur10 duur11 duur12 duur13 duur14 duur15 duur16 duur17 duur18 duur19 duur20, distribution(exponential) cl(schoolid) nohr
stcurve, survival

*** Question 3
* Weibull and Exponential Models
streg gender, distribution(exponential) frailty(gamma) cl(schoolid) nohr
streg gender, distribution(weibull) frailty(gamma) cl(schoolid) nohr
stcurve, hazard 

streg gender public, distribution(exponential) frailty(gamma) cl(schoolid) nohr
streg gender public, distribution(weibull) frailty(gamma) cl(schoolid) nohr
stcurve, hazard 

streg gender public special, distribution(exponential) frailty(gamma) cl(schoolid) nohr
streg gender public special, distribution(weibull) frailty(gamma) cl(schoolid) nohr
stcurve, hazard 

streg gender public special classize, distribution(exponential) frailty(gamma) cl(schoolid) nohr
streg gender public special classize, distribution(weibull) frailty(gamma) cl(schoolid) nohr
stcurve, hazard 

streg gender public special classize teachnr, distribution(exponential) frailty(gamma) cl(schoolid) nohr
streg gender public special classize teachnr, distribution(weibull) frailty(gamma) cl(schoolid) nohr
stcurve, hazard 

streg gender public special classize teachnr schsize, distribution(exponential) frailty(gamma) cl(schoolid) nohr
streg gender public special classize teachnr schsize, distribution(weibull) frailty(gamma) cl(schoolid) nohr
stcurve, hazard 

streg gender public special classize teachnr schsize hours, distribution(exponential) frailty(gamma) cl(schoolid) nohr
streg gender public special classize teachnr schsize hours, distribution(weibull) frailty(gamma) cl(schoolid) nohr
stcurve, hazard 

* PWC
streg gender public special classize teachnr schsize hours duur1 duur2 duur3 duur4 duur5 duur6 duur7 duur8 duur9 duur10 duur11 duur12 duur13 duur14 duur15 duur16 duur17 duur18 duur19 duur20, distribution(exponential) cl(schoolid) nohr
stcurve, survival

* Cox
stcox gender public special classize teachnr schsize hours, cl(schoolid) basehc(haz1) nohr
stcurve, hazard

*** Question 4
* Cox


gen str_teachid = string(int(teachid),"%01.0f")
destring str_teachid, replace

* Stratified, School
stcox gender public special classize teachnr schsize hours, strata(schoolid) cl(schoolid) basehc(haz2) nohr

* Stratified, Teach
stcox gender public special classize teachnr schsize hours, strata(str_teachid) cl(schoolid) basehc(haz3) nohr


stcox gender public special classize teachnr schsize hours i.schoolid , cl(schoolid) basehc(haz4) nohr

