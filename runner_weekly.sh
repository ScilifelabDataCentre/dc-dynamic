export CODE_PATH=/code

PYTHONPATH="$CODE_PATH"/covid-portal-visualisations/Wordcloud python "$CODE_PATH"/gen_clouds.py

# Upload generated files
for filename in $(ls $CODE_PATH/output) ; do
    curl "https://blobserver.dckube.scilifelab.se/blob/$filename" -H "x-accesskey: $ACCESS_KEY" --upload-file "output/$filename"
done

# Auto update of vaccine page in covid portal

cd $CODE_PATH

export VACCINE_SCRIPTS_PATH="$CODE_PATH"/covid-portal-visualisations/Vaccine_page

python "$VACCINE_SCRIPTS_PATH"/vaccine_indicator_barchart.py
python "$VACCINE_SCRIPTS_PATH"/vaccine_livetext.py
python "$VACCINE_SCRIPTS_PATH"/vaccine_timeseries_barchart.py
python "$VACCINE_SCRIPTS_PATH"/vaccine_maps_population.py
python "$VACCINE_SCRIPTS_PATH"/vaccine_heatmaps.py

for filename in $(ls $CODE_PATH/vaccine_plots) ; do
    curl "https://blobserver.dckube.scilifelab.se/blob/$filename" -H "x-accesskey: $ACCESS_KEY" --upload-file "$CODE_PATH/vaccine_plots/$filename"
done
