#!/bin/bash

/code/runner_daily.sh >> /var/log/cron.log 2>&1
/code/runner_weekly.sh >> /var/log/cron.log 2>&1

echo "0 4 * * 5 /code/runner_weekly.sh >> /var/log/cron.log 2>&1
0 4 * * * /code/runner_daily.sh >> /var/log/cron.log 2>&1
" > todo.txt

crontab todo.txt
cron -f
