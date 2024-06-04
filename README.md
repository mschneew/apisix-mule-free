# Install Docker & Docker-Compose
## Win10
### Docker-Desktop
https://docs.docker.com/desktop/install/windows-install/
## Ubuntu
### Docker Engine
https://docs.docker.com/engine/install/ubuntu/
### Docker-Compose
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04

## Sudo privileges
Follow these steps: [Manage Docker as a non-root user](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)


# Clone project
## Clone
To clone the repository
```sh
git clone https://innersource.soprasteria.com/julian.wischnat/apisix-mule.git
```
If the cloning of the repository should fail, this can be due to the following reasons:
1. VPN connection to Sopra Steria network

## Download
Alternatively, you can also download the zip file.
### Win10
CMD:
```sh
curl.exe -o apisix-mule-master.zip https://innersource.soprasteria.com/julian.wischnat/apisix-mule/-/archive/master/apisix-mule-master.zip
```
Terminal(Ubuntu):
```sh
cp /mnt/c/Users/{windows_username}/{windows_path}/apisix-mule-master.zip .
```

### Ubuntu
Terminal:
```sh
wget https://innersource.soprasteria.com/julian.wischnat/apisix-mule/-/archive/master/apisix-mule-master.zip
```

### Unzip the zip file
Install the unzip command
```sh
sudo apt-get install unzip
```
Unzip the apisix-mule-master.zip file
```sh
unzip apisix-mule-master.zip
```
# Conatiner
All containers together have a size of `5.68GB`

# Elasticsearch  + Logstash + Kibana
## Start Container
Change to the directory "docker-elk-8.2305.1"
```sh
cd docker-elk-8.2305.1/
```

Then, initialize the Elasticsearch users and groups required by docker-elk by executing the command:
```sh
docker-compose up setup
```
If everything went well and the setup was completed without errors, you should see this message:
`docker-elk-823051_setup_1 exited with code 0`

Start the stack components
```sh
docker-compose up -d
```

## Stop Containers
Change to the directory "docker-elk-8.2305.1"
```sh
cd docker-elk-8.2305.1/
```

Stop the stacking components
If an error like this occurs when shutting down the containers:
`ERROR: error while removing network: network apisix_elk id d7671a355b4e15a96cac182d84fefc0b7af8b40abba7828d6b25b83963610595 has active endpoints`
\
It is normal because one of the other containers is still using the network. The network will be removed when the other container is shut down as well.

```sh
docker-compose down
```

## Web UI 
```sh
UI: http://localhost:5601
user: elastic
password: changeme
```

# APISIX
## Start Container
Change to the directory "apisix"
```sh
cd apisix/
```

Start the stack components
```sh
docker-compose up -d
```

## Stop Containers
Change to the directory "apisix"
```sh
cd apisix/
```

Stop the stacking components
If an error like this occurs when shutting down the containers:
`ERROR: error while removing network: network apisix_elk id d7671a355b4e15a96cac182d84fefc0b7af8b40abba7828d6b25b83963610595 has active endpoints`
\
It is normal because one of the other containers is still using the network. The network will be removed when the other container is shut down as well.

```sh
docker-compose down
```

## Web UI 
```sh
UI: http://localhost:9000/
user: admin 
password: admin
```

## Grafana

### Configure Dashboard 
1. Click `Dashboard` on the left side.
2. Click on the `Configure button`
3. Enter the following `http://localhost:3000` for the grafana address
4. Click on the `login button` at the bottom of the page on the left hand side.
5. `username: admin` & `password: admin`
6. If you like, you can set a new password
7. Click on `+ button` and then on `Folder`
8. Click on `Manage tab`, the view should have changed now
9. Click on `Apache APISIX`

### Login data 
```sh
user: admin 
password: admin
```

## Hello Mule Example - Route + Upstream + Service
### Upstream
1. Click on `Upstream` on the left side.
2. Click on `Raw Data Editor`
3. Copy the provided data and paste it into the editor
```sh
{
  "nodes": [
    {
      "host": "mule",
      "port": 8081,
      "weight": 1
    }
  ],
  "timeout": {
    "connect": 6,
    "send": 6,
    "read": 6
  },
  "type": "roundrobin",
  "scheme": "http",
  "pass_host": "pass",
  "name": "Hello Mule Upstream",
  "keepalive_pool": {
    "idle_timeout": 60,
    "requests": 1000,
    "size": 320
  }
}
```
4. Click on `Submit`


### Service
1. Click on `Upstream` on the left side.
2. Copy the `ID` of the required upstream
2. Click on `Service` on the left side.
2. Click on `Raw Data Editor`
3. Copy the provided data and paste it into the editor and replace {UPSTREAM_ID} with the upstream id
```sh
{
  "name": "Hello Mule Service",
  "upstream_id": "{UPSTREAM_ID}",
  "hosts": [
    "mule"
  ]
}
```
4. Click on `Submit`

### Route
1. Click on `Service` on the left side.
2. Copy the `ID` of the required service
2. Click on `Route` on the left side.
2. Click on `Advandces` and then on `Raw Data Editor`
3. Copy the provided data and paste it into the editor and replace {SERVICE_ID} with the service id
```sh
{
  "uri": "/test/hello",
  "name": "Test/Hello",
  "methods": [
    "GET"
  ],
  "plugins": {
    "http-logger": {
      "_meta": {
        "disable": false
      },
      "uri": "http://logstash:50000/"
    }
  },
  "service_id": "{SERVICE_ID}",
  "labels": {
    "API_VERSION": "v1"
  },
  "status": 1
}
```
4. Click on `Submit`

# Mule
## Start Container 
Change to the directory "mule"
```sh
cd mule/
```
Start the stack components
```sh
docker-compose up -d
```

## Stop Containers
Change to the directory "mule"
```sh
cd mule/
```

Stop the stacking components
If an error like this occurs when shutting down the containers:
`ERROR: error while removing network: network apisix_elk id d7671a355b4e15a96cac182d84fefc0b7af8b40abba7828d6b25b83963610595 has active endpoints`
\
It is normal because one of the other containers is still using the network. The network will be removed when the other container is shut down as well.

```sh
docker-compose down
```

## Sample project
A sample project is available under "mule/mule_projects/hello_mule_4".

## Add new mule project
### 1. Step
If you want to add another mule project, you must create a new folder in the mule_projects directory and provide the following three elements in it:
- logs folder
- .jar file
- Dockerfile
\
\
You can copy the Dockerfile from the example. 
You only have to change the COPY command in the Dockerfile.
```sh
COPY ./{your_mule_project_name}.jar /opt/mule/apps/
```
### 2. Step
You also need to add another service to the docker-compose file.
To do this, you can copy the service from the example and assign a new service name. You also need to change the port, the build path and the log path(volume).
```sh
  {your_servicve_name}:
    restart: always
    volumes:
    - mule_projects/{your_folder_name}/logs:/opt/mule-standalone-4.4.0-20221024/logs
    ports:
    - "{your_port}:8081"
    stdin_open: true
    tty: true
    build: mule_projects/{your_folder_name}/
    networks:
      - apisix_mule
```

# Postman Collection
1. Start Postman
2. Click on `File` and then select `Import`
3. Select the `APISIX_MULE.postman_collection.json` file to import the collection


