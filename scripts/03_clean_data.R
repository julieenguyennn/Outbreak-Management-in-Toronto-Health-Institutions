library(opendatatoronto)
library(dplyr)
library(janitor)

outbreak_2020 %>% clean_names()
outbreak_2021 %>% clean_names()
outbreak_2022 %>% clean_names()

ob_by_type_2020 <- outbreak_2020 %>% count(Type.of.Outbreak)
ob_by_type_2021 <- outbreak_2021 %>% count(Type.of.Outbreak)
ob_by_type_2022 <- outbreak_2022 %>% count(Type.of.Outbreak)

ob_by_type <- merge(merge(ob_by_type_2020, ob_by_type_2021, by = "Type.of.Outbreak", all.x = TRUE), ob_by_type_2022, by = "Type.of.Outbreak", all.x = TRUE)

ob_by_type_2 <- merge(merge(ob_by_type_2020, ob_by_type_2021, by = 0), ob_by_type_2022, by = 0)

ob_by_type %>% rename("Type.of.Outbreak" = "Outbreak_Type")

#ggplot(data=ob_by_type, aes(x=dose, y=len, group=supp)) + geom_line()+ geom_point()
# Change line types
ggplot(data=df2, aes(x=dose, y=len, group=supp)) +
  geom_line(linetype="dashed", color="blue", size=1.2)+
  geom_point(color="red", size=3)