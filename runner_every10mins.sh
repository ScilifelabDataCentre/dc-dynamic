export CODE_PATH=/code

PYTHONPATH="$CODE_PATH"/covid-portal-visualisations/wastewater python "$CODE_PATH"/covid-portal-visualisations/wastewater/combined_slu_logyaxis.py > "$CODE_PATH"/output/wastewater_combined_slu_logyaxis.json
PYTHONPATH="$CODE_PATH"/covid-portal-visualisations/wastewater python "$CODE_PATH"/covid-portal-visualisations/wastewater/combined_slu_regular.py > "$CODE_PATH"/output/wastewater_combined_slu_regular.json
PYTHONPATH="$CODE_PATH"/covid-portal-visualisations/wastewater python "$CODE_PATH"/covid-portal-visualisations/wastewater/combined_stockholm_logyaxis.py > "$CODE_PATH"/output/wastewater_stockholm_logyaxis.json
PYTHONPATH="$CODE_PATH"/covid-portal-visualisations/wastewater python "$CODE_PATH"/covid-portal-visualisations/wastewater/combined_stockholm_regular.py > "$CODE_PATH"/output/wastewater_combined_stockholm.json
PYTHONPATH="$CODE_PATH"/covid-portal-visualisations/wastewater python "$CODE_PATH"/covid-portal-visualisations/wastewater/gothenburg_covid.py > "$CODE_PATH"/output/wastewater_gothenburg.json
PYTHONPATH="$CODE_PATH"/covid-portal-visualisations/wastewater python "$CODE_PATH"/covid-portal-visualisations/wastewater/quant_malmo_kthplot.py > "$CODE_PATH"/output/wastewater_kthmalmo.json
# Upload generated files
for filename in $(ls $CODE_PATH/output) ; do
    curl "https://blobserver.dc.scilifelab.se/blob/$filename" -H "x-accesskey: $ACCESS_KEY" --upload-file "output/$filename"
done
