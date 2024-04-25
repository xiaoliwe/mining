#!/bin/bash 

# 检查是否以 root 用户运行
if [[ $EUID -ne 0 ]]; then
    echo "请以 root 用户运行此脚本。" 
    exit 1
fi
function CentOS_install_docker()
{

    # 更新yum包
    sudo yum update -y

    # 安装需要的依赖包
    sudo yum install -y yum-utils device-mapper-persistent-data lvm2

    # 添加Docker官方仓库
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

    # 安装Docker
    sudo yum install -y docker-ce docker-ce-cli containerd.io

    # 启动Docker服务
    sudo systemctl start docker

    # 设置开机自启动
    sudo systemctl enable docker

    # 验证Docker是否安装成功
    sudo docker run hello-world

    # 将当前用户添加到docker组,避免每次使用docker命令都需要sudo
    sudo usermod -aG docker $USER

    echo "Docker installed successfully. Please log out and log back in for the group membership to take effect."
}
function Ubuntu_install_docker()
{
    # Check docker whether it is installed.
    if ! command -v docker &> /dev/null
    then

        # 更新软件包列表
        apt-get update

        # 安装必要的依赖项
        apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

        # 添加 Docker 的官方 GPG 密钥
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

        # 设置 Docker 的稳定版仓库
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

        # 再次更新软件包列表
        apt-get update

        # 安装最新版本的 Docker 引擎、容器运行时和 Docker Compose
        apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose

        # 启动 Docker 守护进程并设置开机自启
        systemctl start docker
        systemctl enable docker

        # 输出 Docker 版本信息
        docker --version

        echo "Docker 安装完成。"

    else
        echo "Docker installed on server."
    fi

    echo "=========================Installation completed================================"
}     
# 判断操作系统版本并调用相应的函数
function check_os_and_install_docker() 
{
    if [ -f /etc/lsb-release ]; then
        # Ubuntu
        Ubuntu_install_docker
    elif [ -f /etc/redhat-release ]; then
        # CentOS
        CentOS_install_docker
    else
        echo "Unsupported operating system."
        exit 1
    fi
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
    1) check_os_and_install_docker;;
    2) exit;;
    *) echo "Invalid option, please try again.";;
    esac
}

# main
main