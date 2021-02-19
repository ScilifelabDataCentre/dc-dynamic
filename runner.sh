export CODE_PATH=/code

PYTHONPATH="$CODE_PATH"/Covid_portal_vis/Wordcloud python "$CODE_PATH"/gen_clouds.py

chown -R 101.101 "$CODE_PATH"/output/*
