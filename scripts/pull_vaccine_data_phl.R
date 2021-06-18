#######################################
# install rphl from GitHub
#######################################

#install.packages("remotes")
remotes::install_github("CityOfPhiladelphia/rphl")
library(rphl)
library(tidyverse)
library(zipcodeR)
library(MMWRweek)


#######################################
# zip code population data from US Census (2010)
#######################################

zipcodeR::zip_code_db %>%
  as_tibble() %>%
  identity() -> zip_db




#######################################
# pull PHL vaccine data using Carto API
#######################################

#query <- "SELECT * FROM covid_vaccines_by_zip WHERE etl_timestamp = '2021-05-24 17:20:02'"
#query <- "SELECT * FROM covid_vaccines_by_zip WHERE etl_timestamp < '2021-05-28 00:00:00'"
query <- "SELECT * FROM covid_vaccines_by_zip"

phl_vacc <- get_carto(query, format = "csv",
                 base_url = "https://phl.carto.com/api/v2/sql", 
                 stringsAsFactors = F) %>%
  as_tibble() %>%
  mutate(zip_code = as.character(zip_code)) %>%
  left_join(select(zip_db, zipcode, population, county, state), by = c("zip_code" = "zipcode")) %>%
  mutate(date = as.Date(etl_timestamp, format = "%Y-%m-%d")) %>%
  mutate(MMWRweek(date)) %>%
  rename_at(.vars = vars(contains("MMWR")), .funs = ~ gsub("mmwr","mmwr_",tolower(.x))) %>%
  mutate(year_week = paste0(mmwr_year, " - ", mmwr_week))

phl_vacc

phl_vacc %>%
  write_csv(file = paste0("./data/phl_vacc/phl_vacc_update_",Sys.Date(),".csv"))
