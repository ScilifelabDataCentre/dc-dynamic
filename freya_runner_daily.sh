export CODE_PATH=/code

# Update EBI index file
PYTHONPATH="$CODE_PATH"/pathogens-portal-scripts/EBI_indexing python "$CODE_PATH"/pathogens-portal-scripts/EBI_indexing/update_index_json.py

