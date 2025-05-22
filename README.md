# ivlewfe: Lewbel (2012) 2SLS IV estimation with cross-section, time-series, pooled and (multiple levels of) fixed effects and clustered standard errors

**ivlewfe** is a Stata command that implements the heteroskedasticity-based instrumental variable (IV) estimator proposed by [Lewbel (2012)](https://doi.org/10.1257/aer.102.3.1263). It extends Lewbel’s method by allowing for:

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
net install ivlewfe, from("https://raw.githubusercontent.com/woahidmurad/ivlewfe/main/") replace
```

---

## 📘 Usage

The syntax follows a standard 2SLS pattern:

```stata
ivlewfe depvar exogvars (endogvar = external_IVs), fe(fixed_effects) ///
    [cluster(clustvar)] [robust] [saveinst(stub)] ///
    [first] [small]
```

To use only internal Lewbel instruments (no external IVs):

```stata
ivlewfe depvar exogvars (endogvar = ), fe(fixed_effects)
```

---

## 💡 Examples

Simple Lewbel IV with one fixed effect:

```stata
webuse nlswork
ivlewfe ln_w age tenure (tenure = ), fe(idcode)
```

With external instruments and small-sample adjustment:

```stata
ivlewfe ln_w age tenure (tenure = union south), fe(idcode year) ///
    cluster(idcode) small first saveinst(myiv)
```

Excluding a variable from IV generation:

```stata
ivlewfe ln_w age tenure (tenure = ), fe(idcode) skipiv(age)
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
PhD Candidate, Curtin University  
Email: S.Murad@curtin.edu.au  

---

## 🧩 Contributions and Feedback

If you discover bugs, have feature requests, or want to contribute, feel free to open an issue or pull request on the [GitHub repository](https://github.com/YOUR_USERNAME/ivlewfe).

---

## 🔄 Related packages

- [`ivreghdfe`](https://github.com/sergiocorreia/ivreghdfe)
- [`ivreg2h`](https://ideas.repec.org/c/boc/bocode/s457555.html)
- [`reghdfe`](https://github.com/sergiocorreia/reghdfe)
