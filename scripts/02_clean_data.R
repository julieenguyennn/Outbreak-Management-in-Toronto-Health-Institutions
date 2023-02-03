#### Preamble ####
# Purpose: Clean the data downloaded from opendatatoronto
# Author: Julie Nguyen
# Date: 2 February 2022
# Contact: hongan.nguyen@utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the data on opendatatoronto and saved it to inputs/data
# - Commit and push to github when change anything

library(opendatatoronto)
library(dplyr)
library(janitor)
library(tidyverse)
library(knitr)
library(RColorBrewer)
library(kableExtra)

outbreak_2020 <- read.csv(here::here("inputs/data/outbreak_2020.csv"))
outbreak_2021 <- read.csv(here::here("inputs/data/outbreak_2021.csv"))
outbreak_2022 <- read.csv(here::here("inputs/data/outbreak_2022.csv"))

# Total number of outbreaks
no_outbreak <-
  data.frame(Year = c("2020","2021","2022"), Outbreak_Amount = c(nrow(outbreak_2020),nrow(outbreak_2021),nrow(outbreak_2022)))

# Generate graph
no_outbreak %>%
  knitr::kable(col.names = c("Year", "No. of Outbreak"),
               align = c('l', 'c'),
               booktabs = T) %>%
  kable_styling(full_width = FALSE, latex_options = c("striped", "HOLD_position"))

# Count the outbreaks in each year by type 
ob_by_type_2020 <- outbreak_2020 %>% count(Type.of.Outbreak) %>% 
  mutate(Year = 2020) %>% 
  rename(Cases = "n")
ob_by_type_2021 <- outbreak_2021 %>% count(Type.of.Outbreak) %>% 
  mutate(Year=2021)%>% 
  rename(Cases = "n")
other_2021 <- data.frame(Type.of.Outbreak = "Other", Cases = 0, Year = 2021)
ob_by_type_2021 <- bind_rows(ob_by_type_2021, other_2021)
ob_by_type_2022 <- outbreak_2022 %>% count(Type.of.Outbreak) %>% 
  mutate(Year=2022)%>% 
  rename(Cases = "n")

# Merge dataframes
ob_by_type <- bind_rows(ob_by_type_2020,ob_by_type_2021,ob_by_type_2022)

# Generate graph
ob_by_type$Year <- as.factor(ob_by_type$Year)
ggplot(ob_by_type, aes(fill=Type.of.Outbreak, y=Cases, x=Year)) + 
  geom_bar(position="dodge", stat="identity") +
  geom_text(
    aes(label = Cases),
    colour = "black", size = 3,
    vjust = -0.2, position = position_dodge(.9)) +
  guides(fill=guide_legend(title="Type of Outbreak"))

# Number of outbreaks happened in each setting
# Count the outbreaks in each setting by type 
ob_setting_2020 <- outbreak_2020 %>% group_by(Type.of.Outbreak) %>% count(Outbreak.Setting) %>% arrange(Type.of.Outbreak, Outbreak.Setting)
ob_setting_2021 <- outbreak_2021 %>% group_by(Type.of.Outbreak) %>% count(Outbreak.Setting)%>% arrange(Type.of.Outbreak, Outbreak.Setting)
ob_setting_2022 <- outbreak_2022 %>% group_by(Type.of.Outbreak) %>% count(Outbreak.Setting)%>% arrange(Type.of.Outbreak, Outbreak.Setting)

# Merge dataframes
ob_setting <- merge(merge(ob_setting_2020,ob_setting_2021, by = c("Type.of.Outbreak","Outbreak.Setting"), all = TRUE, sort = TRUE), ob_setting_2022, by = c("Type.of.Outbreak","Outbreak.Setting"), all = TRUE, sort = TRUE) %>% 
  rename("2020" = n.x, "2021" = n.y, "2022" = n)

# Generate graph
cleaned_ob_setting <- select(ob_setting, c(Outbreak.Setting, "2020", "2021", "2022")) 
colnames(cleaned_ob_setting) <- c("","2020","2021","2022")
names(cleaned_ob_setting$Outbreak.Setting) <- NULL
kbl(cleaned_ob_setting, booktabs = TRUE) %>% 
  kable_styling(full_width = TRUE, latex_options = c("striped", "HOLD_position")) %>% 
  column_spec(1, width = "8cm") %>% 
  pack_rows("Enteric",start_row = 1, end_row = 4) %>% 
  pack_rows("Other", start_row = 5, end_row = 5) %>% 
  pack_rows("Respiratory", start_row = 6, end_row = 11)

# Response rate
# Year 2020
daybegan_2020 <- date_ob_2020 <- as.Date(outbreak_2020$Date.Outbreak.Began)  
dayover_2020 <- date_ob_2020 <- as.Date(outbreak_2020$Date.Declared.Over) 

# Year 2021
daybegan_2021 <- date_ob_2021 <- as.Date(outbreak_2021$Date.Outbreak.Began)  
dayover_2021 <- date_ob_2021 <- as.Date(outbreak_2021$Date.Declared.Over)

# Year 2022
daybegan_2022 <- date_ob_2022 <- as.Date(outbreak_2022$Date.Outbreak.Began)  
dayover_2022 <- date_ob_2022 <- as.Date(outbreak_2022$Date.Declared.Over)

#Calculate response time for each
response_rate_2020 <- outbreak_2020 %>% mutate(daybegan_2020,dayover_2020,response_rate = difftime(dayover_2020,daybegan_2020,unit = "days")) #calculate response rate
response_rate_2020$response_rate <- as.numeric(response_rate_2020$response_rate)
cleaned_response_rate_2020 <- response_rate_2020 %>% select(c(Outbreak.Setting, Type.of.Outbreak,response_rate)) %>%
  group_by(Outbreak.Setting, Type.of.Outbreak) %>%
  summarise(response_rate = round(mean(response_rate), digits = 0), .groups = 'drop') %>% 
  arrange(Type.of.Outbreak)

response_rate_2021 <- outbreak_2021 %>% mutate(daybegan_2021,dayover_2021,response_rate = difftime(dayover_2021,daybegan_2021,unit = "days"))
response_rate_2021$response_rate <- as.numeric(response_rate_2021$response_rate)
cleaned_response_rate_2021 <- response_rate_2021 %>% select(c(Outbreak.Setting, Type.of.Outbreak,response_rate)) %>%
  group_by(Outbreak.Setting, Type.of.Outbreak) %>%
  summarise(response_rate = round(mean(response_rate), digits = 0), .groups = 'drop') %>% 
  arrange(Type.of.Outbreak)

response_rate_2022 <- outbreak_2022 %>% mutate(daybegan_2022,dayover_2022,response_rate = difftime(dayover_2022,daybegan_2022,unit = "days"))
response_rate_2022$response_rate <- as.numeric(response_rate_2022$response_rate)
cleaned_response_rate_2022 <- response_rate_2022 %>%
  filter(Active == "N") %>% 
  select(c(Outbreak.Setting, Type.of.Outbreak,response_rate)) %>%
  group_by(Outbreak.Setting, Type.of.Outbreak) %>%
  summarise(response_rate = round(mean(response_rate), digits = 0), .groups = 'drop') %>% 
  arrange(Type.of.Outbreak)

# Merge all data
all_response_rate <- merge(merge(cleaned_response_rate_2020, cleaned_response_rate_2021, by = c("Type.of.Outbreak","Outbreak.Setting"), all = TRUE, sort = TRUE), cleaned_response_rate_2022, by = c("Type.of.Outbreak","Outbreak.Setting"), all = TRUE, sort = TRUE) %>% 
  rename("2020" = response_rate.x, "2021" = response_rate.y, "2022" = response_rate, "Outbreak Type" = Type.of.Outbreak, "Setting" = Outbreak.Setting)

# Draw table
all_response_rate <- select(all_response_rate, c(Setting, "2020", "2021", "2022"))
colnames(all_response_rate) <- c("","2020","2021","2022")
names(all_response_rate$Outbreak.Setting) <- NULL
kbl(all_response_rate, booktabs = TRUE) %>% 
  kable_styling(full_width = TRUE, latex_options = c("striped", "hold_position")) %>% 
  column_spec(1, width = "8cm") %>% 
  pack_rows("Enteric",start_row = 1, end_row = 4) %>% 
  pack_rows("Other", start_row = 5, end_row = 5) %>% 
  pack_rows("Respiratory", start_row = 6, end_row = 11)

