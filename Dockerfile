FROM ubuntu:latest

RUN apt-get update && apt-get upgrade -y && apt-get install -y git python3 python3-pip python-is-python3 curl

WORKDIR /code

RUN git clone https://github.com/ScilifelabDataCentre/Covid_portal_vis.git

COPY *.sh *.py requirements.txt /code/

RUN pip3 install -r requirements.txt
RUN pip3 install -r Covid_portal_vis/Wordcloud/requirements.txt

RUN mkdir output

CMD ["/code/all.sh"]
