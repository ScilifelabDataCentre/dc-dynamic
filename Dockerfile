FROM ubuntu:latest

RUN apt-get update

RUN apt-get install -y git cron python3 python3-pip python-is-python3

RUN apt-get update && apt-get upgrade -y

WORKDIR /code

COPY *.sh /code/
COPY *.py /code/

RUN git clone https://github.com/ScilifelabDataCentre/Covid_portal_vis.git

RUN pip3 install -r Covid_portal_vis/Wordcloud/requirements.txt

CMD ["/code/start.sh"]
