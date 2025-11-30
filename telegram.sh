#!/bin/bash

echo "==============================================="
echo " 🚀 Telegram 时间同步系统 - 一键启动"
echo "==============================================="

# 自动获取脚本所在目录
SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
MAIN_FILE="$SCRIPT_DIR/main.py"
SERVICE_NAME="tg_time_sync"

# ---------------------------------------------------------
# 1. 检查 main.py 是否存在
# ---------------------------------------------------------

if [ ! -f "$MAIN_FILE" ]; then
    echo "❌ 错误：未找到 main.py"
    echo "请确认 telegram.sh 与 main.py 在同一目录下！"
    exit 1
fi

echo "✔ 找到 main.py"

# ---------------------------------------------------------
# 2. 自动检测依赖
# ---------------------------------------------------------

echo "🔍 检查 Telethon 和 aiohttp ..."

pip3 show telethon >/dev/null 2>&1
TELETHON_OK=$?

pip3 show aiohttp >/dev/null 2>&1
AIOHTTP_OK=$?

if [ $TELETHON_OK -ne 0 ] || [ $AIOHTTP_OK -ne 0 ]; then
    echo "📦 正在安装依赖..."
    apt update -y
    apt install -y python3 python3-pip
    pip3 install telethon aiohttp
else
    echo "✔ 依赖已安装"
fi

# ---------------------------------------------------------
# 3. 创建 systemd 服务（直接运行 main.py）
# ---------------------------------------------------------

echo "📝 创建 systemd 服务..."

cat >/etc/systemd/system/${SERVICE_NAME}.service <<EOF
[Unit]
Description=Telegram Time Sync
After=network.target

[Service]
WorkingDirectory=${SCRIPT_DIR}
ExecStart=/usr/bin/python3 ${MAIN_FILE}
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

echo "🔄 重载 systemd..."
systemctl daemon-reload

echo "🚀 启动服务..."
systemctl restart ${SERVICE_NAME}

echo "📌 设置开机启动..."
systemctl enable ${SERVICE_NAME}

echo "==============================================="
echo "🎉 启动成功！日志查看： journalctl -u ${SERVICE_NAME} -f"
echo "==============================================="
