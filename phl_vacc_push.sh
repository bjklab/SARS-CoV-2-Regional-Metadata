#!/bin/sh
cd ~/phl_covid/SARS-CoV-2-Regional-Metadata
git pull
git add .
git commit -m "daily update"

# use autoexpect tool to create .exp script
# .exp script stores and enters github credentials
#./github_push.exp
