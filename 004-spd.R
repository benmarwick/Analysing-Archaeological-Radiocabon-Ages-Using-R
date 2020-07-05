


#----------------------------------
library(rcarbon)
data(euroevol)
DK <- subset(euroevol,
             Country=="Denmark") #subset of Danish dates

DK.caldates <- 
  calibrate(x=DK$C14Age,
            errors=DK$C14SD,
            calCurves='intcal13',
            ncores=3) #running calibration over 3 cores

DK.spd <-  spd(DK.caldates,
               timeRange=c(8000, 4000)) 

plot(DK.spd) 

plot(
  DK.spd,
  runm = 200,
  add = TRUE,
  type = "simple",
  col = "darkorange",
  lwd = 2,
  lty = 2
) #using a rolling average of 200 years for smoothing

# show SPD between 6000 and 3000 BC
plot(DK.spd,
     calendar = 'BCAD', 
     xlim = c(-6000,-3000)) 