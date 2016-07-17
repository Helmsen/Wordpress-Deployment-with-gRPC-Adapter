# Client for the gRPC Adapter

* Client for the gRPC adapter
* build docker container with ```docker build -t <containerName> <pathToDockerfile>```
* run docker container with ```docker run <containerName>```
* you can specify which methods of the adapter shall be called by editing callMethods.sh (method calls are on the bottom of the file)

Provide some information as environment variables (in the Dockerfile):
* ```FTP_USER```: Username to get access to the FTP server
* ```FTP_PW```: Password to get access to the FTP server
* ```FTP_PORT```: Port of the FTP server
* ```FTP_HOST```: Hostname of the FTP server
* ```FTP_PATH```: Absolute name of the private key file
* ```KEY_PAIR_NAME```: Name of the key pair you want to use to start the EC2 instance (must exist in AWS management console)
* ```KEY_ID```: Your AWS authentication credentials
* ```KEY_SECRET```: Your AWS authentication credentials
* ```SECURITY_GROUP_NAME```: Name of the security group you want to use to configure the EC2 instance (must exist in AWS management console)

You must save the private key of the chosen key pair on a ftp server (as specified by the environment variables), where the adapter can download it (this is how protobuf messages of type bytes a transfered to the adapter).

Important: The deployment functions (mysql and wordpress) need much time and you don't get any responses while they are processing (no output on the console). Sometimes you don't get any response after the last deployment process finished (we think it is because of the termination of the docker container). Then you have to check the installation by yourself (for example check if wordpress is reachable via Browser).
