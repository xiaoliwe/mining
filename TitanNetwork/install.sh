#!/bin/bash 

# Check if the script is running as root user
if ["$(id -u)"!="0"]; then
    echo "This script must be run as root."
    echo "Please try using the 'sudo -i' command to switch to the root user, and then run this script again."
    exit 1;
fi

# Install basic components and update.
sudo apt-get update 

# Check docker whether it is installed.
if ! command -v docker &> /dev/null
then
    # if docker can't install on server
    echo "Docker not dectected,installing..."
    sudo apt install ca-certificates curl gnupg lsb-release

    # added gpg key of docker's
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # set the repo of docker
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Authorized Docker file
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    sudo apt update

    # Install the latest version of Docker
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y 
    DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
    mkdir -p $DOCKER_CONFIG/cli-plugins
    curl -SL https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
    sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
    docker compose version
    
    echo "=========================Installation completed================================"

else
    echo "Docker installed on server,continuing to execute commands for runing es-node..."
fi

echo "Next, you need to get the Identity code via https://test1.titannet.io/newoverview/activationcodemanagement."
read -p "Identity code: " identity_code

# Download image
docker pull nezha123/titan-edge

# Create your own volume
mkdir ~/.titanedge

# Running node
docker run -d -v ~/.titanedge:/root/.titanedge nezha123/titan-edge

# Get the continater ID
container_id=$(docker ps -q --filter "name=nezha123/titan-edge")

echo "TitanNetwork's ContainerID is: $container_id"

# Enter continer with Continer ID
docker exec -it $container_id /bin/bash

titan-edge bind --hash=$identity_code https://api-test1.container1.titannet.io/api/v2/device/binding

echo "=========================Installation completed================================"
echo "=========================Thanks for your joing us.================================"