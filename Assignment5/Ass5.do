* Applied Microeconometrics - Assignment 5
drop _all
use "C:/Users/Anna/Documents/GitHub/AppliedMicroeconometrics/Assignment5/FlowSpells.dta"
* drop all that are not sick
keep if sptype == 2

*** Question 1
* simple listing of the survivor function
stset splength, failure(dest)
stdes
sts list

* Plot the hazard rate and the survivor function
sts graph, hazard 
graph export "C:/Users/Anna/Documents/GitHub/AppliedMicroeconometrics/Assignment5/Q1_hazard.png"
sts graph
graph export "C:/Users/Anna/Documents/GitHub/AppliedMicroeconometrics/Assignment5/Q1_survivor.png"


* Make separate plots for the first two weeks and for the first year
sts graph, tmax(14)
graph export "C:/Users/Anna/Documents/GitHub/AppliedMicroeconometrics/Assignment5/Q1_survivor14.png"
sts graph, tmax(365)
graph export "C:/Users/Anna/Documents/GitHub/AppliedMicroeconometrics/Assignment5/Q1_survivor365.png"
sts graph, hazard tmax(14) width(1) noboundary
graph export "C:/Users/Anna/Documents/GitHub/AppliedMicroeconometrics/Assignment5/Q1_hazard14.png"
sts graph, hazard tmax(365)
graph export "C:/Users/Anna/Documents/GitHub/AppliedMicroeconometrics/Assignment5/Q1_hazard365.png"


* Plot the hazard by different subgroups
sts graph, hazard by(gender)
graph export "C:/Users/Anna/Documents/GitHub/AppliedMicroeconometrics/Assignment5/gender.png"
sts graph, hazard by(marstat)
graph export "C:/Users/Anna/Documents/GitHub/AppliedMicroeconometrics/Assignment5/marital.png"
sts graph, hazard by(contract)
graph export "C:/Users/Anna/Documents/GitHub/AppliedMicroeconometrics/Assignment5/contract.png"
sts graph, hazard by(public)
graph export "C:/Users/Anna/Documents/GitHub/AppliedMicroeconometrics/Assignment5/public.png"
sts graph, hazard by(catholic)
graph export "C:/Users/Anna/Documents/GitHub/AppliedMicroeconometrics/Assignment5/catholic.png"
sts graph, hazard by(protest)
graph export "C:/Users/Anna/Documents/GitHub/AppliedMicroeconometrics/Assignment5/protestant.png"
sts graph, hazard by(special)
graph export "C:/Users/Anna/Documents/GitHub/AppliedMicroeconometrics/Assignment5/special.png"
sts graph, hazard by(urban)
graph export "C:/Users/Anna/Documents/GitHub/AppliedMicroeconometrics/Assignment5/urban.png"


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
replace married = 0 if marstat != 2
generate fixed = 1 if contract == 1
replace fixed = 0 if contract != 1
generate half = 1 if contract == 3
generate city = 1 if urban > 3

stset splength, failure(dest)
eststo e1: streg gender, distribution(exponential) cl(schoolid) nohr
eststo w1: streg gender, distribution(weibull) cl(schoolid) nohr
stcurve, hazard 

eststo e2: streg gender married, distribution(exponential) cl(schoolid) nohr
eststo w2: streg gender married, distribution(weibull) cl(schoolid) nohr
stcurve, hazard 

eststo e3: streg gender married hours lowgroup, distribution(exponential) cl(schoolid) nohr
eststo w3: streg gender married hours lowgroup, distribution(weibull) cl(schoolid) nohr
stcurve, hazard 

eststo e4: streg gender married hours lowgroup classize schsize teachnr, distribution(exponential) cl(schoolid) nohr
eststo w4: streg gender married hours lowgroup classize schsize teachnr, distribution(weibull) cl(schoolid) nohr
stcurve, hazard 

eststo e5: streg gender married hours lowgroup classize schsize teachnr public catholic protest special, distribution(exponential) cl(schoolid) nohr
eststo w5: streg gender married hours lowgroup classize schsize teachnr public catholic protest special, distribution(weibull) cl(schoolid) nohr
stcurve, hazard 

eststo e6: streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban , distribution(exponential) cl(schoolid) nohr
eststo w6: streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban , distribution(weibull) cl(schoolid) nohr
stcurve, hazard 

eststo e7: streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban  merged avgfem avgage avgten avgmar, distribution(exponential) cl(schoolid) nohr
eststo w7: streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban  merged avgfem avgage avgten avgmar, distribution(weibull) cl(schoolid) nohr
stcurve, hazard 

esttab e1 e2 e3 e4 e5 e6 e7 , compress   fonttbl("\f0\fnil Calibri") star( * 0.1 ** 0.05 *** 0.01) replace title(Exponential) label p
esttab e1 e2 e3 e4 e5 e6 e7 using "exponential.tex", replace se starlevels(* 0.1 ** 0.05 *** 0.01) title("Exponential Model") obslast
esttab w1 w2 w3 w4 w5 w6 w7 , compress   fonttbl("\f0\fnil Calibri") star( * 0.1 ** 0.05 *** 0.01) replace title(Weilbull) label p
esttab w1 w2 w3 w4 w5 w6 w7 using "weibull.tex", replace se starlevels(* 0.1 ** 0.05 *** 0.01) title("Weibull Model") scalars(aux_p) obslast
* Weibull for male/female
* https://www.stata.com/manuals/ststreg.pdf
stset splength, failure(dest)
eststo g1:streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban  merged avgfem avgage avgten avgmar if gender == 1, distribution(weibull)
eststo g2:streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban province merged avgfem avgage avgten avgmar if gender == 2, distribution(weibull)


* Weibull other subgroups
stset splength, failure(dest)
eststo s1:streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban  merged avgfem avgage avgten avgmar if special, distribution(weibull)
eststo s2:streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban province merged avgfem avgage avgten avgmar if !special, distribution(weibull)

eststo c1:streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban  merged avgfem avgage avgten avgmar if catholic, distribution(weibull)
eststo c2:streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban  merged avgfem avgage avgten avgmar if !catholic, distribution(weibull)

eststo p1:streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban  merged avgfem avgage avgten avgmar if protest, distribution(weibull)
eststo p2:streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban  merged avgfem avgage avgten avgmar if !protest, distribution(weibull)

esttab g1 g2 s1 s2 c1 c2 p1 p2 , compress   fonttbl("\f0\fnil Calibri") star( * 0.1 ** 0.05 *** 0.01) replace title(Weibull Subgroups) label p mtitles("Male" "Female" "Sepcial" "Not Sepcial" "catholic""Not Catholic" "Protestant""Not Protestant")
esttab g1 g2 s1 s2 c1 c2 p1 p2 using "weibullsoubgroups.tex", replace se starlevels(* 0.1 ** 0.05 *** 0.01) title("Weibull Subgroups") mtitles("Male" "Female" "Sepcial" "Not Sepcial" "catholic""Not Catholic" "Protestant""Not Protestant") scalars(aux_p) obslast
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

eststo q1: streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban  merged avgfem avgage avgten avgmar i.sickdur, distribution(exponential) cl(schoolid) nohr
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

eststo q2:streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban  merged avgfem avgage avgten avgmar i.sickdur2, distribution(exponential) cl(schoolid) nohr
stcurve, survival

esttab q1 q2 w7, compress   fonttbl("\f0\fnil Calibri") star( * 0.1 ** 0.05 *** 0.01) replace title(Exponential) label p mtitles("PWC - 3" "PWC - 20" "Weibull" )
esttab q1 q2 w7 using "pwc.tex", replace se starlevels(* 0.1 * 0.05 ** 0.01) title("PWC Model") mtitles("PWC - 3" "PWC - 20" "Weibull" ) scalars(aux_p) obslast
*** reloading of data as otherwise Weilbull does not converge after running the code of PWC
drop _all
use "C:/Users/Anna/Documents/GitHub/AppliedMicroeconometrics/Assignment5/FlowSpells.dta"
* drop all that are not sick
keep if sptype == 2

generate married = 1 if marstat == 2
replace married = 0 if marstat != 2
generate fixed = 1 if contract == 1
replace fixed = 0 if contract != 1
generate half = 1 if contract == 3
generate city = 1 if urban > 3

*** Question 3
* Weibull and Exponential Models
stset splength, failure(dest)
*eststo ea1: streg gender, distribution(exponential) cl(schoolid) nohr frailty(gamma)
eststo wa1: streg gender, distribution(weibull) cl(schoolid) nohr frailty(gamma)
stcurve, hazard 

*eststo ea2: streg gender married, distribution(exponential) cl(schoolid) nohr frailty(gamma)
eststo wa2: streg gender married, distribution(weibull) cl(schoolid) nohr frailty(gamma)
stcurve, hazard 

*eststo ea3: streg gender married hours lowgroup, distribution(exponential) cl(schoolid) nohr frailty(gamma)
eststo wa3: streg gender married hours lowgroup, distribution(weibull) cl(schoolid) nohr frailty(gamma)
stcurve, hazard 

*ststo ea4: streg gender married hours lowgroup classize schsize teachnr, distribution(exponential) cl(schoolid) nohr frailty(gamma)
eststo wa4: streg gender married hours lowgroup classize schsize teachnr, distribution(weibull) cl(schoolid) nohr frailty(gamma)
stcurve, hazard 

*ststo ea5: streg gender married hours lowgroup classize schsize teachnr public catholic protest special, distribution(exponential) cl(schoolid) nohr frailty(gamma)
eststo wa5: streg gender married hours lowgroup classize schsize teachnr public catholic protest special, distribution(weibull) cl(schoolid) nohr frailty(gamma)
stcurve, hazard 

*ststo ea6: streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban , distribution(exponential) cl(schoolid) nohr frailty(gamma)
eststo wa6: streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban , distribution(weibull) cl(schoolid) nohr frailty(gamma)
stcurve, hazard 

*ststo ea7: streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban  merged avgfem avgage avgten avgmar, distribution(exponential) cl(schoolid) nohr frailty(gamma)
eststo wa7: streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban  merged avgfem avgage avgten avgmar, distribution(weibull) cl(schoolid) nohr frailty(gamma)
stcurve, hazard 

eststo w7: streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban  merged avgfem avgage avgten avgmar, distribution(weibull) cl(schoolid) nohr


*esttab ea* , compress   fonttbl("\f0\fnil Calibri") star( * 0.1 ** 0.05 *** 0.01) replace title(Exponential - Unobserved) label p

esttab wa* , compress   fonttbl("\f0\fnil Calibri") star( * 0.1 ** 0.05 *** 0.01) replace title(Weibull Unobserved) label p
esttab wa* using "weibullgamma.tex", replace se starlevels(* 0.1 ** 0.05 *** 0.01) title("Weibull Unobserved") scalars(aux_p) obslast

* PWC
gen id = _n
stset splength, id(id) failure(dest)

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

eststo c1: streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban  merged avgfem avgage avgten avgmar i.sickdur2, distribution(exponential) cl(schoolid) nohr frailty(gamma)

eststo q2:streg gender married hours lowgroup classize schsize teachnr public catholic protest special urban  merged avgfem avgage avgten avgmar i.sickdur2, distribution(exponential) cl(schoolid) nohr


* Cox
stset splength, failure(dest)
eststo x2: stcox gender married hours lowgroup classize schsize teachnr public catholic protest special urban  merged avgfem avgage avgten avgmar, cl(schoolid) basehc(haz1) nohr


esttab w7 wa7 q2 c1 x2, compress   fonttbl("\f0\fnil Calibri") star( * 0.1 ** 0.05 *** 0.01) replace title(Exponential) label p mtitles("Weibull - None" "Weibull - Unobserved Heterogeneity" "PWC - _None" "PWC - Unobserved Heterogeneity" "Cox")

esttab w7 wa7 q2 c1 x2 using "comparison.tex", replace se starlevels(* 0.1 ** 0.05 *** 0.01) title("Comparison") mtitles("Weibull - None" "Weibull - Unobserved Heterogeneity" "PWC - _None" "PWC - Unobserved Heterogeneity" "Cox") scalars(aux_p) obslast

*** Question 4
** Stratified Cox
stset splength, failure(dest)
gen str_teachid = string(int(teachid),"%01.0f")
destring str_teachid, replace

* Stratified, School
stcox  gender married hours lowgroup classize schsize teachnr public catholic protest special urban  merged avgfem avgage avgten avgmar, strata(schoolid) cl(schoolid) basehc(haz2) nohr

* Stratified, Teach
stcox  gender married hours lowgroup classize schsize teachnr public catholic protest special urban  merged avgfem avgage avgten avgmar, strata(str_teachid) cl(schoolid) basehc(haz3) nohr

* School ID
stcox  gender married hours lowgroup classize schsize teachnr public catholic protest special urban  merged avgfem avgage avgten avgmar i.schoolid , cl(schoolid) basehc(haz4) nohr


