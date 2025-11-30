#!/bin/bash

echo "====================================================="
echo " 🚀 Telegram 时间同步系统 - venv 一键部署（推荐）"
echo "====================================================="

GITHUB_RAW_BASE="https://raw.githubusercontent.com/xl78482/Telegram-Time-Synchronization-Name-System/main"
APP_DIR="/root/tg_time_sync"
VENV_DIR="$APP_DIR/venv"
SERVICE_NAME="tg_time_sync"

echo "📁 创建目录: $APP_DIR"
mkdir -p "$APP_DIR"

echo "📥 下载 main.py ..."
curl -fsSL "$GITHUB_RAW_BASE/main.py" -o "$APP_DIR/main.py"
if [ $? -ne 0 ]; then
    echo "❌ 下载 main.py 失败，请检查仓库地址"
    exit 1
fi
echo "✔ main.py 下载完成"

echo "🔧 安装 Python 基础环境..."
apt update -y
apt install -y python3 python3-venv python3-pip

echo "🐍 创建虚拟环境 venv ..."
python3 -m venv "$VENV_DIR"

echo "📦 安装依赖（在虚拟环境内）..."
$VENV_DIR/bin/pip install --upgrade pip
$VENV_DIR/bin/pip install telethon aiohttp

echo "📝 创建 systemd 服务..."

cat >/etc/systemd/system/${SERVICE_NAME}.service <<EOF
[Unit]
Description=Telegram Time Sync Service
After=network.target

[Service]
WorkingDirectory=${APP_DIR}
ExecStart=${VENV_DIR}/bin/python ${APP_DIR}/main.py
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

echo "🔄 重新加载 systemd..."
systemctl daemon-reload

echo "🚀 启动服务..."
systemctl restart ${SERVICE_NAME}

echo "📌 设置开机自启..."
systemctl enable ${SERVICE_NAME}

echo ""
echo "====================================================="
echo "🎉 部署完成！"
echo "🔍 查看日志： journalctl -u ${SERVICE_NAME} -f"
echo "====================================================="
