#!/bin/sh
git pull
git add phl_vacc_daily_data.zip
git commit -m "Daily commit"
git push -u origin main
