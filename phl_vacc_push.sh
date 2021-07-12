#!/bin/sh
cd ~/phl_covid/SARS-CoV-2-Regional-Metadata
git pull | tee -a ~/debugging.log
git add . | tee - a ~/debugging.log
git commit -m "daily update" | tee -a ~/debugging.log
git push -u origin main | tee -a ~/debugging.log

