##################################
# load libraries
##################################
library(tidyverse)
library(readxl)
library(gt)
library(rvest)
library(V8)

set.seed(16)


##################################
# load, filter, format google mobility data
##################################

vroom::vroom("https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv") %>%
  janitor::clean_names() %>%
  identity() -> gmob

gmob

gmob %>%
  filter(country_region == "United States") %>%
  filter(sub_region_1 %in% c("New Jersey", "Pennsylvania", "Delaware")) %>%
  mutate(state = case_when(sub_region_1 == "New Jersey" ~ "NJ",
                           sub_region_1 == "Pennsylvania" ~ "PA",
                           sub_region_1 == "Delaware" ~ "DE"),
         county = sub_region_2) %>%
  identity() -> gmob_delval

gmob_delval


gmob_delval %>%
  write_csv("./data/google_mobility/delval_google_mobility.csv.gz")


##################################
# load, filter, format apple mobility data
##################################

link <- 'https://covid19.apple.com/mobility'

json_link <- "https://covid19-static.cdn-apple.com/covid19-mobility-data/current/v3/index.json"


