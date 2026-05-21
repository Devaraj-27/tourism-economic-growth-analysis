****************************************************
* TOURISM AND ECONOMIC GROWTH PANEL ANALYSIS
* Author: DEVARAJ NAGARAJAN
****************************************************
clear all
set more off
****************************************************
* 1. SET WORKING DIRECTORY
****************************************************
cd "C:\Users\aarth\OneDrive\Desktop\Tourism Project UNOM"
****************************************************
* 2. LOAD DATA
****************************************************
import excel "C:\Users\aarth\OneDrive\Desktop\Tourism Project Excel\Data\Master Dataset .xlsx", sheet("Dataset") firstrow
****************************************************
* 3. START LOG FILE
****************************************************
log using "C:\Users\aarth\OneDrive\Desktop\Tourism Project UNOM\Project Codes.smcl", replace
****************************************************
* 4. DECLARE PANEL STRUCTURE
****************************************************
xtset StateID Year
xtdescribe
****************************************************
* 5. GENERATE LOG VARIABLES
****************************************************
gen ln_gsdp      = ln(GSDPConstantLakh)
gen ln_fta       = ln(FTA)
gen ln_dtv       = ln(DTV)
gen ln_pop       = ln(StatePopulation)
gen ln_cap_out   = ln(TotalCapitalOutlayLakh)
****************************************************
* 6. DESCRIPTIVE STATISTICS
****************************************************
summarize ln_gsdp ln_fta ln_dtv ln_pop ln_cap_out 
****************************************************
* 7. CORRELATION MATRIX
****************************************************
pwcorr ln_fta ln_dtv ln_pop ln_cap_out , sig star(0.05)
****************************************************
* 8. POOLED OLS MODEL
***************************************************
reg ln_gsdp ln_fta ln_dtv ln_pop ln_cap_out  
*****************************************************
* 9.MULTICOLLINEARITY TEST
****************************************************
vif
****************************************************
* 10. HETEROSKEDASTICITY TEST (OLS)
****************************************************
estat hettest
****************************************************
* 11. PANEL UNIT ROOT TEST (IPS)
****************************************************
xtunitroot ips ln_gsdp
xtunitroot ips ln_fta
xtunitroot ips ln_dtv
xtunitroot ips ln_pop
xtunitroot ips ln_cap_out
****************************************************
* 12. PANEL COINTEGRATION TEST
****************************************************
xtcointtest kao ln_gsdp ln_fta ln_dtv ln_pop ln_cap_out
****************************************************
* 13. FIXED EFFECTS MODEL
****************************************************
xtreg ln_gsdp ln_fta ln_dtv ln_pop ln_cap_out , fe
est store fe
****************************************************
* 14. RANDOM EFFECTS MODEL
****************************************************
xtreg ln_gsdp ln_fta ln_dtv ln_pop ln_cap_out , re
est store re
****************************************************
* 15. HAUSMAN TEST
****************************************************
hausman fe re, sigmamore
****************************************************
* 16. CROSS-SECTION DEPENDENCE TEST
****************************************************
xtcsd, pesaran abs
****************************************************
* 17. PANEL HETEROSKEDASTICITY TEST
****************************************************

xtreg ln_gsdp ln_fta ln_dtv ln_pop ln_cap_out , fe
xttest3

****************************************************
* 18. INSTALL DRISCOLL-KRAAY
****************************************************

capture ssc install xtscc

****************************************************
* 19. FINAL MODEL
****************************************************

xtscc ln_gsdp ln_fta ln_dtv ln_pop ln_cap_out , fe
est store dk

****************************************************
* 20. EXPORT REGRESSION TABLE
****************************************************

capture ssc install estout

esttab fe re dk using regression_results.rtf, replace ///
    se star(* 0.10 ** 0.05 *** 0.01) label