# docker-images

This is the source code repository for custom Docker images that we built by extending official Docker images from reputed publisher like Bitnami and other product vendors.

You can find these images on Docker Hub at `https://hub.docker.com/u/bbccorp`


| Image Name  | Description | Base Image    | Dockerfile      | Docker Hub Link |
| -------- | ------------- | --------------- |---------------- | --------------- |
| bbccorp/spark:latest | Spark with PySpark dependencies | bitnami/spark:3.3.2 | [Spark-3.3.2 Dockerfile](./spark/Dockerfile) |  [DockerHub Link](https://hub.docker.com/repository/docker/bbccorp/spark) |
| bbccorp/spark-iceberg:latest | Spark with Iceberg | tabulario/spark-iceberg | [Spark-3.3.2 with Apache Iceberg-1.2.1 and ECS Dockerfile](./spark_with_iceberg/Dockerfile) |  [DockerHub Link](https://hub.docker.com/repository/docker/bbccorp/spark-iceberg) |

-------------------

## Usage

### Spark with PySpark dependencies

We will use the [docker-compose-spark.yml](./docker-compose-spark.yml) file to bring up a Spark cluster with Minio server.

```bash
$ docker-compose -f ./docker-compose-spark.yml up -d

Creating network "docker-images_spark_net" with the default driver
Creating minio ... done
Creating mc           ... done
Creating spark-master ... done
Creating spark-worker-1 ... done


# Now lets get into the shell of the spark-master container
$ docker exec -it spark-master /bin/bash            

# We can execute the sample code located in samples folder to access the minio server
I have no name!@0b99718d5889:/opt/bitnami/spark$ spark-submit samples/spark-minio.py
SparkContext: Running Spark version 3.3.2
...

+--------+-----+
|    name|color|
+--------+-----+
|    Mona|   20|
|Jennifer|   34|
|    John|   20|
|     Jim|   26|
+--------+-----+

# Let's exit the shell
I have no name!@0b99718d5889:/opt/bitnami/spark$ exit
exit


# Now we can bring down the setup
$ docker-compose -f ./docker-compose-spark.yml down 

```

The [spark-minio.py](./samples/spark-minio.py) file has the sample code to write csv and parquet files to a Minio server using Spark.

--------------

### Spark with Iceberg

We will use the [docker-compose-spark-iceberg.yml](./docker-compose-spark-iceberg.yml) file to bring up a Spark cluster with Iceberg runtime and Minio server.

```bash
# Bring up the spark-iceberg instances
$ docker-compose -f ./docker-compose-spark-iceberg.yml up -d

# Now login to the spark-iceberg container
$ docker exec -it spark-iceberg spark-sql

spark-sql> CREATE TABLE demo.nyc.taxis
         > (
         >   vendor_id bigint,
         >   trip_id bigint,
         >   trip_distance float,
         >   fare_amount double,
         >   store_and_fwd_flag string
         > )
         > PARTITIONED BY (vendor_id);
Time taken: 2.606 seconds
...

```

----------------

## References

* [Bitnami Spark Docker container](https://bitnami.com/stack/spark/containers)
* [Bitnami Spark Docker image](https://github.com/bitnami/containers/tree/main/bitnami/spark)
* [Apache Iceberg Quickstart](https://iceberg.apache.org/spark-quickstart/)
* [Apache Iceberg Docker repo](https://github.com/tabular-io/docker-spark-iceberg)

----------
