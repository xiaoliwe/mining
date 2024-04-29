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

#!/bin/bash

# 提示用户输入容器名称和监控时间间隔
read -p "请输入要监控的容器名称: " CONTAINER_NAME
read -p "请输入监控时间间隔 (分钟): " INTERVAL

# 生成脚本文件名和日志文件名
SCRIPT_FILE="monitor_${CONTAINER_NAME}_docker.sh"
LOG_FILE="monitor_${CONTAINER_NAME}_docker.log"

# 提示用户日志文件位置
echo "监控日志将保存到: $LOG_FILE"

# 脚本内容
cat << EOF > "$SCRIPT_FILE"
#!/bin/bash

# 获取容器的运行状态
CONTAINER_STATUS=\$(docker inspect --format='{{.State.Status}}' $CONTAINER_NAME)

# 获取当前时间
CURRENT_TIME=\$(date +"%Y-%m-%d %H:%M:%S")

# 将检查结果输出到日志文件
echo "\$CURRENT_TIME - 容器 $CONTAINER_NAME 运行状态：\$CONTAINER_STATUS" >> "$LOG_FILE"

# 根据容器的运行状态进行操作
if [[ "\$CONTAINER_STATUS" != "running" ]]; then
  echo "\$CURRENT_TIME - 容器 $CONTAINER_NAME 不在运行状态，状态为 \$CONTAINER_STATUS，正在尝试重启..." >> "$LOG_FILE"
  docker start $CONTAINER_NAME
else
  echo "\$CURRENT_TIME - 容器 $CONTAINER_NAME 正在运行中。" >> "$LOG_FILE"
fi
EOF

# 定义新的 cron 任务
NEW_CRON_JOB="*/$INTERVAL * * * * bash $PWD/$SCRIPT_FILE"

# 检查 crontab 是否已经包含这个任务
crontab -l | grep -Fq "$NEW_CRON_JOB"

# $? 是上一个命令的退出状态。0 表示找到了，非0 表示没有找到
if [ $? -eq 0 ]; then
    echo "\$CURRENT_TIME - 定时任务已经存在,不需要重新添加."
else
    # 如果任务不存在，添加到 crontab
    (crontab -l 2>/dev/null; echo "$NEW_CRON_JOB") | crontab -
    echo "\$CURRENT_TIME - 容器 ${CONTAINER_NAME} 监控任务添加成功." >> "$LOG_FILE" 
fi

# 执行脚本一次
bash "$SCRIPT_FILE"

echo "监控已启动，请查看日志文件 $LOG_FILE 获取详细信息。"

read -p "是否现在查看日志文件？(y/n): " VIEW_LOG
if [[ "$VIEW_LOG" == "y" ]]; then
  cat "$LOG_FILE"
  exit 0
else
  exit 0
fi
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