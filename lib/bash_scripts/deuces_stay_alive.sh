#!/usr/bin/bash
# A script to keep alive rails server

if [ $(netstat -an | grep 3000 | grep LISTEN | wc -l) -eq 0 ]
then
  cd ~/Documents/Deuces/
  echo 'killing current server'
  kill `cat tmp/pids/server.pid`
  echo 'restarting in'
  for i in {3..1};
  do
    echo $i;
    sleep 1s
  done
  rails server -b 0.0.0.0 -e production -d
fi
