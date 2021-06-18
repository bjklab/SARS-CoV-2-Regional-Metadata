##################################
# load libraries
##################################
library(tidyverse)
library(readxl)
library(gt)

set.seed(16)


##################################
# load google vaccination data
##################################

fips_key <- as_tibble(maps::county.fips) %>%
  mutate(fips_num = fips) %>%
  mutate(county = map_chr(polyname, ~ stringr::str_split_fixed(string = .x, pattern = ",", n = 2)[2]),
         county = paste0(stringr::str_to_title(county), " County"))
fips_key


vax <- read_csv(file = url("https://storage.googleapis.com/covid19-open-data/v2/vaccinations.csv"))

vax %>%
  mutate(state = case_when(grepl("US_PA",key) ~ "PA",
                           grepl("US_NJ",key) ~ "NJ",
                           grepl("US_DE",key) ~ "DE")) %>%
  filter(!is.na(state)) %>%
  mutate(fips_num = readr::parse_number(key)) %>%
  left_join(select(fips_key, fips_num, county), by = "fips_num") %>%
  identity() -> vax_delval
vax_delval


vax_delval %>%
  write_csv(file = "./data/google_vacc/google_vacc_update.csv.gz")


vax_delval %>%
  filter(!is.na(county)) %>%
  select(state, county, total_persons_fully_vaccinated, new_persons_fully_vaccinated) %>%
  rename_all(.funs = ~ stringr::str_to_title(gsub(pattern = "_", replacement = " ", .x))) %>%
  gt() %>%
  gt::fmt_missing(columns = gt::everything()) %>%
  gt::gtsave(file = paste0("./tabs/delval_google_vacc_update_",Sys.Date(),".html")) 


vax_delval %>%
  filter(new_persons_fully_vaccinated >= 0 & new_persons_fully_vaccinated < 1e5) %>%
  qplot(data = ., x = date, y = new_persons_fully_vaccinated, color = key, facets = ~ state, geom = c("point","line"))
