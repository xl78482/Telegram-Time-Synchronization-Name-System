#!/bin/bash

echo "====================================================="
echo "      🚀 缔造者·Telegram 同步系统 一键部署脚本"
echo "====================================================="

# 项目目录
APP_DIR="/root/tg_time_sync"
SERVICE_NAME="tg_time_sync"

echo "📁 创建项目目录: $APP_DIR"
mkdir -p $APP_DIR

echo "📦 安装 Python3 与常用组件..."
apt update -y
apt install -y python3 python3-pip python3-venv

# 创建虚拟环境（可选但强烈推荐）
echo "🐍 创建 Python 虚拟环境..."
python3 -m venv $APP_DIR/venv
source $APP_DIR/venv/bin/activate

echo "📦 安装依赖: telethon aiohttp"
pip install --upgrade pip
pip install telethon aiohttp

echo "📥 拷贝 main.py 文件..."
cp main.py $APP_DIR/main.py

# 创建 systemd 服务
echo "📝 创建 systemd 服务文件..."

cat >/etc/systemd/system/${SERVICE_NAME}.service <<EOF
[Unit]
Description=Telegram Time Sync Service
After=network.target

[Service]
Type=simple
WorkingDirectory=${APP_DIR}
ExecStart=${APP_DIR}/venv/bin/python3 ${APP_DIR}/main.py
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
echo "🔍 查看运行日志：  journalctl -u ${SERVICE_NAME} -f"
echo "🛑 停止服务：      systemctl stop ${SERVICE_NAME}"
echo "♻️ 重启服务：      systemctl restart ${SERVICE_NAME}"
echo "====================================================="
