# docker-images

This is the source code repository for custom Docker images that are built by extending official Docker images from reputed publisher like Bitnami.

You can find these images on Docker Hub at `https://hub.docker.com/u/bbccorp`


| Image    | Base Image    | Dockerfile      | Docker Hub Link |
| -------- | ------------- | --------------- |---------------- |
| Spark with PySpark dependencies | bitnami/spark:3.3.2 | [Spark-3.3.2 Dockerfile](./spark/Dockerfile) |  [DockerHub Link](https://hub.docker.com/repository/docker/bbccorp/spark) |
| Spark with Iceberg | tabulario/spark-iceberg | [Spark-3.3.2 with Apache Iceberg-1.2.1 and ECS Dockerfile](./spark_with_iceberg/Dockerfile) |  [DockerHub Link](https://hub.docker.com/repository/docker/bbccorp/spark-iceberg) |

-------------------

## Usage

### Spark with PySpark dependencies

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