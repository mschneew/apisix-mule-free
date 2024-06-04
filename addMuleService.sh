#!/bin/bash

cd ./mule/mule_projects/

echo "Please enter a directory name: "
read directory_name

if [ -d "$directory_name" ]; then
    echo "The directory '$directory_name' already exists."
else
    mkdir "$directory_name"
    echo "The directory '$directory_name' was successfully created."

    cd "$directory_name"

cat <<EOF >Dockerfile
FROM javastreets/mule:latest
COPY ./*jar /opt/mule/apps/
CMD ["/opt/mule/bin/mule"]
EOF
    echo "Dockerfile was created in the directory '$directory_name'."

    mkdir logs
    echo "A directory for logs was created in the directory '$directory_name'."

    echo "Please enter the full path for the JAR file you wish to copy: "
    read filepath

    cp "$filepath" .

    echo "The JAR file has been copied."

    cd ../../

    echo "Please enter a name for the mule service: "
    read mule_servicename

    if grep -q "  $mule_servicename:" ./docker-compose.yml; then
        echo "The service '$mule_servicename' already exists in the docker-compose.yml file."
    else
    {
        echo "  $mule_servicename:"
        echo "    restart: always"
        echo "    volumes:"
        echo "      - ./mule_projects/demo/logs:/opt/mule-standalone-4.4.0-20221024/logs"
        echo "    stdin_open: true"
        echo "    tty: true"
        echo "    build: mule_projects/$directory_name/"
        echo "    networks:"
        echo "      - apisix_mule"
        echo ""
    } >> ./docker-compose.yml

    echo "The service '$mule_servicename' was added to docker-compose.yml."
    fi
fi