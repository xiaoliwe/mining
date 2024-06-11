#!/bin/bash

# 定义源配置文件路径
SOURCE_FILE="/etc/apt/sources.list.d/docker.list"
BACKUP_FILE="/etc/apt/sources.list.d/docker.list.bak"

# 检查源配置文件是否存在
if [ ! -f "$SOURCE_FILE" ]; then
  echo "源配置文件 $SOURCE_FILE 不存在。请确认Docker已安装并配置了APT源。"
  exit 1
fi

# 备份源配置文件
echo "备份源配置文件到 $BACKUP_FILE ..."
sudo cp "$SOURCE_FILE" "$BACKUP_FILE"

# 检查备份是否成功
if [ $? -ne 0 ]; then
  echo "备份源配置文件失败。请检查权限或路径。"
  exit 1
fi

# 替换URL
echo "替换URL https://download.docker.com 为 https://docker-proxy.xiaoli.dev ..."
sudo sed -i 's|https://download.docker.com|https://docker-proxy.xiaoli.dev|g' "$SOURCE_FILE"

# 检查替换是否成功
if [ $? -ne 0 ]; then
  echo "替换URL失败。请检查权限或路径。"
  exit 1
fi

# 更新并升级APT包列表
echo "更新并升级APT包列表 ..."
sudo apt update && sudo apt upgrade -y

# 检查更新是否成功
if [ $? -ne 0 ]; then
  echo "更新APT包列表失败。请检查网络连接或配置。"
  exit 1
fi

echo "完成。Docker APT源配置已更新并指向 https://docker-proxy.xiaoli.dev"