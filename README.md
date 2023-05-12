DC dynamic
==========

This repository contains code to generate a docker container for running jobs. By default it runs the commands in `all.sh` when started.

`ACCESS_KEY` should be set for the container, defining the access key to use for Blobserver.

There are two cronjobs active on the cluster. No persistent storage is provided, so any generated files should be uploaded somewhere to be saved.

### cron-daily

Runs the commands in the file `runner_daily.sh` on `0 4 * * * ` (04:00 every morning).

Any files put in `$CODE_PATH/output` will be uploaded to Blobserver using the dc-dynamic account.

### cron-weekly

Runs the commands in the file `runner_weekly.sh` on `0 4 * * 5 ` (04:00 every Friday morning).

Any files put in `$CODE_PATH/output` will be uploaded to Blobserver using the dc-dynamic account.

### cron-every10minutes

Runs the commands in the file `runner_every10mins.sh` on `*/10 * * * * ` (Every ten minutes)


## Adding jobs

Add new commands to the above files to have them running on schedule. If you need jobs to run on a different schedule, talk to @talavis.

Make sure that the `requirements.txt` file in dc-dynamic contains all modules required for your code **and** that any changes do not break the current code.

### Uploading files

Th easiest way to upload files is to use curl:

```bash
curl "https://blobserver.dc.scilifelab.se/blob/$filename" -H "x-accesskey: $ACCESS_KEY" --upload-file "$filename"
```

Feel free to set new variables, but remember to tell @talavis if you need them to be set for the cronjobs on the cluster.

## Eventual aim for this repository

Files for running jobs should be held here. We should link to scripts elsewhere to avoid the duplication of e.g. visualisation scripts.
