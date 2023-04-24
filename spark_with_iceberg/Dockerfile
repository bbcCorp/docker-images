FROM tabulario/spark-iceberg:latest
LABEL maintainer "BBC <bedabrata.chatterjee@gmail.com>"

# Install Python dependencies
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Install the downloaded jars for this image
COPY ./jars /opt/spark/jars/

COPY .pyiceberg.yaml /root/.pyiceberg.yaml  