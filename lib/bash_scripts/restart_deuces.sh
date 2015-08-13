#!/usr/bin/bash
# A script to kill and restart the rails server

cd ~/Documents/workspace/Deuces/
echo 'killing current server'
kill `cat tmp/pids/server.pid`
echo 'restarting in'

for i in {10..1};
do
  echo $i;
  sleep 1s
done
rails server -e production
