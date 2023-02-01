library(opendatatoronto)
library(dplyr)

# get package
package <- show_package("80ce0bd7-adb2-4568-b9d7-712f6ba38e4e")

# get all resources for this package
resources <- list_package_resources("80ce0bd7-adb2-4568-b9d7-712f6ba38e4e")

# identify datastore resources; by default, Toronto Open Data sets datastore resource format to CSV for non-geospatial and GeoJSON for geospatial resources
all_data <- filter(resources, tolower(format) %in% 'csv')

# save data set
write.csv(all_data,"/inputs/data/raw_data.csv")
raw_data <- read.csv("inputs/data/raw_data.csv")

