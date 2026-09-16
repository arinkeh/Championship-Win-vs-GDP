global main "/Users/haleematoloyo/Downloads/ECON310_S2026/final_project"

use "$main/project_data/gdp_win_nfl.dta", clear

drop in 1

rename A year
rename B bmorewinrt
rename C pittswinrt
rename D neworlwinrt
rename E bmorepci
rename F pittspci
rename G neworlpci


destring, replace

twoway (scatter bmorepci bmorewinrt) (lfit bmorepci bmorewinrt)
graph export "bmorepciwinrt.png", replace

twoway (scatter pittspci pittswinrt) (lfit pittspci pittswinrt)
graph export "pittspciwinrt.png", replace

twoway (scatter neworlpci neworlwinrt) (lfit neworlpci neworlwinrt)
graph export "neworlpciwinrt.png", replace

regress bmorepci bmorewinrt

regress pittspci pittswinrt

regress neworlpci neworlwinrt



use "$main/project_data/pce_by_states.dta", clear

*tell stata that state_id identifies each state and year identifies the time period
xtset state_id year

*to obtain scatterplot Y vs X1
twoway scatter rec_pce_pctchange nfl_win, jitter(5) title("Recreational PCE Growth vs NFL Win") xtitle("NFL Win (0=No, 1=Yes)") ytitle("Recreational PCE % Change")
graph export "pce_vs_nfl_win.png"

*to obtain scatterplot Y vs X2
twoway scatter rec_pce_pctchange personal_income_millions, title("Recreational PCE Growth vs Personal Income") xtitle("Personal Income (Millions $)") ytitle("Recreational PCE % Change")
graph export "pce_vs_pi.png"

*simple regression Y and X1
reg rec_pce_pctchange nfl_win

*simple regresion Y and X2
reg rec_pce_pctchange personal_income_millions

*multiple regression Y and X1 and X2
reg rec_pce_pctchange nfl_win personal_income_millions i.year

*to see correlation between Y X1 X2
pwcorr rec_pce_pctchange nfl_win personal_income_millions



use "$main/project_data/bmore_gdp_growth.dta", clear
append using "neworl_gdp_growth.dta"

tab city

twoway (line growth year if city=="Baltimore") (line growth year if city=="New Orleans"), xline(2013) title("Real GDP Growth Before and After the 2013 Super Bowl") subtitle("Baltimore won; New Orleans hosted") ytitle("Real GDP Growth (%)") xtitle("Year") legend(label(1 "Baltimore") label(2 "New Orleans"))
graph export "bmorevsneworl_gdp_growth.png",replace



use "$main/project_data/mar_stocks.dta", clear

drop in 3

destring open volume, replace ignore(",")

gen date2 = daily(date, "DM20Y")
format date2 %td
drop date
rename date2 date
tsset date

gen mar_return = (close - L.close)/L.close
gen volatility = high - low
gen event_day = daily("03feb2013","DMY")
gen days_from_event = date - event_day
gen post = days_from_event > 0
gen event_window = abs(days_from_event) <= 5

label define postlbl 0 "Pre-SB" 1 "Post-SB"
label values post postlbl

summarize mar_return volume volatility

ttest mar_return, by(post)
ttest volume, by(post)
ttest volatility, by(post)

ttest mar_return if event_window==1, by(post)
ttest volume if event_window==1, by(post)
ttest volatility if event_window==1, by(post)

reg mar_return post volume volatility
reg volatility post volume

twoway (line mar_return date if post==0, lcolor(navy)) (line mar_return date if post==1, lcolor(cranberry)), xline(19391, lcolor(black) lpattern(dash)) title("Daily MAR Returns") xtitle("Date") ytitle("Daily Return") yline(0, lcolor(gs10) lpattern(dot)) legend(order(1 "Pre-SB" 2 "Post-SB") pos(6) row(1)) name(g1, replace)
graph export "MAR_Chart1.png", replace

twoway (bar volume date if post==0, fcolor(navy%60) lcolor(none)) (bar volume date if post==1, fcolor(cranberry%60) lcolor(none)), xline(19391, lcolor(black) lpattern(dash)) title("MAR Trading Volume") xtitle("Date") ytitle("Volume (shares)") legend(order(1 "Pre-SB" 2 "Post-SB") pos(6) row(1)) name(g2, replace)
graph export "MAR_Chart2.png", replace

twoway (line volatility date if post==0, lcolor(navy)) (line volatility date if post==1, lcolor(cranberry)), xline(19391, lcolor(black) lpattern(dash)) title("MAR Intraday Volatility") xtitle("Date") ytitle("Volatility (High - Low)") legend(order(1 "Pre-SB" 2 "Post-SB") pos(6) row(1)) name(g3, replace)
graph export "MAR_Chart3.png", replace

graph box volatility, over(post) title("MAR Volatility: Pre vs Post Super Bowl") ytitle("Volatility (High - Low)") note("t-test: p = 0.015 (significant)") name(g4, replace)
graph export "MAR_Chart4.png", replace

graph box mar_return, over(post) title("MAR Returns: Pre vs Post Super Bowl") ytitle("Daily Return") note("t-test: p = 0.955 (not significant)") name(g5, replace)
graph export "MAR_Chart5.png", replace

twoway (scatter mar_return volatility if post==0, mcolor(navy%70) msymbol(circle)) (scatter mar_return volatility if post==1, mcolor(cranberry%70) msymbol(triangle)), title("MAR Returns vs Volatility") xtitle("Volatility (High - Low)") ytitle("Daily Return") yline(0, lcolor(gs10) lpattern(dot)) legend(order(1 "Pre-SB" 2 "Post-SB") pos(6) row(1)) name(g6, replace)
graph export "MAR_Chart6.png", replace



use "$main/project_data/luv_stocks.dta", clear

destring volume, replace ignore(",")
gen date2 = daily(date, "DM20Y")
format date2 %td
drop date
rename date2 date
tsset date

gen luv_return = (close - L.close)/L.close
gen volatility = high - low
gen event_day = daily("03feb2013","DMY")
gen days_from_event = date - event_day
gen post = days_from_event > 0
gen event_window = abs(days_from_event) <= 5

label define postlbl 0 "Pre-SB" 1 "Post-SB"
label values post postlbl

summarize luv_return volume volatility

ttest luv_return, by(post)
ttest volume, by(post)
ttest volatility, by(post)

ttest luv_return if event_window==1, by(post)
ttest volume if event_window==1, by(post)
ttest volatility if event_window==1, by(post)

reg luv_return post volume volatility
reg volatility post volume

twoway (line luv_return date if post==0, lcolor(navy)) (line luv_return date if post==1, lcolor(cranberry)), xline(19391, lcolor(black) lpattern(dash)) title("Daily LUV Returns") xtitle("Date") ytitle("Daily Return") yline(0, lcolor(gs10) lpattern(dot)) legend(order(1 "Pre-SB" 2 "Post-SB") pos(6) row(1)) name(g1, replace)
graph export "LUV_Chart1.png", replace

twoway (bar volume date if post==0, fcolor(navy%60) lcolor(none)) (bar volume date if post==1, fcolor(cranberry%60) lcolor(none)), xline(19391, lcolor(black) lpattern(dash)) title("LUV Trading Volume") xtitle("Date") ytitle("Volume (shares)") legend(order(1 "Pre-SB" 2 "Post-SB") pos(6) row(1)) name(g2, replace)
graph export "LUV_Chart2.png", replace

twoway (line volatility date if post==0, lcolor(navy)) (line volatility date if post==1, lcolor(cranberry)), xline(19391, lcolor(black) lpattern(dash)) title("LUV Intraday Volatility") xtitle("Date") ytitle("Volatility (High - Low)") legend(order(1 "Pre-SB" 2 "Post-SB") pos(6) row(1)) name(g3, replace)
graph export "LUV_Chart3.png", replace

graph box volatility, over(post) title("LUV Volatility: Pre vs Post Super Bowl") ytitle("Volatility (High - Low)") note("t-test: p = 0.918 (not significant)") name(g4, replace)
graph export "LUV_Chart4.png", replace

graph box luv_return, over(post) title("LUV Returns: Pre vs Post Super Bowl") ytitle("Daily Return") note("t-test: p = 0.488 (not significant)") name(g5, replace)
graph export "LUV_Chart5.png", replace

twoway (scatter luv_return volatility if post==0, mcolor(navy%70) msymbol(circle)) (scatter luv_return volatility if post==1, mcolor(cranberry%70) msymbol(triangle)), title("LUV Returns vs Volatility") xtitle("Volatility (High - Low)") ytitle("Daily Return") yline(0, lcolor(gs10) lpattern(dot)) legend(order(1 "Pre-SB" 2 "Post-SB") pos(6) row(1)) name(g6, replace)
graph export "LUV_Chart6.png", replace


