#!/bin/bash

/code/runner.sh >> /var/log/cron.log 2>&1

echo "0 4 * * 5 /code/runner.sh >> /var/log/cron.log 2>&1
" > todo.txt

crontab todo.txt
cron -f
