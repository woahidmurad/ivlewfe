# ivlewfe: Lewbel (2012) IV Estimator with Fixed Effects and Clustered Standard Errors in Stata

**ivlewfe** is a Stata command that implements the heteroskedasticity-based instrumental variable (IV) estimator proposed by [Lewbel (2012)](https://doi.org/10.1080/07350015.2012.643126). It covers:

- High-dimensional fixed effects via `ivreghdfe`
- Cluster-robust or heteroskedasticity-robust standard errors
- Optional external instruments
- Reproducible internal IV names
- Optional saving or automatic removal of internal IVs
- Full support for factor variables (e.g., `i.year`, `c.age#c.age`)
- First-stage diagnostics and small-sample adjustments

This makes **ivlewfe** well-suited for applied researchers working with panel data or models with multiple fixed effects and endogenous regressors.


---

## 📦 Installation

To install the command directly from GitHub, type the following in your Stata command window:

```stata
net install ivlewfe, from("https://github.com/woahidmurad/ivlewfe/edit/main/") replace


---

## 📘 Usage

The syntax follows a standard 2SLS pattern:

```stata
ivlewfe depvar exogvars (endogvar = external_IVs), fe(fixed_effects) ///
    [cluster(clustvar)] [robust] [saveinst(iv)] ///
    [first] [small]
```

To use only internal Lewbel instruments (no external IVs):

```stata
ivlewfe depvar exogvars (endogvar = ), fe(fixed_effects)
```

---

## 💡 Examples

See the Stata help file for ivlewfe
```

---

## 📄 Documentation

You can access the Stata help file after installation by typing:

```stata
help ivlewfe
```

---

## 📚 References

Lewbel, A. (2012). [Using Heteroskedasticity to Identify and Estimate Mismeasured and Endogenous Regressor Models](https://doi.org/10.1080/07350015.2012.643126). *Journal of Business & Economic Statistics*, 30(1), 1263–1276.

---

## 👤 Author

**S. M. Woahid Murad**  
School of Accounting, Economics and Finance
Curtin University, Australia 
Email: S.Murad@curtin.edu.au  

---

## 🧩 Contributions and Feedback

If you discover bugs, have feature requests, or want to contribute, feel free to open an issue or pull request on the [GitHub repository](https://github.com/woahidmurad/ivlewfe).

---

## 🔄 Related packages

- [`ivreghdfe`](https://github.com/sergiocorreia/ivreghdfe)
- [`ivreg2h`](https://ideas.repec.org/c/boc/bocode/s457555.html)
- [`reghdfe`](https://github.com/sergiocorreia/reghdfe)
