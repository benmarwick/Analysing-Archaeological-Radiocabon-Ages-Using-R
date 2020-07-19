Introduction to Analysing Archaeological Radiocabon Ages Using R
================
Ben Marwick, July 2020

## Overview

In this workshop we will practice some techniques for analysing
archaeological radiocabon ages using R. Here are the [slides](https://docs.google.com/presentation/d/1CnenM0imyfxBRZUdeuTP6afRMvEZbg99nsLmbvSOeaE/edit?usp=sharing). Here’s the outline of key
topics:

1.  Calibrate and plot a single age
2.  Calibrate and plot multiple ages
3.  Combine and plot multiple ages using non-parametric phase estimation
4.  Age-depth modelling
5.  Summed probability density plots
6.  Hypothesis testing with SPDs

You can download the code and data from this repository onto your computer by running the following lines in your R console (please answer 'Yes' to each question that appears in your console):

```r
if (!require("usethis")) install.packages("usethis") # to install usethis
usethis::use_course("benmarwick/Analysing-Archaeological-Radiocabon-Ages-Using-R")
```

## Dependencies 

We will be using the following R packages:

- [rcarbon](https://cran.r-project.org/web/packages/rcarbon/vignettes/rcarbon.html)
- [Bchron](https://cran.r-project.org/web/packages/Bchron/vignettes/Bchron.html)
- [rbacon](https://chrono.qub.ac.uk/blaauw/manualBacon_2.3.pdf)
- [tidyverse](https://www.tidyverse.org/)

You can install these by running the following line in your R console:

```r
install.packages(c("rcarbon", "Bchron", "rbacon", "tidyverse"))
```

### Contributing

If you would like to contribute to this project, please start by reading
our [Guide to Contributing](CONTRIBUTING.md). Please note that this
project is released with a [Contributor Code of Conduct](CONDUCT.md). By
participating in this project you agree to abide by its terms.
