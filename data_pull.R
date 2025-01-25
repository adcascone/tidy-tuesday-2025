# Option 1: tidytuesdayR package 
## install.packages("tidytuesdayR")

tuesdata <- tidytuesdayR::tt_load('2025-01-28')
## OR
tuesdata <- tidytuesdayR::tt_load(2025, week = 4)

water_insecurity_2022 <- tuesdata$water_insecurity_2022
water_insecurity_2023 <- tuesdata$water_insecurity_2023

# Option 2: Read directly from GitHub

water_insecurity_2022 <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-01-28/water_insecurity_2022.csv')
water_insecurity_2023 <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-01-28/water_insecurity_2023.csv')