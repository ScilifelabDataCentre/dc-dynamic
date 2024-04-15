FROM python:3.10.8

RUN apt-get update && apt-get upgrade -y && apt-get install -y git curl

WORKDIR /code

RUN git clone https://github.com/ScilifelabDataCentre/pathogens-portal-visualisations.git && \
    git clone https://github.com/ScilifelabDataCentre/pathogens-portal-scripts.git

COPY *.sh *.py requirements.txt /code/

RUN pip install -r requirements.txt && \
    mkdir output

CMD ["/code/all.sh"]
