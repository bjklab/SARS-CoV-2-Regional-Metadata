#!/bin/sh
echo "RUNNING SCRIPT"
cd ~/phl_covid/SARS/CoV-2-Regional-Metadata
git pull
git add phl_vacc_daily_data.zip
git commit -m "Daily commit"
./github_push.exp
