FROM docker.io/bitnami/spark:3.3.2
LABEL maintainer "BBC <bedabrata.chatterjee@gmail.com>"

USER root
RUN install_packages curl build-essential libpq-dev python-dev vim iputils-ping

# Install Python dependencies
COPY requirements.txt .
RUN pip3 install -r requirements.txt

USER 1001
# Install the downloaded jars for this image
COPY ./jars /opt/bitnami/spark/jars/

COPY spark-defaults.conf /opt/bitnami/spark/conf
