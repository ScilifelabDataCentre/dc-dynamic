export CODE_PATH=/code

# Feed SciLifeLab figshare data to Slack
python "$CODE_PATH"/slack_figshare.py

# Update EBI index file
PYTHONPATH="$CODE_PATH"/pathogens-portal-scripts/EBI_indexing python "$CODE_PATH"/pathogens-portal-scripts/EBI_indexing/update_index_json.py
