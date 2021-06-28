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

write_csv(phl_vacc, paste("./phl_vacc_", Sys.Date(), 
                          ".csv", sep = ""))

files2zip <- list.files(path = "./", pattern = "csv")

zip(zipfile = "phl_vacc_daily_data.zip", files = files2zip)
