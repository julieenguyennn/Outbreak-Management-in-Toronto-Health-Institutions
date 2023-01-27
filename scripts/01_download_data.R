library(opendatatoronto)
library(dplyr)

# get package
package <- show_package("99ff3657-b2e7-4005-a6fd-c36838ccc96d")
package

# get all resources for this package
resources <- list_package_resources("99ff3657-b2e7-4005-a6fd-c36838ccc96d")

# identify datastore resources; by default, Toronto Open Data sets datastore resource format to CSV for non-geospatial and GeoJSON for geospatial resources
datastore_resources <- filter(resources, tolower(format) %in% 'csv')
datastore_resources

# load the immunization coverage in the AY 2017-2018
immunization_2017_2018 <- filter(datastore_resources, row_number()==1) %>% get_resource()

# load the immunization coverage in the AY 2018-2019
immunization_2018_2019 <- filter(datastore_resources, row_number()==1) %>% get_resource()