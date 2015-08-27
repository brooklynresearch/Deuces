#!/usr/bin/bash
# A script to kill and restart the rails server

now=$(date +"%T")

if [ $(pg_isready | grep 'accepting connections'| wc -l) -eq 0 ]
then
  echo "going to restart postgres server in"
  for i in {3..1};
  do
    echo $i;
    sleep 1s
  done
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
else
  echo "postgresql server is running @ $now"
fi


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
