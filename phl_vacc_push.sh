#!/bin/sh
cd ~/phl_covid/SARS-CoV-2-Regional-Metadata
git pull
git add phl_vacc_daily_data.zip
git commit -m "Update daily data"

# use autoexpect tool to create .exp script
# .exp script stores and enters github credentials
./github_push.exp
