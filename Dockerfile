FROM ubuntu:latest

RUN apt-get update

RUN apt-get install -y git

WORKDIR /code

COPY crontab /etc/cron.d/hello-cron

COPY runner.sh /code/runner.sh

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/hello-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

RUN git clone https://github.com/ScilifelabDataCentre/Covid_portal_vis.git

RUN apt-get update && apt-get upgrade -y

RUN apt install -y python

CMD cron && tail -f /var/log/cron.log
