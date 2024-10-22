DC dynamic
==========

This repository contains scripts to be run as cron jobs.

`ACCESS_KEY` should be set for the container, defining the access key to use for Blobserver.

No persistent storage is provided, so any generated files should be uploaded somewhere to be saved.

### cron run every 10 minutes

#### freya_runner_every10mins.sh

Runs the scripts created by team Freya on `*/10 * * * *` (Every ten minutes)

Any files put in `$CODE_PATH/output` will be uploaded to Blobserver using the dc-dynamic account.

### cron run hourly

#### slack_runner_hourly.sh

Runs the script `slack_feeds.py` on `40 * * * *` (Every hour at 40th minute)

**slack_feeds.py** - Script to post message about new feeds (events/jobs) on SciLifeLab web to configured slack channel

### cron run daily

#### freya_runner_daily.sh

Runs the script created by team Freya on `0 7 * * *` (07:00 GMT).

Any files put in `$CODE_PATH/output` will be uploaded to Blobserver using the dc-dynamic account.

#### slack_runner_daily.sh

Runs the script `slack_figshare.py` on `0 6 * * *` (06:00 GMT)

**slack_figshare.py** - Script to post message about new items in figshare to configured slack channel

### cron run weekly

#### freya_runner_weekly.sh

Runs the script created by team Freya on `0 4 * * 5 ` (04:00 GMT every Friday morning).

Any files put in `$CODE_PATH/output` will be uploaded to Blobserver using the dc-dynamic account.


## Adding jobs

Add new commands to the above files to have them running on schedule. If you need jobs to run on a different schedule, talk to Sys admins or team Freya.

Make sure that the `requirements.txt` file in dc-dynamic contains all modules required for the native scripts (i.e. residing in dc-dynamic repo) **and** that any changes do not break the current code.

### Uploading files

Th easiest way to upload files is to use curl:

```bash
curl "https://blobserver.dc.scilifelab.se/blob/$filename" -H "x-accesskey: $ACCESS_KEY" --upload-file "$filename"
```

Feel free to set new variables, but remember to tell Sys admins or team Freya if you need them to be set for the cronjobs on the cluster.
