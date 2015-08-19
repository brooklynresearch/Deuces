# Deuces
USOpen Charge Up Lockers

## Bash scripts

### keep_open
This will check to see if the server is running, and if not, will restart it.
Machine is set to run this every minute with a cron

To run manually:
```
sh ~/Documents/Deuces/lib/bash_scripts/keep_open.
```

### restart_deuces
This will kill and restart the app
It is not running on a cron

To run manually:
```
sh ~/Documents/Deuces/lib/bash_scripts/restart_deuces.sh
```


### potential issues
This was solved, but if it crops up again.
It postgresql server stops running, this should restart:
```
rm /usr/local/var/postgres/postmaster.pid
```
