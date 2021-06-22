#####################
# load libraries
#####################

# remotes::install_github("CityOfPhiladelphia/rphl")
library(rphl)
library(tidyverse)
library(zip)

proj_dir <- "L:/PHL-COVID/SARS-CoV-2-Regional-Metadata/"


#######################################
# pull PHL vaccine data using Carto API
#######################################

phl_vacc <- get_carto(query = "SELECT * FROM covid_vaccines_by_zip", 
                      format = "csv",
                      base_url = "https://phl.carto.com/api/v2/sql", 
                      stringsAsFactors = F)

#######################################
# export and zip with previous files
#######################################

write_csv(phl_vacc, paste(proj_dir, "phl_vacc_", Sys.Date(), 
                          ".csv", sep = ""))

unlink(paste(proj_dir, "phl_vacc_daily_data.zip", sep = ""))
setwd(paste(proj_dir, sep = ""))
files2zip <- list.files(path = proj_dir, pattern = "csv")
zip(zipfile = "phl_vacc_daily_data.zip", files = files2zip)
