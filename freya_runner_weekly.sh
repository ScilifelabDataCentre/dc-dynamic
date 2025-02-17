export CODE_PATH=/code

# Wordclouds generator
PYTHONPATH="$CODE_PATH"/pathogens-portal-visualisations/Wordcloud python "$CODE_PATH"/pathogens-portal-visualisations/Wordcloud/livewordcloud.py

# Publication related updates
PYTHONPATH="$CODE_PATH"/pathogens-portal-visualisations/Count_publications python "$CODE_PATH"/pathogens-portal-visualisations/Count_publications/count_publications.py > "$CODE_PATH"/output/COVID_publication_count.json
PYTHONPATH="$CODE_PATH"/pathogens-portal-visualisations/Count_publications python "$CODE_PATH"/pathogens-portal-visualisations/Count_publications/gen_recent_pub.py > "$CODE_PATH"/output/covid-portal-recent10.json


# Upload generated files
for filename in $(ls $CODE_PATH/output) ; do
    curl "https://blobserver.dc.scilifelab.se/blob/$filename" -H "x-accesskey: $ACCESS_KEY" --upload-file "output/$filename"
done
