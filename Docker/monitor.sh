#!/bin/bash

# Check if the script is running as root user
if ["$(id -u)"!="0"]; then
    echo "This script must be run as root."
    echo "Please try using the 'sudo -i' command to switch to the root user, and then run this script again."
    exit 1;
fi


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