#!/bin/sh
rm /usr/local/var/postgres/postmaster.pid
sleep 5s
launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
sleep 5s
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
