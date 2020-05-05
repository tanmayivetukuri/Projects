

*Generating log variable*
generate lvio=ln(vio)
generate lincarc_rate=ln(incarc_rate)
generate ldensity=ln(density)
generate lmur=ln(mur)
generate lrob=ln(rob)

*lincarc_rate vs lvio
gen lincarc_rate = ln(incarc_rate)
reg lvio lincarc_rate
twoway (scatter lvio lincarc_rate, sort) (line xb lincarc_rate )

*Population density vs violence
drop xb
reg lvio ldensity
predict xb
twoway (scatter lvio ldensity, sort) (line xb ldensity)

*Pop vs violence rate
drop xb
reg lvio pop
predict xb
twoway (scatter lvio pop, sort) (line xb pop)

*Violent crime rate Vs % of white population

drop xb
reg lvio pw1064
predict xb
twoway (scatter lvio pw1064, sort) (line xb pw1064)

*Violent crime rate Vs % of black population

drop xb
reg lvio pb1064
predict xb
twoway (scatter lvio pb1064, sort) (line xb pb1064)

*Violent crime rate Vs avginc

drop xb
reg lvio avginc
predict xb
twoway (scatter lvio avginc, sort) (line xb avginc)

*Violent crime rate Vs pm1029
drop xb
reg lvio pm1029
predict xb
twoway (scatter lvio pm1029, sort) (line xb pm1029)


*Hypothesis testing on shall law*
ttest vio, by(shall) unequal
ttest mur, by(shall) unequal
ttest rob, by(shall) unequal
ttest incarc_rate, by(shall) unequal

*Histogram plot*
histogram vio
histogram incarc_rate
histogram density
histogram mur
histogram rob

*Correlation matrix*
corr vio mur rob incarc_rate pb1064 pw1064 pm1029 pop avginc density

*Residual plot for lincarc_rate*
reg lvio lincarc_rate
predict ehat, res

graph twoway scatter ehat lincarc_rate, yline(0)

*Pooled OLS*
reg lvio lincarc_rate pb1064 pw1064 pm1029 pop avginc ldensity shall, vce(cluster stateid)
test pb1064 pw1064

*Pooled OLS without pb1064 pw1064*
reg lvio lincarc_rate pm1029 pop avginc ldensity shall, vce(cluster stateid)

*Fixed Effects model*
xtset stateid year
xtreg lvio lincarc_rate pb1064 pw1064 pm1029 pop avginc ldensity shall, fe vce(cluster stateid)

*Random Effects model*
xtset stateid year
xtreg lvio lincarc_rate pb1064 pw1064 pm1029 pop avginc ldensity shall, re vce(cluster stateid)

*Hausman Test*
quietly xtreg lvio lincarc_rate pb1064 pw1064 pm1029 pop avginc ldensity shall, fe
estimates store fi

quietly xtreg lvio lincarc_rate pb1064 pw1064 pm1029 pop avginc ldensity shall, re
estimates store ra

hausman fi ra, sigmamore

*Fixed effects with time and entity fixed*
xtreg lvio lincarc_rate pb1064 pw1064 pm1029 pop avginc ldensity shall i.year, fe vce(cluster stateid)
testparm i.year

*Fixed effect on murder rate*
xtreg lmur lincarc_rate pb1064 pw1064 pm1029 pop avginc ldensity shall, fe vce(cluster stateid)

*Fixed effect on robbery rate*
xtreg lrob lincarc_rate pb1064 pw1064 pm1029 pop avginc ldensity shall, fe vce(cluster stateid)

