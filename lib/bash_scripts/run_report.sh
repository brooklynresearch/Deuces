#!/usr/bin/bash
# A script to run the daily csv report

cd ~/Documents/Deuces/
rake daily_csv:run RAILS_ENV=production
