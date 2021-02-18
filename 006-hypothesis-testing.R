# Crema, E.R., Bevan, A. 2020 Inference from Large Sets of Radiocarbon Dates: 
# Software and Methods Radiocarbon, doi:10.1017/RDC.2020.95

library(rcarbon)
data(euroevol)
DK <- subset(euroevol,
             Country=="Denmark") #subset of Danish dates

str(DK)

# hack for parallel computing on OSX, from https://github.com/rstudio/rstudio/issues/6692
parallel:::setDefaultClusterOptions(setup_strategy = "sequential")

# calibrate (can skip if just run)
DK.caldates <- 
  calibrate(x=DK$C14Age,
            errors=DK$C14SD,
            calCurves='intcal20',
            ncores=3) # running calibration over 3 cores

# Dates are assigned to the same or different bins based on their proximity 
# to one another in (either 14C in time or median calibrated date) using 
# hierarchical clustering with a user-defined cut-off value
DK.bins <-  binPrep(sites=DK$SiteID,
                    ages=DK$C14Age,
                    h=100)

# Test for fit to exponential model 
nsim = 100
expnull <- 
  modelTest(DK.caldates, 
            errors=DK$C14SD, 
            bins=DK.bins, 
            nsim=nsim, 
            timeRange=c(8000, 4000), 
            model="exponential", runm=100)

# take a look
plot(expnull)

# see p-value: does the model fit the data? <0l05 means no
expnull$pval

# see when the deviations are
summary(expnull)

# Test for fit to uniform model 
uninull <- 
  modelTest(DK.caldates, 
            errors=DK$C14SD, 
            bins=DK.bins, 
            nsim=nsim, 
            timeRange=c(8000, 4000), 
            model="uniform", runm=100)

# take a look
plot(uninull)

# see p-value: does the model fit the data?
uninull$pval

# see when the deviations are
summary(uninull)


# other things rcarbon can do:

# - Testing against custom growth models, e.g. residential count data
# - Testing Local Growth Rates
# - Comparing empirical SPDs against each other, e.g. to evaluate regional variations in population trends
# - Spatio-Temporal Kernel Density Estimates























# Look out: the code below takes such a long time!
# https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0154809

#---------------------------------
library(rcarbon)
library(tidyverse)

# try it with the JP data
c14data <- read_tsv("data/carbon.tsv")

# basic tidy the data a little
# remove  charred remains with high δ13C that might be potentially affected
# by a reservoir effect (i.e. >-24‰)
c14data_for_ht <- 
  c14data %>% 
  filter(試料の種類 != "貝")  %>% 
  mutate(`δ13C（AMS）` = parse_number(`δ13C（AMS）`)) %>% 
  filter(`δ13C（AMS）` < -24) %>% 
  select(`C14年代`,
         `C14年代±`,
         遺跡名) %>% 
  mutate(C14Age = parse_number(`C14年代`),
         C14SD = parse_number(`C14年代±`),
         site_ID =  遺跡名) %>% 
  filter(between(C14Age, 2500, 7500)) %>% 
  drop_na()

# hack for parallel computing on OSX, from https://github.com/rstudio/rstudio/issues/6692
parallel:::setDefaultClusterOptions(setup_strategy = "sequential")

# calibrate all the ages
jp.caldates <- 
  calibrate(x = c14data_for_ht$C14Age,
            errors = c14data_for_ht$C14SD,
            calCurves = 'intcal13',
            ncores = 3) #running calibration over 3 cores

# binning
jp.bins <-  binPrep(sites = c14data_for_ht$site_ID,
                    ages = c14data_for_ht$C14Age,
                    h=100)


# testing the actual ages to see how do they fit an exponential model

# 1. introduced a Monte-Carlo simulation approach consisting of 
# a three-stage process: 
# 1) fit a growth model to the observed SPD, for example via regression; 
# 2) generate random samples from the fitted model; and 
# 3) uncalibrate the samples. 

# The resulting set of radiocarbon dates can then be calibrated and 
# aggregated in order to generate an expected SPD of the fitted model 
# that takes into account idiosyncrasies of the calibration process.

nsim <-  100
expnull <-
  modelTest(
    jp.caldates,
    errors = c14data_for_ht$C14SD,
    bins = jp.bins,
    nsim = nsim,
    timeRange=c(max(c14data_for_ht$C14Age), 
                min(c14data_for_ht$C14Age)
    ),
    model = "exponential",
    runm = 100
  )

## Warning in modelTest(DK.caldates, errors = DK$C14SD, bins = DK.bins, nsim =
## nsim, : edgeSize reduced
# We can extract the global p-value from the resulting object
# which can also be plotted.

plot(expnull)
