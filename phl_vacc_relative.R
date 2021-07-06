#####################
# load libraries
#####################

# remotes::install_github("CityOfPhiladelphia/rphl")
library(rphl)
library(tidyverse)
library(zip)


#######################################
# pull PHL vaccine data using Carto API
#######################################

phl_vacc <- get_carto(query = "SELECT * FROM covid_vaccines_by_zip", 
                      format = "csv",
                      base_url = "https://phl.carto.com/api/v2/sql", 
                      stringsAsFactors = F)

#######################################
# export and zip file
#######################################

write_csv(phl_vacc, paste("./raw_phl_vacc_data/phl_vacc_", Sys.Date(), 
                          ".csv", sep = ""))

files2zip <- list.files(path = "./raw_phl_vacc_data", pattern = "csv", full.names = TRUE)

zip(zipfile = "phl_vacc_daily_data.zip", files = files2zip, root = ".",
    mode = "cherry-pick") 

