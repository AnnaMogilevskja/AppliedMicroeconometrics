use "/Users/julian/Documents/Current/Applied Microeconometrics/datadynpan2022.dta"

*ssc install xtabond2
xtset region year
eststo gmm: xtabond2 logquantity logprice logincome logillegal year L(1).logquantity, gmmstyle(L(1).logquantity) ivstyle(logprice logincome logillegal year) nolevel robust

eststo system: xtabond2 logquantity logprice logincome logillegal year L(1).logquantity, gmmstyle(L(1).logquantity) ivstyle(logprice logincome logillegal year) robust 

*eststo twostep: xtabond2 logquantity logprice logincome logillegal year L(1).logquantity, gmmstyle(L(1).logquantity) ivstyle(logprice logincome logillegal year) robust twostep

esttab gmm system using tables_GMM_Robustness_Decades_measure, mtitles("GMM" "System") compress  fonttbl("\f0\fnil Calibri") star( * 0.1 ** 0.05 *** 0.01) replace  

*star(* 0.10 ** 0.05 *** 0.01) ///
*	cells("b(fmt(3)star) margins_b(star)" "se(fmt(3)par)") ///
*	refcat(age18 "\emph{Age}" male "\emph{Demographics}" educationage "\emph{Education}" employeddummy "\emph{Employment}" oowner "\emph{Housing}" hhincome_thou "\emph{Household Finances}" reduntant "\emph{Income and Expenditure Risk}" literacyscore "\emph{Behavioural Characteristics}", nolabel) ///
*	stats(N r2_p chi2 p pr, fmt(0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{S}{@}") labels(`"Observations"' `"Pseudo \(R^{2}\)"' `"LR chi2"' `"Prob > chi2"' `"Baseline predicted probability"'))
	
*xtabond2 logquantity logprice logincome logillegal year L(1).logquantity i.region , gmm(L.remit_capita,  lag(2 4)) iv(L(2).(growth gdp_capita_current_prices  inflation  real_interest  exchange))  nolevel robust small twostep

*eststo gmm: xtabond2 logquantity logprice logincome logillegal year* L(1).logquantity region*

*eststo m1: xtabond2 remit_capita L(1).remit_capita L(0).(growth gdp_capita_current_prices  inflation  real_interest  exchange ) dependency urban population year*, gmm(L.remit_capita,  lag(2 4)) iv(L(2).(growth gdp_capita_current_prices  inflation  real_interest  exchange))  nolevel robust small twostep



*esttab  y80  y90 y00 y10 b3 using tables_GMM_Robustness_Decades_measure , mtitles( "80s" "90s" "00s" "10s" "Full") scalars(F df_m df_r) compress rtf  fonttbl("\f0\fnil Calibri") star( * 0.1 ** 0.05 *** 0.01) replace title(Macroeconomic Determinants) label 
