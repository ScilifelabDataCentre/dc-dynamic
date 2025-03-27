export CODE_PATH=/code

# Feed SciLifeLab figshare data to Slack
python "$CODE_PATH"/slack_figshare.py

# Post items from SciLifeLab feed to Slack channel
python "$CODE_PATH"/slack_feeds.py $CODE_PATH/output


# Upload generated files
for filename in $(ls $CODE_PATH/output) ; do
    curl "https://blobserver.dc.scilifelab.se/blob/$filename" -H "x-accesskey: $ACCESS_KEY" --upload-file "output/$filename"
done