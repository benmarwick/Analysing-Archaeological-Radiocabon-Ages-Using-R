# from https://fishandwhistle.net/post/2018/comparing-approaches-to-age-depth-modelling-in-r/
# https://journals.sagepub.com/doi/full/10.1177/0959683616675939

library(tidyverse)

dates <- tribble(
  ~sample_id, ~depth, ~age_14C, ~age_error,
  "LL082011-C2-39", 94, 9148, 49,
  "UOC-0844", 70.5, 8582, 28,
  "LL082011-C2-87", 46, 4396, 55,
  "UOC-0845", 37.5, 575, 18,
  "LL082011-C2-124", 9, 623, 34
)

dates


#--------------------------------------------
library(rbacon)

# has a peculiar need to read data in from a CSV file
dir.create("data/bacon-data/LL-PC2", recursive = TRUE)

# and needs special column names
dates %>%
  select(labID = sample_id, 
         age = age_14C, 
         error = age_error, 
         depth) %>%
  arrange(depth) %>%
  write_csv("data/bacon-data/LL-PC2/LL-PC2.csv")

Bacon(core = "LL-PC2", 
      coredir = "data/bacon-data", 
      ask = FALSE, 
      plot.pdf = FALSE,
      thick = 2, 
      acc.mean = 100)


calib.plot(rotate.axes = TRUE, 
           rev.yr = TRUE)

agedepth(rotate.axes = TRUE, 
         rev.yr = TRUE)



#--------------------------------------------
library(Bchron)

# need to be in a certain order for Bchron
dates_rev <- 
  dates %>% 
  arrange(age_14C)

result <- 
  Bchronology(
  ages =       dates_rev$age_14C,
  ageSds =     dates_rev$age_error,
  positions =  dates_rev$depth,
  ids =        dates_rev$sample_id,
  positionThicknesses = rep(1, nrow(dates))
)

plot(result,
     dateHeight = 20,
     chronCol = "grey80",
     chronTransparency = 0.3
     )
