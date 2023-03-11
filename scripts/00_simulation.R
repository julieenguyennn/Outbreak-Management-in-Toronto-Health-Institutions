#### Preamble ####
# Purpose: Simulate the dataset to be solved
# Author: Julie Nguyen
# Date: 2 February 2022
# Contact: hongan.nguyen@utoronto.ca
# Pre-requisites: 
# - Have questions to be solved for the data

library(tidyverse)

set.seed(1)

# Generate a table that portrays the cases in each outbreak type by settings

simulated_data_1 <-
  tibble("Setting" = sample(c("LTCH","Hospital","Retirement Home","Transitional Care"), 4),
         "Type" = sample(c("Respiratory", "Enteric"), 4, replace = TRUE),
         "Cases" = floor(runif(4, min=0, max=100)),
         )
simulated_data_1

# Generate a table that has the date outbreak begins and date it's over of each setting by outbreak 

simulated_data_2 <-
  tibble("Setting" = sample(c("LTCH","Hospital","Retirement Home","Transitional Care"), 4),
         "Type" = sample(c("Respiratory", "Enteric"), 4, replace = TRUE),
         "Day Began" = sample(seq(as.Date('2020/01/01'), as.Date('2021/01/01'), by="day"), 4, replace = TRUE),
         "Day Over" = sample(seq(as.Date('2021/01/01'), as.Date('2022/01/01'), by="day"),4, replace = TRUE))
simulated_data_2