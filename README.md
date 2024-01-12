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

> [!IMPORTANT]  
> Only the log files are persited in a volume outside of the container. Configuration, certificates, etc. are not persisted on the host computer! To save the configuration use the backups.

## Backup and restore configuration
## Backup
As mentioned on https://help.sap.com/docs/connectivity/sap-btp-connectivity-cf/backup backups can be created using the configuration API. To export the configuration used in the container, the following command needs to be executed on the host computer:

```bash
curl -k --fail -u Administrator https://localhost:8443/api/v1/configuration/backup -X POST -H 'Content-Type: application/json' -d "{\"password\":\"<PASSWORD>\"}" -o CloudConnectorBackup_$(date -I).zip
```

Some files inside the backup file are encrypted. Replace the token `<PASSWORD>` to set a suitable password. Since the API requires authentication, you will be asked for the password of your `Administrator` user.

## Restore

> [!IMPORTANT]  
> A backup cannot be restored on a clean installation. In order to import it, you first have to log on and set a new password for the `Administrator` user.

To restore the backup use the follwoing command.

```bash
curl -k --fail -u Administrator https://localhost:8444/api/v1/configuration/backup -X PUT -F 'password=<PASSWORD>' -F backup=@<BACKUPFILE>
```

The `<PASSWORD>` token needs to be replaces with the password used during creation of the backup, where as `<BACKUPFILE>` must be replaced with the name of the backup file. Again, the API requires the passoword for the `Administrator`-user, which is requested at command invocation.

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

## FAQ
### Why isn't the configuration persisted in a volume outside of the container?
When a backup is restored, the configuration files will be deleted. If the directories are mounted outside the container they cannot be deleted and therefor backup restoration doesn't work.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing
You are welcome to send feedback, improvements, pull requests or bug reports.
