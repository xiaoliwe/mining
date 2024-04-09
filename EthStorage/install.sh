# Install basic components
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

else
    echo "Docker installed on server,continuing to execute commands for runing es-node..."
fi

# starting docker
docker compose up -d
echo "=========================Installation completed================================"
echo "Next, we will proceed with the node initialization configuration. Please enter the relevant information as prompted."

read -p "Enter the storage miner's address: " miner_address
read -p "Enter the signer's private_key: " private_key
read -p "Enter the BlockPI's RPC address: " blockPI_RPC_address
read -p "Enter the QuickNode's RPC address: " quicNode_RPC_address


docker run --name es  -d  \
          -v ./es-data:/es-node/es-data \
          -e ES_NODE_STORAGE_MINER=$miner_address \
          -e ES_NODE_SIGNER_PRIVATE_KEY=$private_key \
          -p 9545:9545 \
          -p 9222:9222 \
          -p 30305:30305/udp \
          --entrypoint /es-node/run.sh \
          ghcr.io/ethstorage/es-node:v0.1.11 \
          --l1.rpc $blockPI_RPC_address \
          --l1.beacon $quicNode_RPC_address

echo "Checking the status of docker..." 
docker logs -f es 