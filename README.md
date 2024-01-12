# yasccdi - Yet Another SAP Cloud Connector Docker Image

> [!IMPORTANT]  
> If you use this docker image, you accept the SAP DEVELOPER LICENSE AGREEMENT. See https://tools.hana.ondemand.com/#cloud for details.

> [!WARNING]  
> This image is under development, don't use it for a productive environment

## Motivation
Container allow faster and easy deployment.

## About Cloud Connector
Details about the cloud connector can be found here: https://help.sap.com/docs/connectivity/sap-btp-connectivity-cf/cloud-connector

## Related Projects
* https://github.com/nzamani/sap-cloud-connector-docker
* https://github.com/PaxSchweiz/SAPHCPConnector

## tl;dr
```bash
sudo docker image build --tag "andreasferdinand/cloudconnector:latest" .
sudo docker run -d --name "cloudconnector" -p 8443:8443/tcp "andreasferdinand/cloudconnector:latest" --restart unless-stopped
```

## The long way
1. Install Docker

    For details regarding the installation see https://docs.docker.com/engine/install/.

2. Download `Dockerfile`

    Either download the file with your browser or use `curl` to get it on your computer.

    ```bash
    curl https://raw.githubusercontent.com/AndreasFerdinand/yasccdi/main/Dockerfile -o Dockerfile
    ```

3. Build the image

    During the build process, the latest Java version and latest Cloud Connector versions are determined automatically. If specific versions must be used, the `--build-arg` argument could be used:

    * `--build-arg JAVA_DOWNLOAD_FILE=additional/sapjvm-8.1.096-linux-x64.rpm`
    * `--build-arg CC_DOWNLOAD_FILE=additional/sapcc-2.16.1-linux-x64.zip`

    An optional proxy server to download the needed ressources can be set to:

    * `--build-arg https_proxy=https://my.proxy:8888`

    If neccessary add the above mentioned arguments to the build command:

    ```bash
    sudo docker image build --tag "andreasferdinand/cloudconnector:latest" .
    ```

4. Run the container

    ```bash
    sudo docker run -d --name "cloudconnector" -p 8443:8443/tcp "andreasferdinand/cloudconnector:latest" --restart unless-stopped
    ```

5. Open Cloud Connector UI

    To access the Cloud Connector UI open the address https://localhost:8443 in your browser. Since a self-signed certificate is used, you will see a certificate warning.
    To log on use the following default credentials:

    * Username: `Administrator`
    * Password: `manage`

## Some additional things

### Open shell in container
```bash
sudo docker exec -it cloudconnector /bin/bash
```

### Remove container
```bash
sudo docker container rm <conteinerid>
```

### Remove orphaned volumes
The container uses 3 volumes. If the container and the volumes aren't needed more, **all** (not only volumes related to the cloud connctor container) orphaned volumes can be deleted using the following command:

```bash
sudo docker volume prune
```

To view orphaned volumes use:

```bash
sudo docker volume ls -f "dangling=true"
```

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing
You are welcome to send feedback, improvements, pull requests or bug reports.
