export CODE_PATH=/code

PYTHONPATH="$CODE_PATH"/covid-portal-visualisations/Wordcloud python "$CODE_PATH"/gen_clouds.py

# Auto update of vaccine page in covid portal
export VACCINE_SCRIPTS_PATH="$CODE_PATH"/covid-portal-visualisations/Vaccine_page

python "$VACCINE_SCRIPTS_PATH"/vaccine_indicator_barchart.py --output-dir $CODE_PATH/output
python "$VACCINE_SCRIPTS_PATH"/vaccine_livetext.py --output-dir $CODE_PATH/output
python "$VACCINE_SCRIPTS_PATH"/vaccine_timeseries_barchart.py --output-dir $CODE_PATH/output
python "$VACCINE_SCRIPTS_PATH"/vaccine_maps_population.py --output-dir $CODE_PATH/output
python "$VACCINE_SCRIPTS_PATH"/vaccine_heatmaps.py --output-dir $CODE_PATH/output

# Upload generated files
for filename in $(ls $CODE_PATH/output) ; do
    curl "https://blobserver.dckube.scilifelab.se/blob/$filename" -H "x-accesskey: $ACCESS_KEY" --upload-file "output/$filename"
done
