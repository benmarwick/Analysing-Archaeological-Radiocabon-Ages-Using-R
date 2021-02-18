# reporting https://journals.uair.arizona.edu/index.php/radiocarbon/article/download/17455/pdf

#----------------------------------------------
# devtools::install_github("ahb108/rcarbon")

library(rcarbon)

x <- 
  calibrate(x = 4200,
            errors = 30,
            calCurves = 'intcal20')

summary(x)

plot(x,
     HPD=TRUE,
     credMass=0.95,
     main = "Lab ID goes here")



#----------------------------------------------
library(Bchron)

ages1 <-  
  BchronCalibrate(ages = 4200,
                  ageSds = 30,
                  calCurves = 'intcal20')

summary(ages1)

plot(ages1)

# credible interval i.e. a single contiguous range) rather than an HDR
# is often what we report in our text 

# First create age samples for each date
age_samples = sampleAges(ages1)
# Now summarise them with quantile - this gives a 95% credible interval
apply(age_samples, 2, quantile, prob=c(0.025,0.975))

