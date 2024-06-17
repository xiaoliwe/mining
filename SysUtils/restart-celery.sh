#!/bin/bash

# 定义与 celery 相关的镜像名称模式
IMAGE_NAME_PATTERN="jumpserver/core-ce"

# 获取所有运行中的容器，并用 grep 进行过滤
CONTAINER_IDS=$(docker ps --format '{{.ID}} {{.Image}}' | grep "$IMAGE_NAME_PATTERN" | awk '{print $1}')

# 定义 Celery 应用程序名称和日志文件路径（在容器内）
CELERY_APP="celery-restart"  # 这里的 "tasks" 是你的 Celery 应用程序所在的模块名称
LOGFILE="/root/devops/logs/celery.log"
# 定义crontab日志文件路径
CRONLOG="/root/devops/logs/cron.log"

# 记录开始时间
echo "$(date): Starting Celery restart script" >> $CRONLOG

# 如果没有找到相关容器，则退出脚本
if [[ -z "$CONTAINER_IDS" ]]; then
  echo "$(date): No containers found for image pattern $IMAGE_NAME_PATTERN" >> $CRONLOG
  exit 1
fi

# 遍历所有相关的容器
for CONTAINER_ID in $CONTAINER_IDS; do
    echo "$(date): Stopping Docker container $CONTAINER_ID..." >> $CRONLOG
    docker stop $CONTAINER_ID >> $CRONLOG 2>&1

    echo "$(date): Docker container $CONTAINER_ID stopped successfully." >> $CRONLOG
done

# 记录结束时间
echo "$(date): Finished Celery restart script" >> $CRONLOG