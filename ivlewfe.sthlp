{smcl}
{* *! version 1.0.1 May 2025}{...}
{title:{cmd:ivlewfe} — Lewbel (2012) 2SLS IV estimation with cross-section, time-series, pooled and (multiple levels of) fixed effects and clustered standard errors}

{title:Description}

{p 4 4 2}
{cmd:ivlewfe} estimates a two-stage least squares (2SLS) instrumental variable model using internal instruments constructed from heteroskedasticity, following {browse "https://doi.org/10.1080/07350015.2012.643126":Lewbel (2012)}.

{p 4 4 2}
This command is designed for panel or cross-sectional data with fixed effects and supports:
- High-dimensional fixed effects (via {help:reghdfe} and {help:ivreghdfe}) {break}
- Cluster-robust or robust standard errors {break}
- Optional external instruments {break}
- Automatic creation of Lewbel internal IVs{break}
- Factor-variable support (e.g., {cmd:i.year}) {break}
- First-stage diagnostics, small-sample correction, and internal IV naming {break}
- Optional saving or dropping of generated IVs

{p 4 4 2}
Compared to {help ivreg2h}, {cmd:ivlewfe} is compatible with high-dimensional panel data using {help:reghdfe}, robust clustering, and factor variable notation.

{title:Syntax}

{p 4 4 2}
To use {cmd:ivlewfe}, you need to install: {help ftools}, {help reghdfe}, {help ivreg2}, and {help ivreghdfe}

{p 4 4 2}
{cmd:ivlewfe} {it:depvar} {it:exogvars} ({it:endogvar} = {it:external_IVs}), {cmd:fe(}{it:fevars}{cmd:)} [options]

{p 4 4 2}
To use Lewbel-style internal instruments only, specify: {cmd:(endogvar = )}


{title:Options}

{p 4 4 2}
{cmd:fe(}{it:varlist}{cmd:)} specifies the fixed effects to absorb. Multiple variables are allowed (e.g., {cmd:fe(country firm year)}).

{p 4 4 2}
{cmd:cluster(}{it:clustvar}{cmd:)} specifies the clustering variable for standard errors.

{p 4 4 2}
{cmd:robust} requests heteroskedasticity-robust standard errors. Ignored if {cmd:cluster()} is specified.

{p 4 4 2}
{cmd:saveinst(}{it:iv}{cmd:)} saves internally generated Lewbel instruments with a prefix. If omitted, the instruments are automatically dropped after estimation.

{p 4 4 2}
{cmd:first} displays the first-stage regression results.

{p 4 4 2}
{cmd:small} applies a small-sample adjustment.


{title:Examples}

{p 4 4 2}
{stata "webuse nlswork, clear"}

{p 4 4 2}
Use internal IVs only without fixed effect:

{p 4 4 2}
{stata "ivlewfe ln_w age msp occ_code (tenure = )"}

{p 4 4 2}
Use internal IVs only with one fixed effect:

{p 4 4 2}
{stata "ivlewfe ln_w age msp occ_code union (tenure = ), fe(idcode)"}

{p 4 4 2}
Use external IVs, TWFE and view first stage:

{p 4 4 2}
{stata "ivlewfe ln_w age msp occ_code (tenure = union south), fe(idcode year) cluster(idcode) first"}

{p 4 4 2}
Save generated IVs and apply small-sample correction:

{p 4 4 2}
{stata "ivlewfe ln_w age msp occ_code (tenure = ), fe(idcode year) saveinst(iv) small"}

{p 4 4 2}
Use quadratic and/or interaction term(s):

{p 4 4 2}
{stata "ivlewfe ln_w age c.age#c.age msp occ_code (tenure = ), fe(idcode year) saveinst(iv) small"} {break}
{stata "ivlewfe ln_w age c.age#c.age msp c.age#i.race occ_code (tenure = ), fe(idcode year) saveinst(iv) small"}



{title:Remarks}

{p 4 4 2}
Internal IVs are dropped unless explicitly saved via {cmd:saveinst(iv)}. 

{title:Acknowledgments}

{p 4 4 2}
{cmd: ivlewfe} is based on some existing Stata community contributions, notably, {break}
- {help reghdfe}  by Sergio Correia and Noah Constantine: for generating internal IVs. {break}
- {help ivreghdfe} by Sergio Correia: for estimating first-stage and second-stage least square estimates internal IVs. {help ivreghdfe} is built upon {help ivreg2} program.   
  

{title:Reference}

{p 4 4 2}
Lewbel, A. (2012). {browse "https://doi.org/10.1080/07350015.2012.643126":Using Heteroscedasticity to Identify and Estimate Mismeasured and Endogenous Regressor Models}, {it:Journal of Business & Economic Statistics}, 30(1), 1263–1276.

{p 4 4 2}
Baum CF, Lewbel, A, 2019. {browse "https://doi.org/10.1177/1536867X19893614":Advice on using Heteroscedasticity based identificatiom}, {it:Stata Journal}, 19:4, 757-767.


{title:Author}

{p 4 4 2}
S. M. Woahid Murad{break}
School of Accounting, Economics and Finance{break}
Curtin University, Australia{break}
Email: {browse "mailto:S.Murad@curtin.edu.au":S.Murad@curtin.edu.au}


{title:Feedback and Development}

{p 4 4 2}
Report bugs or suggestions via GitHub or email. Submission to SSC is under consideration.


{title:Also see}

{p 4 4 2}
{help ivreg2}, {help ivreg2h}, {help ivreghdfe}, {help reghdfe}, {help ivregress}
