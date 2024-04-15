export CODE_PATH=/code

python "$CODE_PATH"/slack_figshare.py

PYTHONPATH="$CODE_PATH"/pathogens-portal-scripts/EBI_indexing python "$CODE_PATH"/pathogens-portal-scripts/EBI_indexing/update_index_json.py
