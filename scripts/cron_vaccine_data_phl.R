#######################################
# load library
#######################################

library(cronR)
library(here)

i_am("scripts/cron_vaccine_data_phl.R")

#######################################
# create task for daily data pull
#######################################

# Daily cron job to fetch vaccinations
cmd_vaccs <- cron_rscript(rscript = stringr::str_c(Sys.getenv("COVID19PHILLY_DIR"),
                                                   "philadelphia_covid19_vaccinations_cron.R"))
cron_add(command = cmd_vaccs, frequency = 'daily', at='2PM', id = 'covid19_vaccinations')