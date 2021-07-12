#!/bin/sh
cd ~/phl_covid/SARS-CoV-2-Regional-Metadata
git pull
git add .
git commit -m "daily update"
git push -u origin main

