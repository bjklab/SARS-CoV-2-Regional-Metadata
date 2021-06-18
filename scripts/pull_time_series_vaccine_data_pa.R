##################################
# load libraries
##################################

library(tidyverse)
library(RSocrata)
library(MMWRweek)
library(readxl)


##################################
# load county-level population data (2019 Census estimate)
##################################

list.files(path = "./data/", pattern = "co-est", full.names = TRUE) %>%
  map(.f = ~ readxl::read_xlsx(.x, skip = 3)) %>%
  bind_rows() %>%
  rename(unit = `...1`,
         population = `2019`) %>%
  select(unit, population) %>%
  filter(grepl("Note|Suggested|Annual|Source|Release",unit) == FALSE) %>%
  mutate(region = ifelse(grepl("^\\.",unit), NA, unit)) %>%
  tidyr::fill(region, .direction = "down") %>%
  mutate(subregion = ifelse(grepl("^\\.",unit), unit, NA),
         subregion = gsub("^\\.| County, Delaware| County, New Jersey| County, Pennsylvania","",subregion)) %>%
  filter(!is.na(subregion)) %>%
  select(region, subregion, population) %>%
  mutate(state = case_when(region == "Delaware" ~ "DE",
                           region == "New Jersey" ~ "NJ",
                           region == "Pennsylvania" ~ "PA"),
         county = paste0(subregion, " County")) %>%
  identity() -> delval_county_pop
delval_county_pop




##################################
# load Socrata credentials (stored locally, out of repo)
##################################

creds <- read_csv("../pa_doh_socrata_credentials.csv")


##################################
# pull data through Socrata API

# restrict to counties of interest

# add MMWRweek formatting
##################################

pa_vacc <- read.socrata("https://data.pa.gov/resource/bicw-3gwi.csv", 
                        app_token = creds$app_token[1],
                        email = creds$email[1], 
                        password = creds$password[1]) %>%
  # leaving without county filter for now because may expand catchment
  #filter(county %in% c("Philadelphia", "Bucks", "Montgomery", "Chester", "Delaware")) %>%
  mutate(county = paste0(county, " County"),
         state = "PA") %>%
  left_join(select(delval_county_pop, population, state, county), by = c("state","county")) %>%
  mutate(MMWRweek(date)) %>%
  rename_at(.vars = vars(contains("MMWR")), .funs = ~ gsub("mmwr","mmwr_",tolower(.x))) %>%
  mutate(year_week = paste0(mmwr_year, " - ", mmwr_week)) %>%
  as_tibble()

pa_vacc


pa_vacc %>%
  write_csv(file = "./data/pa_vacc/pa_vacc_update.csv.gz")

pa_vacc %>%
  qplot(data = ., x = date, y = fullycovered, color = county, geom = c("point","line"))
