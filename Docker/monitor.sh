#!/bin/bash

# 检查是否以 root 用户运行
if [[ $EUID -ne 0 ]]; then
    echo "请以 root 用户运行此脚本。" 
    exit 1
fi

function monitor_docker()
{

# 列出所有容器
echo "当前所有容器列表："
docker ps -a

# 提示用户输入容器名称和监控时间间隔
read -p "请输入要监控的容器名称: " CONTAINER_NAME
read -p "请输入监控时间间隔 (分钟): " INTERVAL

# 生成脚本文件名和日志文件名
SCRIPT_FILE="monitor_${CONTAINER_NAME}_docker.sh"
LOG_FILE="monitor_${CONTAINER_NAME}_docker.txt"

# 提示用户日志文件位置
echo "监控日志将保存到: $LOG_FILE"

# 脚本内容
cat << EOF > "$SCRIPT_FILE"
#!/bin/bash

# 容器名称
CONTAINER_NAME="$CONTAINER_NAME"

# 健康检查命令
HEALTH_CHECK_CMD="docker inspect --format='{{.State.Health.Status}}' \$CONTAINER_NAME"

# 检查容器健康状态
HEALTH_STATUS=\$(eval \$HEALTH_CHECK_CMD)

# 获取当前时间
CURRENT_TIME=\$(date +"%Y-%m-%d %H:%M:%S")

# 将检查结果输出到日志文件
echo "\$CURRENT_TIME - 容器 \$CONTAINER_NAME 健康状态：\$HEALTH_STATUS" >> "$LOG_FILE"

# 如果健康状态不是 "healthy"，则重启容器
if [[ "\$HEALTH_STATUS" != "healthy" ]]; then
  echo "\$CURRENT_TIME - 容器 \$CONTAINER_NAME 健康检查失败，正在重启..." >> "$LOG_FILE"
  docker restart \$CONTAINER_NAME
fi
EOF

# 赋予脚本可执行权限
chmod +x "$SCRIPT_FILE"

# 使用 crontab 定期执行脚本
crontab -l | { cat; echo "*/$INTERVAL * * * * ./$SCRIPT_FILE"; } | crontab -

# 执行脚本一次
./"$SCRIPT_FILE"

echo "监控已启动，请查看日志文件 $LOG_FILE 获取详细信息。"
}

function exit_shell()
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
    echo "Welcome to use this script to monitor docker node."
    echo "================================================================"
    echo "Please select the operation to be performed:"
    echo "1. Install monitor's scripts"
    echo "2. Exit"
    read -p "Please enter an option (1-2): " OPTION

    case $OPTION in
    1) monitor_docker;;
    2) exit_shell;;
    *) echo "Invalid option, please try again.";;
    esac
}
main