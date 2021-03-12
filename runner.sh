export CODE_PATH=/code

PYTHONPATH="$CODE_PATH"/Covid_portal_vis/Wordcloud python "$CODE_PATH"/gen_clouds.py
python "$CODE_PATH"/gen_symptoms_data.py > "$CODE_PATH"/output/covid-portal/symptoms-data.json
python "$CODE_PATH"/gen_publication_count.py > "$CODE_PATH"/output/covid-portal/publication-counts.json

chown -R 101.101 "$CODE_PATH"/output/*
