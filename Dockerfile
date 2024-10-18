FROM python:3.10.8

RUN apt-get update && apt-get upgrade -y && apt-get install -y git curl

WORKDIR /code

RUN git clone https://github.com/ScilifelabDataCentre/pathogens-portal-visualisations.git && \
    git clone https://github.com/ScilifelabDataCentre/pathogens-portal-scripts.git

# Install Python dependencies from the current directory and both repositories
COPY requirements.txt /code/
RUN pip install -r requirements.txt && \
    pip install -r pathogens-portal-visualisations/requirements.txt && \
    pip install -r pathogens-portal-scripts/requirements.txt

# Copy other necessary files to the /code directory
COPY *.sh *.py /code/

# Create an output directory if needed
RUN mkdir /code/output