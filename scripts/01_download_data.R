library(opendatatoronto)
library(dplyr)

# get package
package <- show_package("80ce0bd7-adb2-4568-b9d7-712f6ba38e4e")

# get all resources for this package
resources <- list_package_resources("80ce0bd7-adb2-4568-b9d7-712f6ba38e4e")

# identify datastore resources; by default, Toronto Open Data sets datastore resource format to CSV for non-geospatial and GeoJSON for geospatial resources
all_data <- filter(resources, tolower(format) %in% 'csv')

ob_source_2020 <- filter(all_data,row_number()==13) %>% get_resource()
ob_source_2021 <- filter(all_data,row_number()==14) %>% get_resource()
ob_source_2022 <- filter(all_data,row_number()==15) %>% get_resource()

# save data set
write.csv(ob_source_2020,"inputs/data/outbreak_2020.csv")
outbreak_2020 <- read.csv("inputs/data/outbreak_2020.csv")

write.csv(ob_source_2021,"inputs/data/outbreak_2021.csv")
outbreak_2021 <- read.csv("inputs/data/outbreak_2021.csv")

write.csv(ob_source_2022,"inputs/data/outbreak_2022.csv")
outbreak_2022 <- read.csv("inputs/data/outbreak_2022.csv")

