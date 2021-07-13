#!/bin/sh
cd ~/phl_covid/SARS-CoV-2-Regional-Metadata
#git pull | tee -a ~/debugging.log
git add .
git commit -m "daily update"
git push 2>&1 | tee -a ~/debugging.log
