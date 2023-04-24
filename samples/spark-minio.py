import os
from pyspark import SparkContext, SparkConf
from pyspark.sql import SparkSession


def get_spark_session():
    conf = (
        SparkConf()
        .setAppName("Spark-MinIO Test")
        .set("spark.hadoop.fs.s3a.endpoint", os.environ.get("S3_SERVER"))
        .set("spark.hadoop.fs.s3a.access.key", os.environ.get("S3_ACCESS_KEY"))
        .set("spark.hadoop.fs.s3a.secret.key", os.environ.get("S3_SECRET_KEY"))
        .set("spark.hadoop.fs.s3a.path.style.access", True)
        .set("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
    )

    sc = SparkContext(conf=conf).getOrCreate()
    sc.setLogLevel("ERROR")
    spark = SparkSession(sc)

    return spark


###############################################################################

if __name__ == "__main__":
    BUCKET_NAME = "test"
    TEST_FILE = "test-names.csv"

    spark = get_spark_session()

    header = ["name", "age"]
    sample_list = [("Mona", 20), ("Jennifer", 34), ("John", 20), ("Jim", 26)]

    # Create an RDD from the list
    rdd = spark.sparkContext.parallelize(sample_list)
    df = rdd.toDF(["name", "color"])

    df.write.mode("overwrite").csv(f"s3a://{BUCKET_NAME}/test-names.csv", header=True)
    df.write.mode("overwrite").parquet(f"s3a://{BUCKET_NAME}/test-names.parquet")

    # show data
    df.show()

###############################################################################
