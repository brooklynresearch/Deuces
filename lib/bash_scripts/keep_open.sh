#!/bin/sh
now=$(date +"%T")

if [ $(pg_isready | grep 'no response'| wc -l) -eq 0 ]
then
  echo "postgresql server is running @ $now"
else
  echo "going to restart postgres server in"
  for i in {3..1};
  do
    echo $i;
    sleep 1s
  done
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
fi


if [ $(netstat -an | grep 3000 | grep LISTEN | wc -l) -eq 0 ]
then
  cd ~/Documents/Deuces/
  echo 'killing current server'
  kill `cat tmp/pids/server.pid`
  echo 'restarting in'
  for i in {5..1};
  do
    echo $i;
    sleep 1s
  done
  echo "Starting Rails Server @ $now"
  rails server -b 0.0.0.0 -e production -d
else
  echo "Rails Server already running @ $now"
fi
