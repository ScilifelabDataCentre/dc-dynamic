export CODE_PATH=/code

PYTHONPATH="$CODE_PATH"/Covid_portal_vis/Wordcloud python "$CODE_PATH"/gen_clouds.py

# Upload generated files
for filename in $(ls $CODE_PATH/output) ; do
    curl "https://blobserver.dckube.scilifelab.se/blob/$filename" -H "x-accesskey: $ACCESS_KEY" --upload-file "output/$filename"
done
