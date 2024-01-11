export CODE_PATH=/code

PYTHONPATH="$CODE_PATH"/pathogens-portal-visualisations/Wordcloud python "$CODE_PATH"/gen_clouds.py

# Publication related updates
python "$CODE_PATH"/gen_publication_count.py > "$CODE_PATH"/output/covid-portal-publication-counts.json
python "$CODE_PATH"/gen_recent_pub.py > "$CODE_PATH"/output/covid-portal-recent10.json

# Upload generated files
for filename in $(ls $CODE_PATH/output) ; do
    curl "https://blobserver.dc.scilifelab.se/blob/$filename" -H "x-accesskey: $ACCESS_KEY" --upload-file "output/$filename"
done
