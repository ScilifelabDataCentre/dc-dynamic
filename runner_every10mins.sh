export CODE_PATH=/code

# Covid quatification SLU
PYTHONPATH="$CODE_PATH"/covid-portal-visualisations/wastewater python "$CODE_PATH"/covid-portal-visualisations/wastewater/combined_slu_regular.py > "$CODE_PATH"/output/wastewater_combined_slu_regular.json
# Covid quatification KTH
PYTHONPATH="$CODE_PATH"/covid-portal-visualisations/wastewater python "$CODE_PATH"/covid-portal-visualisations/wastewater/combined_stockholm_regular.py > "$CODE_PATH"/output/wastewater_combined_stockholm.json
PYTHONPATH="$CODE_PATH"/covid-portal-visualisations/wastewater python "$CODE_PATH"/covid-portal-visualisations/wastewater/quant_malmo_kthplot.py > "$CODE_PATH"/output/wastewater_kthmalmo.json
# Covid quatification GU
PYTHONPATH="$CODE_PATH"/covid-portal-visualisations/wastewater python "$CODE_PATH"/covid-portal-visualisations/wastewater/gothenburg_covid.py > "$CODE_PATH"/output/wastewater_gothenburg.json
# Enteric virus GU
PYTHONPATH="$CODE_PATH"/covid-portal-visualisations/wastewater python "$CODE_PATH"/covid-portal-visualisations/wastewater/enteric_viruses_gu.py > "$CODE_PATH"/output/enteric_graph_gu.json
# Influenza virus SLU
PYTHONPATH="$CODE_PATH"/covid-portal-visualisations/wastewater python "$CODE_PATH"/covid-portal-visualisations/wastewater/combined_slu_influenza_a.py > "$CODE_PATH"/output/wastewater_slu_infA.json
PYTHONPATH="$CODE_PATH"/covid-portal-visualisations/wastewater python "$CODE_PATH"/covid-portal-visualisations/wastewater/combined_slu_influenza_b.py > "$CODE_PATH"/output/wastewater_slu_infB.json


# Upload generated files
for filename in $(ls $CODE_PATH/output) ; do
    curl "https://blobserver.dc.scilifelab.se/blob/$filename" -H "x-accesskey: $ACCESS_KEY" --upload-file "output/$filename"
done
