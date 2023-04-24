JARS_DIRECTORY="./jars"
mkdir -p ${JARS_DIRECTORY}


download_jar_file() {
    # Download the jar files if they are not available

    FILE=${JARS_DIRECTORY}/${1}
    if [ -f $FILE ]; then
        echo "File $FILE exists."
    else
        echo "File $FILE does not exist. Downloading from ${2}"
        curl ${2} --output ${FILE}

    fi
}

# Download the jar files needed for the Docker image
download_jar_file  "postgresql-42.6.0.jar" "https://repo1.maven.org/maven2/org/postgresql/postgresql/42.6.0/postgresql-42.6.0.jar" 

download_jar_file   "httpclient5-5.2.1.jar" "https://repo1.maven.org/maven2/org/apache/httpcomponents/client5/httpclient5/5.2.1/httpclient5-5.2.1.jar"
download_jar_file   "joda-time-2.12.5.jar" "https://repo1.maven.org/maven2/joda-time/joda-time/2.12.5/joda-time-2.12.5.jar"

download_jar_file   "aws-java-sdk-s3-1.12.454.jar" "https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-s3/1.12.454/aws-java-sdk-s3-1.12.454.jar"

AWS_JAVA_SDK_VERSION=1.12.454
download_jar_file   "aws-java-sdk-bundle-${AWS_JAVA_SDK_VERSION}.jar" "https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_JAVA_SDK_VERSION}/aws-java-sdk-bundle-${AWS_JAVA_SDK_VERSION}.jar" 
download_jar_file   "aws-java-sdk-core-${AWS_JAVA_SDK_VERSION}.jar" "https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-core/${AWS_JAVA_SDK_VERSION}/aws-java-sdk-core-${AWS_JAVA_SDK_VERSION}.jar" 


EMC_OBJECT_CLIENT_VERSION=3.4.5
download_jar_file  "object-client-${EMC_OBJECT_CLIENT_VERSION}.jar" "https://repo1.maven.org/maven2/com/emc/ecs/object-client/${EMC_OBJECT_CLIENT_VERSION}/object-client-${EMC_OBJECT_CLIENT_VERSION}.jar" 

# Validate docker is on
if ! docker info > /dev/null 2>&1; then
  echo "The docker daemon is not running or accessible. Please start docker and rerun."
  usage
fi


# Default repository remote name
REPOSITORY="bbccorp"
IMAGE_NAME="spark-iceberg"
TAG="tabulario-spark_3.3.2-iceberg_1.2.1-postgresql_42.6.0"

# Now build the image
echo "Building image ${IMAGE_NAME}:${TAG} "
docker buildx build -t ${IMAGE_NAME}:${TAG}  .

# # tag it as latest
docker tag ${IMAGE_NAME}:${TAG} ${REPOSITORY}/${IMAGE_NAME}:${TAG}
docker tag ${IMAGE_NAME}:${TAG} ${REPOSITORY}/${IMAGE_NAME}:latest
 
# Now push the image
docker push --all-tags ${REPOSITORY}/${IMAGE_NAME}