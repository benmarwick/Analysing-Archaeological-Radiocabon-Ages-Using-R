


#---------------------------------------------------
library(rcarbon)
xx <- 
  calibrate(x=c(3445, 7456, 11553),
            errors=c(50, 110, 230),
            calCurves='intcal20')


summary(xx)

# identify specific dates with a given
# probability mass within a given interval. 
# The example below extracts all dates from 
# the object xx with a cumulative probability 
# mass of 0.5 or over between 7000 and 5500 cal BP:
  
xx2 = subset(xx, BP <= 10000 & BP >= 5500, p = 0.5)
summary(xx2)

# no plotting method


#---------------------------------------------------
library(Bchron)

ages2 = BchronCalibrate(ages=c(3445, 11553, 7456),
                        ageSds=c(50, 230, 110),
                        calCurves=rep('intcal20',3))
summary(ages2)

plot(ages2)

# if we have some position info, we
# can plot all on one

ages3 <-  BchronCalibrate(ages=c(3445, 11553, 7456),
                        ageSds=c(50, 230, 110),
                        ids = c("Date 1A", "Date 1C", "Date 1B"),
                        positions=c(0, 20, 10),
                        calCurves=rep('intcal20', 3))
summary(ages3)

library(ggplot2)
plot(ages3, 
     dateHeight = 10,
     dateLabels = TRUE
     ) +
  labs(x = 'Age (years BP)',
       y = 'Depth (cm)',
       title = 'Three dates at different depths')
 