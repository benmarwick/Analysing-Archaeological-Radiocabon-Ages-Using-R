
# Summed probability distribution 

#----------------------------------
library(rcarbon)
data(euroevol)
DK <- subset(euroevol,
             Country=="Denmark") #subset of Danish dates

str(DK)

# hack for parallel computing on OSX, from https://github.com/rstudio/rstudio/issues/6692
parallel:::setDefaultClusterOptions(setup_strategy = "sequential")

DK.caldates <- 
  calibrate(x=DK$C14Age,
            errors=DK$C14SD,
            calCurves='intcal13',
            ncores=3) #running calibration over 3 cores

DK.spd <-  spd(DK.caldates,
               timeRange=c(8000, 4000)) 

# need to run this first to make the base plot
plot(DK.spd) 

plot(
  DK.spd,
  runm = 200,
  add = TRUE,
  type = "simple",
  col = "darkorange",
  lwd = 2,
  lty = 2
) # using a rolling average of 200 years for smoothing


#---------------------------------
# Japanese radiocarbon data from Atsushi Noguchi, contact to reuse: asiansophia@gmail.com
# Look out: it takes a long time to run!
library(rcarbon)
library(tidyverse)

# try it with the JP data
c14data <- read_tsv("data/carbon.tsv")

# basic tidy the data a little - no effort at chrono-hygene here
c14data_for_spd <- 
c14data %>% 
  filter(試料の種類 != "貝")  %>% 
  select(`C14年代`,
         `C14年代±`,
         遺跡名) %>% 
  mutate(C14Age = parse_number(`C14年代`),
         C14SD = parse_number(`C14年代±`),
         site_ID =  遺跡名) %>% 
  drop_na()

# hack for parallel computing on OSX, from https://github.com/rstudio/rstudio/issues/6692
parallel:::setDefaultClusterOptions(setup_strategy = "sequential")

# calibrate all the ages
jp.caldates <- 
  calibrate(x = c14data_for_spd$C14Age,
            errors = c14data_for_spd$C14SD,
            calCurves = 'intcal13',
            ncores = 3) #running calibration over 3 cores

# basic SPD
jp.spd <-  spd(jp.caldates,
               timeRange=c(max(c14data_for_spd$C14Age), 
                           min(c14data_for_spd$C14Age)
                           ) )

plot(jp.spd) 
plot(
  jp.spd,
  runm = 200,
  add = TRUE,
  type = "simple",
  col = "darkorange",
  lwd = 2,
  lty = 2
) #using a rolling average of 200 years for smoothing

# SPD with binning

# , for example where one well-resourced research project has sampled 
# one particular site for an unusual number of dates. This might generate 
# misleading peaks in the SPD and to mitigate this effect it is possible 
# to create artificial bins,
jp.bins <-  binPrep(sites = c14data_for_spd$site_ID,
                    ages = c14data_for_spd$C14Age,
                    h=100)

jp.spd.bins <- 
  spd(jp.caldates,
      bins = jp.bins,
      timeRange=c(max(c14data_for_spd$C14Age), 
                  min(c14data_for_spd$C14Age)
      ))

plot(jp.spd.bins)

# check the effects of different bin sizes
# takes a very long time!
binsense(
  x = jp.caldates,
  y = c14data_for_spd$site_ID,
  h = seq(0, 500, 100),
  timeRange=c(max(c14data_for_spd$C14Age), 
              min(c14data_for_spd$C14Age)
  )
)



# CKDE: composite kernel density estimate
jp.randates <-
  sampleDates(jp.caldates,
              bins = jp.bins,
              nsim = 100,
              verbose = FALSE)
# The resulting object becomes the key argument for the ckde() 
# function, whose output can be displayed via a generic plot() function:
  
jp.ckde <- 
  ckde(jp.randates,
       timeRange=c(max(c14data_for_spd$C14Age), 
                   min(c14data_for_spd$C14Age)
       ),
       bw=200)


plot(jp.ckde,
     type='multiline')
