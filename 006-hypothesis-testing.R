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
