#!/usr/bin/bash
# A script to kill and restart the rails server

cd ~/Documents/Deuces/
echo 'killing current server'
kill `cat tmp/pids/server.pid`
echo 'restarting in'

for i in {5..1};
do
  echo $i;
  sleep 1s
done
rails server -b 0.0.0.0 -e production -d
