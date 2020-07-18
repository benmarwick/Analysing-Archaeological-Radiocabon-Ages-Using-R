# for estimating activity level in a site/region. 

library(Bchron)

data(Sluggan) # dataset build into package

str(Sluggan)

SlugDens <- 
  BchronDensity(ages=Sluggan$ages,
                ageSds=Sluggan$ageSds,
                calCurves=Sluggan$calCurves)

# You can then output the possible start/end dates of phases:
  
summary(SlugDens, prob = 0.95)

#The probability argument will specify the 
# sensitivity of the algorithm to finding phases.
# Lower values of prob will lead to more discovered phases.

# You can plot the density with:
  
plot(SlugDens, 
     xlab = 'Age (cal years BP)', 
     xaxp = c(0, 16000, 16))

# if you want more control
# to redo with ggplot2
x <-  SlugDens
n = length(x$calAges)
thetaRange = range(x$calAges[[1]]$ageGrid)
for (i in 2:n) thetaRange = range(c(thetaRange, x$calAges[[i]]$ageGrid))
dateGrid = seq(round(thetaRange[1] * 0.9, 3), round(thetaRange[2] * 
                                                      1.1, 3), length = 1000)
gauss <- function(x, mu, sig) {
  u <- (x - mu)/sig
  y <- exp(-u * u/2)
  y
}
gbase <- function(x, mus) {
  sig <- (mus[2] - mus[1])/2
  G <- outer(x, mus, gauss, sig)
  G
}
Gstar = gbase(dateGrid, x$mu)
dens = vector(length = length(dateGrid))
for (i in 1:nrow(x$p)) {
  dens = dens + Gstar %*% x$p[i, ]
}
densFinal = dens/sum(dens)
out <- data.frame(dateGrid = dateGrid, densFinal = densFinal)

library(ggplot2)
ggplot(out, aes(dateGrid, 
                densFinal
               )) +
  geom_line(size = 0.5) +
  theme_minimal(base_size = 14) +
  xlab("calibrated years BP") +
  ylab("Density") 
