#!/bin/bash

# Check if the script is running as root user
if ["$(id -u)"!="0"]; then
    echo "This script must be run as root."
    echo "Please try using the 'sudo -i' command to switch to the root user, and then run this script again."
    exit 1;
fi

# The location of the script 
SCRIPT_PATH="$HOME/Ritual/install.sh"

# Node installation
function init_node()
{
    # Prompt the user to enter the private key.
    read -p "Enter the EVM wallet private key, it must start with 0x, and it is recommended to use a new wallet: " private_key

    # Prompt the user to set up port.
    read -p "enter port: " port1

    # Prompt the RPC address
    read -p "enter RPC address: " rpc_address

    # Prompt user to set-up the Port
    read -p "Enter docker hub's username: " username
    read -p "Enter docker hub's password: " password

    #Update the package of system.
    sudo apt update

    if ! command -v git &> /dev/null
    then
        # if git can't install on server
        echo "Git not detected, installing..."
        sudo apt install git -y
    else
        echo "Git installed on server."
    fi

    # Clone Ritual's repo
    git clone https://github.com/ritual-net/infernet-node

    # Entrance infernet-deploy folder
    cd infernet-node

    #set tag is 0.2.0
    tag="0.2.0"

    # build image 
    docker build -t ritualnetwork/infernet-node:$tag .

    # enter the folder
    cd deploy

    # Use the cat command to write the configuration into config.json.
    cat > config.json <<EOF
    {
    "log_path": "infernet_node.log",
    "manage_containers": true,
    "server": {
        "port": $port1
    },
    "chain": {
        "enabled": true,
        "trail_head_blocks": 5,
        "rpc_url": "$rpc_address",
        "coordinator_address": "0x8D871Ef2826ac9001fB2e33fDD6379b6aaBF449c",
        "wallet": {
        "max_gas_limit": 5000000,
        "private_key": "0x$private_key"
        }
    },
    "snapshot_sync": {
        "sleep": 5,
        "batch_size": 100
    },
    "docker": {
        "username": "$username",
        "password": "$password"
    },
    "redis": {
        "host": "redis",
        "port": 6379
    },
    "forward_stats": true,
    "startup_wait": 1.0,
    "containers": []
    }
EOF
    echo "config.json created."

# Install basic components
sudo apt install pkg-config curl build-essential libssl-dev libclang-dev -y

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
    curl -SL https://github.com/docker/compose/releases/download/v2.26.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
    sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
    docker compose version

else
    echo "Docker installed on server."
fi

echo "=========================Installation completed================================"
echo "Please use ** cd infernet-node/deploy ** to enter the directory, and then modify the content of docker-compose.yaml as bellow: "
echo "Checking#01: The image version is: $tag"
echo "Checking#02: port is $port1 "
echo "If all correct, please use ** docker compose up -d ** to start the node."

}

# View node logs
function check_service_status()
{
    cd infernet-node/deploy
    docker compose logs -f
}

# Main function
function main()
{
    clear
    echo "
__  _____    _    ___  _     ___   ____  _______     __
\ \/ /_ _|  / \  / _ \| |   |_ _| |  _ \| ____\ \   / /
 \  / | |  / _ \| | | | |    | |  | | | |  _|  \ \ / / 
 /  \ | | / ___ \ |_| | |___ | | _| |_| | |___  \ V /  
/_/\_\___/_/   \_\___/|_____|___(_)____/|_____|  \_/   
        "
    echo "Welcome to use this script to install Ritual's services."
    echo "================================================================"
    echo "Please select the operation to be performed:"
    echo "1. Install node"
    echo "2. View node logs"
    read -p "Please enter an option (1-2): " OPTION

    case $OPTION in
    1) init_node;;
    2) check_service_status;;
    *) echo "Invalid option, please try again.";;
    esac
}

# display main
main
