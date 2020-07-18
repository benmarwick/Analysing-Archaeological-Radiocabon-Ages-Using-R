Introduction to Analysing Archaeological Radiocabon Ages Using R
================
Ben Marwick, July 2020

## Overview

In this workshop we will practice some techniques for analysing
archaeological radiocabon ages using R. Here’s the outline of key
topics:

1.  Calibrate and plot a single age
2.  Calibrate and plot multiple ages
3.  Combine and plot multiple ages using non-parametric phase estimation
4.  Age-depth modelling
5.  Summed probability density plots
6.  Hypothesis testing with SPDs

You can download the code and data from this repository onto your computer by running the following line in your R console:

```r
usethis::use_course("benmarwick/Analysing-Archaeological-Radiocabon-Ages-Using-R")
```

## Dependencies 

We will be using the following R packages:

- rcarbon
- Bchron
- rbacon
- tidyverse

You can install these by running the following line in your R console:

```r
install.packages(c("rcarbon", "Bchron", "rbacon", "tidyverse"))
```

### Contributing

If you would like to contribute to this project, please start by reading
our [Guide to Contributing](CONTRIBUTING.md). Please note that this
project is released with a [Contributor Code of Conduct](CONDUCT.md). By
participating in this project you agree to abide by its terms.
