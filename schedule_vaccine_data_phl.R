#######################################
# load library
#######################################

library(taskscheduleR)
library(here)

i_am("scripts/schedule_vaccine_data_phl.R")

#######################################
# create task for daily data pull
#######################################


taskscheduler_create(taskname = "phl_vacc_daily", 
                     rscript = here("scripts", "phl_vacc_absolute.R"),
                     schedule = "DAILY", starttime = "17:25", 
                     startdate = format(Sys.Date(), "%m/%d/%Y"),
                     modifier = 1)

# taskscheduler_runnow("phl_vacc_daily")
# taskscheduler_delete("phl_vacc_daily")
