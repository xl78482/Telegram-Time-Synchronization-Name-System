#!/bin/bash

echo "====================================================="
echo "      🚀 Telegram 时间同步系统 一键部署脚本"
echo "====================================================="

APP_DIR="/root/tg_time_sync"
SERVICE_NAME="tg_time_sync"

# 自动获取脚本所在目录
SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)

echo "📁 创建项目目录: $APP_DIR"
mkdir -p $APP_DIR

echo "📦 安装 Python3 和依赖..."
apt update -y
apt install -y python3 python3-pip

pip3 install --upgrade pip
pip3 install telethon aiohttp

echo "📥 拷贝 main.py 文件..."
cp $SCRIPT_DIR/main.py $APP_DIR/main.py

echo "📝 创建 systemd 服务..."

cat >/etc/systemd/system/${SERVICE_NAME}.service <<EOF
[Unit]
Description=Telegram Time Sync Service
After=network.target

[Service]
Type=simple
WorkingDirectory=${APP_DIR}
ExecStart=/usr/bin/python3 ${APP_DIR}/main.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo "🔄 重新加载 systemd..."
systemctl daemon-reload

echo "🚀 启动服务..."
systemctl start ${SERVICE_NAME}

echo "📌 设置开机自启..."
systemctl enable ${SERVICE_NAME}

echo ""
echo "====================================================="
echo "🎉 部署完成！"
echo "🔍 查看日志： journalctl -u ${SERVICE_NAME} -f"
echo "====================================================="
