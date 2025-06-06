export CODE_PATH=/code

# Wastewater SARS-CoV-2 quantification SLU
PYTHONPATH="$CODE_PATH"/pathogens-portal-visualisations/wastewater python "$CODE_PATH"/pathogens-portal-visualisations/wastewater/combined_slu_regular.py > "$CODE_PATH"/output/wastewater_combined_slu_regular.json

# Wastewater influenza quantification SLU
PYTHONPATH="$CODE_PATH"/pathogens-portal-visualisations/wastewater python "$CODE_PATH"/pathogens-portal-visualisations/wastewater/combined_slu_influenza_a.py > "$CODE_PATH"/output/wastewater_slu_infA.json
PYTHONPATH="$CODE_PATH"/pathogens-portal-visualisations/wastewater python "$CODE_PATH"/pathogens-portal-visualisations/wastewater/combined_slu_influenza_b.py > "$CODE_PATH"/output/wastewater_slu_infB.json

# Wastewater RSV quantification SLU
PYTHONPATH="$CODE_PATH"/pathogens-portal-visualisations/wastewater python "$CODE_PATH"/pathogens-portal-visualisations/wastewater/combined_slu_rsv.py > "$CODE_PATH"/output/wastewater_slu_rsv.json

# Serology statistics SARS-CoV-2
PYTHONPATH="$CODE_PATH"/pathogens-portal-visualisations/serology python "$CODE_PATH"/pathogens-portal-visualisations/serology/weekly-serology-tests.py > "$CODE_PATH"/output/weekly_serology_tests.json
PYTHONPATH="$CODE_PATH"/pathogens-portal-visualisations/serology python "$CODE_PATH"/pathogens-portal-visualisations/serology/cumulative-serology-tests.py > "$CODE_PATH"/output/cumulative_serology_tests.json

# ClinMicro statistics is based on these files under /pathogens-portal-visualisations/ClinMicro:
PYTHONPATH="$CODE_PATH"/pathogens-portal-visualisations/ClinMicro python "$CODE_PATH"/pathogens-portal-visualisations/ClinMicro/lineage-plotting-one.py > "$CODE_PATH"/output/lineage_one_wholetime.json
PYTHONPATH="$CODE_PATH"/pathogens-portal-visualisations/ClinMicro python "$CODE_PATH"/pathogens-portal-visualisations/ClinMicro/lineage-plotting-four.py > "$CODE_PATH"/output/lineage_four_recent.json
PYTHONPATH="$CODE_PATH"/pathogens-portal-visualisations/ClinMicro python "$CODE_PATH"/pathogens-portal-visualisations/ClinMicro/lineage-plotting-six.py > "$CODE_PATH"/output/lineage_six_recent.json

# Upload generated files
for filename in $(ls $CODE_PATH/output) ; do
    curl "https://blobserver.dc.scilifelab.se/blob/$filename" -H "x-accesskey: $ACCESS_KEY" --upload-file "output/$filename"
done
