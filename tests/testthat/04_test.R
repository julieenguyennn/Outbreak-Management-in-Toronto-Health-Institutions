#### Preamble ####
# Purpose: Test the code if it's working
# Author: Julie Nguyen
# Date: 2 February 2022
# Contact: hongan.nguyen@utoronto.ca
# Pre-requisites: 
# - Generate code
# - Finish cleaning and generating graphs

test_that("check type of ob_by_type", {
  expect_s3_class(ob_by_type <- bind_rows(ob_by_type_2020,ob_by_type_2021,ob_by_type_2022), "data.frame")
})

test_that("check if the code generates dataframe type",{
  expect_s3_class(ob_setting <- merge(merge(ob_setting_2020,ob_setting_2021, by = c("Type.of.Outbreak","Outbreak.Setting"), all = TRUE, sort = TRUE), ob_setting_2022, by = c("Type.of.Outbreak","Outbreak.Setting"), all = TRUE, sort = TRUE) %>% 
                    rename("2020" = n.x, "2021" = n.y, "2022" = n), "data.frame")
  
})

test_that("check if the formula generates Date type",{
  expect_s3_class(daybegan_2020 <- date_ob_2020 <- as.Date(outbreak_2020$Date.Outbreak.Began), "Date")
})

test_that("check if it can converts from Date to numeric",{
  expect_type(response_rate_2020$response_rate <- as.numeric(response_rate_2020$response_rate), "numeric")
})

