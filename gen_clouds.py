import os

import livewordcloud as lwc

PATH = os.environ.get("PYTHONPATH")
CODE_PATH = os.environ.get("CODE_PATH")

lwc.write_file(os.path.join(CODE_PATH, 'output/cloud_titles.png'), lwc.gen_wordcloud(field='title', data_folder=PATH))
lwc.write_file(os.path.join(CODE_PATH, 'output/cloud_abstracts.png'), lwc.gen_wordcloud(field='abstract', data_folder=PATH))
