library(opendatatoronto)
library(dplyr)
library(janitor)
library(tidyverse)
library(knitr)
library(RColorBrewer)
library(kableExtra)



outbreak_2020 %>% clean_names()
outbreak_2021 %>% clean_names()
outbreak_2022 %>% clean_names()

# Total number of outbreaks
  


# Number of occurrences in each type of outbreak throughout the years
  # Count the outbreaks in each year by type 
  ob_by_type_2020 <- outbreak_2020 %>% count(Type.of.Outbreak) %>% 
    mutate(year = 2020) %>% 
    rename(Occurences = "n")
  ob_by_type_2021 <- outbreak_2021 %>% count(Type.of.Outbreak) %>% 
    mutate(year=2021)%>% 
    rename(Occurences = "n")
  ob_by_type_2022 <- outbreak_2022 %>% count(Type.of.Outbreak) %>% 
    mutate(year=2022)%>% 
    rename(Occurences = "n")
  
  # Merge dataframes
  ob_by_type <- bind_rows(ob_by_type_2020,ob_by_type_2021,ob_by_type_2022)

  # Generate graph
  ob_by_type$year <- as.factor(ob_by_type$year)
  ggplot(data=ob_by_type, aes(x=year, y=Occurences, group=Type.of.Outbreak)) +
    geom_line(aes(color=Type.of.Outbreak), size=0.8)+
    geom_point(aes(color=Type.of.Outbreak))+
    scale_linetype_manual(values=c("solid","dotted","twodash"))+
    scale_color_brewer(palette="Dark2")+
    theme_minimal()

# Number of outbreaks happened in each setting
  # Count the outbreaks in each setting by type 
  ob_setting_2020 <- outbreak_2020 %>% group_by(Type.of.Outbreak) %>% count(Outbreak.Setting) %>% arrange(Type.of.Outbreak, Outbreak.Setting)
  ob_setting_2021 <- outbreak_2021 %>% group_by(Type.of.Outbreak) %>% count(Outbreak.Setting)%>% arrange(Type.of.Outbreak, Outbreak.Setting)
  ob_setting_2022 <- outbreak_2022 %>% group_by(Type.of.Outbreak) %>% count(Outbreak.Setting)%>% arrange(Type.of.Outbreak, Outbreak.Setting)

  # Merge dataframes
  ob_setting <- merge(merge(ob_setting_2020,ob_setting_2021, by = c("Type.of.Outbreak","Outbreak.Setting"), all = TRUE, sort = TRUE), ob_setting_2022, by = c("Type.of.Outbreak","Outbreak.Setting"), all = TRUE, sort = TRUE) %>% 
    rename("2020" = n.x, "2021" = n.y, "2022" = n)
  
  # Generate graph
  ob_setting %>% kable_styling(bootstrap_options = "striped")  
  
  ob_setting_graph <- ob_setting[c(1:2, 3:5, 6:8),]
    
    
    kable(ob_setting_graph[, 1:4], booktabs = TRUE) %>% pack_rows(
    index = c("setosa" = 2, "versicolor" = 4, "virginica" = 3)
  )

#Response rate
    response_rate <- outbreak_2020 %>% difftime(Date.Declared.Over,Date.Outbreak.Began,unit = "days")
   response_rate <- outbreak_2020 %>% as.numeric(difftime(as.POSIXct(Date.Declared.Over), as.POSIXct(Date.Outbreak.Began)))
    
   date_ob_2020 <- as.Date(outbreak_2020$Date.Outbreak.Began)
   merge()
   outbreak_2020 <- mutate(Date.Outbreak.Began = as.Date(outbreak_2020$Date.Outbreak.Began))
   
   
  

    
    

# Draft

    ob_setting <- bind_rows(ob_setting_2020,ob_setting_2021,ob_setting_2022) %>% 
      rename(Occurences = "n") %>% 
      arrange(Type.of.Outbreak, Outbreak.Setting)
