#!/bin/bash

echo "====================================================="
echo " 🚀 Telegram 时间同步系统 - 一键部署（GitHub 版）"
echo "====================================================="

# GitHub RAW 基础地址（改成你自己的仓库）
GITHUB_RAW_BASE="https://raw.githubusercontent.com/xl78482/Telegram-Time-Synchronization-Name-System/main"

# 安装目录 & 服务名
APP_DIR="/root/tg_time_sync"
SERVICE_NAME="tg_time_sync"

# 找到 python3 真实路径
PYTHON_PATH=$(command -v python3 || echo /usr/bin/python3)

echo "📁 安装目录: $APP_DIR"
mkdir -p "$APP_DIR"

echo "📥 从 GitHub 下载 main.py ..."
curl -fsSL "$GITHUB_RAW_BASE/main.py" -o "$APP_DIR/main.py"
if [ $? -ne 0 ]; then
    echo "❌ 从 GitHub 下载 main.py 失败，请检查仓库地址是否正确。"
    exit 1
fi
echo "✔ main.py 下载完成"

echo "🔍 检查 python3 / pip3 ..."
if ! command -v python3 >/dev/null 2>&1; then
    echo "📦 安装 python3 ..."
    apt update -y
    apt install -y python3
fi

if ! command -v pip3 >/dev/null 2>&1; then
    echo "📦 安装 python3-pip ..."
    apt install -y python3-pip
fi

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
    print("📦 正在安装依赖:", ", ".join(missing))
    subprocess.check_call([sys.executable, "-m", "pip", "install"] + missing)
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
echo "🛑 停止服务： systemctl stop ${SERVICE_NAME}"
echo "♻️ 重启服务： systemctl restart ${SERVICE_NAME}"
echo "====================================================="
