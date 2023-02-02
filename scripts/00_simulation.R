simulated_data <-
  tibble("Setting" = 1:100,
         "Cases" = floor(runif(100, min=0, max=100)),
         "Day Began" = sample(seq(as.Date('2020/01/01'), as.Date('2021/01/01'), by="day"), 100, replace = TRUE),
         "Day Over" = sample(seq(as.Date('2021/01/01'), as.Date('2022/01/01'), by="day"), 100, replace = TRUE))

simulated_data