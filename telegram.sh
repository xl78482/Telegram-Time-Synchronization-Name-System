#!/bin/bash

echo "====================================================="
echo " 🚀 Telegram 时间同步系统 - 一键部署（GitHub 自动下载版）"
echo "====================================================="

# GitHub RAW 地址（换成你的仓库地址）
GITHUB_RAW_BASE="https://raw.githubusercontent.com/xl78482/Telegram-Time-Synchronization-Name-System/main"

APP_DIR="/root/tg_time_sync"
SERVICE_NAME="tg_time_sync"

PYTHON_PATH=$(command -v python3 || echo /usr/bin/python3)

echo "📁 安装目录: $APP_DIR"
mkdir -p "$APP_DIR"

echo "📥 从 GitHub 下载 main.py ..."
curl -fsSL "$GITHUB_RAW_BASE/main.py" -o "$APP_DIR/main.py"
if [ $? -ne 0 ]; then
    echo "❌ 从 GitHub 下载 main.py 失败！"
    exit 1
fi
echo "✔ main.py 下载完成"

echo "🔍 检查 python3 / pip3 ..."
apt update -y
apt install -y python3 python3-pip

echo "🔍 检查 Telethon / aiohttp 依赖 ..."
$PYTHON_PATH - << 'EOF'
import importlib, subprocess, sys

pkgs = ["telethon", "aiohttp"]
missing = []

for p in pkgs:
    try:
        importlib.import_module(p)
    except ImportError:
        missing.append(p)

if missing:
    print("📦 正在安装缺失依赖:", ", ".join(missing))
    subprocess.check_call([sys.executable, "-m", "pip", "install", "--break-system-packages"] + missing)
else:
    print("✔ 所有依赖已安装")
EOF

echo "📝 创建 systemd 服务文件..."

cat >/etc/systemd/system/${SERVICE_NAME}.service <<EOF
[Unit]
Description=Telegram Time Sync
After=network.target

[Service]
WorkingDirectory=${APP_DIR}
ExecStart=${PYTHON_PATH} ${APP_DIR}/main.py
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
