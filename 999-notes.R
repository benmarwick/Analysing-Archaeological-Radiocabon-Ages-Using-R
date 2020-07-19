# Outline

#- why calibrate?
# resources
# https://fishandwhistle.net/post/2018/comparing-approaches-to-age-depth-modelling-in-r/
# https://www.whoi.edu/nosams/what-is-carbon-dating
# https://www.youtube.com/watch?v=phZeE7Att_s
# https://www.radiocarbon.com/tree-ring-calibration.htm
# https://journals.uair.arizona.edu/index.php/radiocarbon/article/download/17455/pdf
# getting data: https://github.com/ropensci/c14bazAAR includes get_c14data("jomon")
# https://github.com/ISAAKiel/oxcAAR

# https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0154809

#- calibrate a single age & plot
#- calibrate multiple ages & plot with Bchron
#- age-depth model with Bchron
#- SPD & KDE with rcarbon
#- hypothesis testing with rcarbon
#  FMM with baydem 


# pkg we'll use
# https://cran.r-project.org/web/packages/rcarbon/vignettes/rcarbon.html
# http://andrewcparnell.github.io/Bchron/
# https://chrono.qub.ac.uk/blaauw/manualBacon_2.3.pdf
# https://eehh-stanford.github.io/baydem 








library(tidyverse)

# translation at https://docs.google.com/spreadsheets/d/13nicWd2YaquRE01y5K_m04FQ8hhR8tJo-PHUdP0hips/edit#gid=0
c14data <- read_tsv("data/carbon.tsv")

unique(c14data$試料の種類)

# what material are the dates obtained on?
c14data %>% 
  group_by(試料の種類) %>% 
  tally(sort = TRUE) %>% 
  slice(1:10) %>% 
  ggplot() +
  aes(reorder(試料の種類, 
                   -n),
           n) +
  geom_col()

# 1 Carbide 炭化物 
# 2 Carbonized material 炭化材  
# 3 Carbonized material (Chestnut) 炭化材(クリ)
# 4 timber 木材   
# 5 soil 土壌   
# 6 materials 材  
# 7 Peat 泥炭   
# 8 shellfish 貝  
# 9 carbonized material 炭化材,
# 10 Earthenware deposits 土器付着物   






