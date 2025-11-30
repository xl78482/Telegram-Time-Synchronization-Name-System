#!/bin/bash

echo "====================================================="
echo " 🚀 Telegram 时间同步系统 - 智能一键部署（最终版）"
echo "====================================================="

GITHUB_RAW_BASE="https://raw.githubusercontent.com/xl78482/Telegram-Time-Synchronization-Name-System/main"

APP_DIR="/root/tg_time_sync"
VENV_DIR="$APP_DIR/venv"
SERVICE_NAME="tg_time_sync"

echo "📁 安装路径: $APP_DIR"
mkdir -p "$APP_DIR"

# =====================================================
# ① 判断是否已安装（venv 是否存在）
# =====================================================
if [ -d "$VENV_DIR" ]; then
    echo "✔ 检测到虚拟环境: $VENV_DIR"
    echo "✔ 您已完成全部依赖安装，无需继续安装"
else
    echo "🔧 首次安装 → 开始准备 Python 环境与依赖..."

    echo "📥 下载 main.py ..."
    curl -fsSL "$GITHUB_RAW_BASE/main.py" -o "$APP_DIR/main.py"
    if [ $? -ne 0 ]; then
        echo "❌ 下载 main.py 失败，请检查仓库"
        exit 1
    fi
    echo "✔ main.py 下载完成"

    echo "🔧 安装 Python 基础环境..."
    apt update -y
    apt install -y python3 python3-pip python3-venv

    echo "🐍 创建 venv 虚拟环境..."
    python3 -m venv "$VENV_DIR"

    echo "📦 安装依赖 telethon / aiohttp..."
    $VENV_DIR/bin/pip install --upgrade pip
    $VENV_DIR/bin/pip install telethon aiohttp

    echo "🎉 首次安装完成 — 依赖已全部就绪！"
fi

# =====================================================
# ② 每次运行自动更新 main.py（可关闭）
# =====================================================
echo "📥 获取最新 main.py..."
curl -fsSL "$GITHUB_RAW_BASE/main.py" -o "$APP_DIR/main.py"
echo "✔ main.py 已更新到最新版本"

# =====================================================
# ③ 创建 & 启动 systemd 服务
# =====================================================
echo "📝 创建 systemd 服务文件..."

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

echo "🔒 设置开机自启..."
systemctl enable ${SERVICE_NAME}

echo ""
echo "====================================================="
echo "🎉 部署完成！系统运行正常！"
echo "📌 查看日志： journalctl -u ${SERVICE_NAME} -f"
echo "====================================================="
