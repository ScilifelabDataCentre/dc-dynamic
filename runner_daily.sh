export CODE_PATH=/code

python "$CODE_PATH"/gen_symptoms_data.py > "$CODE_PATH"/output/covid-portal-symptoms-data.json
python "$CODE_PATH"/gen_publication_count.py > "$CODE_PATH"/output/covid-portal-publication-counts.json
python "$CODE_PATH"/gen_recent_pub.py > "$CODE_PATH"/output/covid-portal-recent10.json
PYTHONPATH="$CODE_PATH"/covid-portal-visualisations/map python "$CODE_PATH"/covid-portal-visualisations/map/symptoms_map_English.py > "$CODE_PATH"/output/symptoms_map_english.json
PYTHONPATH="$CODE_PATH"/covid-portal-visualisations/map python "$CODE_PATH"/covid-portal-visualisations/map/symptoms_map_Swedish.py > "$CODE_PATH"/output/symptoms_map_swedish.json

# Upload generated files
for filename in $(ls $CODE_PATH/output) ; do
    curl "https://blobserver.dckube.scilifelab.se/blob/$filename" -H "x-accesskey: $ACCESS_KEY" --upload-file "output/$filename"
done

python "$CODE_PATH"/slack_figshare.py
