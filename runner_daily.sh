export CODE_PATH=/code

python "$CODE_PATH"/gen_symptoms_data.py > "$CODE_PATH"/output/covid-portal/symptoms-data.json
python "$CODE_PATH"/gen_publication_count.py > "$CODE_PATH"/output/covid-portal/publication-counts.json
python "$CODE_PATH"/gen_recent_pub.py > "$CODE_PATH"/output/covid-portal/recent10.json

chown -R 101.101 "$CODE_PATH"/output/*
