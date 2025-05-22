
program define IsStop, sclass 
    if `"`0'"' == "[" | `"`0'"' == "," | `"`0'"' == "if" | `"`0'"' == "in" | `"`0'"' == "" {
        sret local stop 1
    }
    else {
        sret local stop 0
    }
end

program define parse_iv, rclass
    version 9
    sreturn clear
    local n 0

    gettoken depvar 0 : 0, parse(" ,[") match(paren)
    IsStop `depvar'
    if `s(stop)' {
        error 198
    }

    while `s(stop)' == 0 {
        if "`paren'" == "(" {
            local n = `n' + 1
            if `n' > 1 {
                di as err "Syntax error: only one (endogenous = instruments) block is allowed"
                exit 198
            }

            gettoken p depvar : depvar, parse(" =")
            while "`p'" != "=" {
                if "`p'" == "" {
                    di as err "Syntax error: use (endogenous = instruments) or (endogenous = __none__)"
                    exit 198
                }
                local endo `endo' `p'
                gettoken p depvar : depvar, parse(" =")
            }

            local temp_ct : word count `endo'
            if `temp_ct' > 0 {
                fvunab endo : `endo'
            }

            local temp_ct : word count `depvar'
            if `temp_ct' > 0 {
                local exexog `depvar'
            }
        }
        else {
            local inexog `inexog' `depvar'
        }
        gettoken depvar 0 : 0, parse(" ,[") match(paren)
        IsStop `depvar'
    }

    local 0 `"`depvar' `0'"'
    fvunab inexog : `inexog'
    tokenize `inexog'
    local depvar "`1'"
    local 1 " "
    local inexog `*'

    return local depvar "`depvar'"
    return local inexog "`inexog'"
    return local exexog "`exexog'"
    return local endo "`endo'"
end




program define ivlewfe, eclass
    version 15.0
    syntax [anything(name=args)] [if] [in], ///
    [FE(varlist)] ///
    [Cluster(varlist)] ///
    [Robust] ///
    [Zvars(varlist)] ///
    [Saveinst(string)] ///
    [First] ///
	[Small]
	
local zvars `zvars'
if "`zvars'" == "" local zvars `exogs'


    // Parse inputs
    parse_iv `args'
    local depvar = r(depvar)
    local exogs  = r(inexog)
    local endog  = r(endo)
    local extiv  = r(exexog)

    // Handle external IVs
	capture confirm name `extiv'
	if _rc | "`extiv'" == "" | "`extiv'" == "." {
    local extiv ""
	}
	else {
    capture fvunab extiv : `extiv'
    if _rc {
        di as err "Failed to expand external instruments: `extiv'"
        exit 198
    }
}


    tempvar res
    local instvars

    quietly {
        // Step 1: First stage for residuals
		
    local vceopt ""
    if "`cluster'" != "" {
        local vceopt "vce(cluster `cluster')"
    }
    else if "`robust'" != "" {
        local vceopt "vce(robust)"
    }		
        reghdfe `endog' `exogs' `if' `in', absorb(`fe') `vceopt' resid
        predict double `res', resid

        // Step 2: Expand exogenous vars for Lewbel instruments
        fvunab exogs_expanded : `exogs'
        foreach var of local exogs_expanded {			
            capture confirm variable `var'
            if !_rc {
                summarize `var' if e(sample), meanonly
                local mean = r(mean)

                local clean = subinstr("`var'", ".", "_", .)
                local clean = subinstr("`clean'", "#", "_", .)
                local clean = subinstr("`clean'", "|", "_", .)
                local ivname = "iv_`clean'"

                capture drop `ivname'
				gen double `ivname' = (`var' - `mean') * `res'
				label variable `ivname' "Lewbel IV for `var'"
				local instvars `instvars' `ivname'
            }
        }
    }

    local alliv `extiv' `instvars'

    // Step 4: Estimate second stage

    if "`fe'" != "" {
        // Use ivreghdfe when FE is specified
        if "`first'" != "" {
            di as result ">>> Estimating Lewbel (2012) 2SLS IV regression with first-stage output"
            ivreghdfe `depvar' `exogs' (`endog' = `alliv')  `if' `in', absorb(`fe') `vceopt' `small' first
			if "`small'" != "" {
				di as txt "Note: Small-sample adjustment applied. For detail, see {help ivreg2}"
				}
        }
        else {
			di as result ">>> Estimating Lewbel (2012) 2SLS IV regression"
            ivreghdfe `depvar' `exogs' (`endog' = `alliv')  `if' `in', absorb(`fe') `vceopt' `small'
			if "`small'" != "" {
				di as txt "Note: Small-sample adjustment applied. For detail, see {help ivreg2}"
				}
        }
    }
    else {
        // Use ivreghdfe if no fixed effects
        if "`first'" != "" {
            di as result ">>> Estimating Lewbel (2012) 2SLS IV regression with first-stage output"
            ivreghdfe `depvar' `exogs' (`endog' = `alliv'), `vceopt' `small' first
			if "`small'" != "" {
				di as txt "Note: Small-sample adjustment applied. For detail, see {help ivreg2}"
				}
        }
        else {
			di as result ">>> Estimating Lewbel (2012) 2SLS IV regression"			
            ivreghdfe `depvar' `exogs' (`endog' = `alliv')  `if' `in', `vceopt' `small'
			if "`small'" != "" {
				di as txt "Note: Small-sample adjustment applied. For detail, see {help ivreg2}"
				}
        }			
    }

    // Post estimation storage
	ereturn local cmd "ivlewfe"
	ereturn local depvar "`depvar'"
	ereturn local endogvar "`endog'"
	ereturn local exogs "`exogs'"
	ereturn local instruments "`alliv'"
	
	if "`saveinst'" != "" {
    ereturn local geninst_saved = "yes"
    ereturn local geninst_stub "`saveinst'"
	}
	
	else {
    ereturn local geninst_saved = "no"
    ereturn local geninst_stub ""
	di as txt "Note: Internal IVs not saved. Use {cmd:saveinst(stub)} to store them in the database."
    
    // Drop internal IVs if not saving
    foreach var of local instvars {
        capture drop `var'
    }
}

// Always drop residuals
capture drop _reghdfe_resid

end
exit
