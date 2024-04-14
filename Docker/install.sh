#!/bin/bash 

function Init_docker()
{
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
}

function exit()
{
    clear
    exit 0
}

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
    echo "Welcome to use this script to install Docker."
    echo "================================================================"
    echo "Please select the operation to be performed:"
    echo "1. Install docker env"
    echo "2. Exit"
    read -p "Please enter an option (1-2): " OPTION

    case $OPTION in
    1) Init_docker;;
    2) exit;;
    *) echo "Invalid option, please try again.";;
    esac
}

# main
main