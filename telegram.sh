#!/bin/bash

echo "====================================================="
echo " 🚀 Telegram 时间同步系统 - 智能一键部署（跨系统版）"
echo "====================================================="

GITHUB_RAW_BASE="https://raw.githubusercontent.com/xl78482/Telegram-Time-Synchronization-Name-System/main"

APP_DIR="/root/tg_time_sync"
VENV_DIR="$APP_DIR/venv"
SERVICE_NAME="tg_time_sync"

echo "📁 安装路径: $APP_DIR"
mkdir -p "$APP_DIR"

# =====================================================
# ① 自动识别系统并安装 python3 / pip / venv
# =====================================================

install_python() {
    if command -v python3 >/dev/null 2>&1; then
        echo "✔ python3 已存在"
        return
    fi

    echo "🔧 正在安装 Python3..."

    if command -v apt >/dev/null 2>&1; then
        echo "📦 使用 apt 安装（Debian/Ubuntu）"
        apt update -y
        apt install -y python3 python3-pip python3-venv
    elif command -v yum >/dev/null 2>&1; then
        echo "📦 使用 yum 安装（CentOS/RHEL）"
        yum install -y python3 python3-pip
        # CentOS 没有 venv，需要手动安装
        python3 -m ensurepip --upgrade
    elif command -v dnf >/dev/null 2>&1; then
        echo "📦 使用 dnf 安装（Rocky/AlmaLinux）"
        dnf install -y python3 python3-pip
        python3 -m ensurepip --upgrade
    else
        echo "❌ 未知系统，无法安装 python3"
        exit 1
    fi
}

# 开始安装 Python
install_python

# =====================================================
# ② 检查 venv 是否存在
# =====================================================

if [ -d "$VENV_DIR" ]; then
    echo "✔ 已检测到虚拟环境: $VENV_DIR"
    echo "✔ 您已完成全部依赖安装，无需继续安装"
else
    echo "🐍 创建 venv 虚拟环境..."
    python3 -m venv "$VENV_DIR"

    echo "📦 安装依赖 telethon / aiohttp..."
    $VENV_DIR/bin/pip install --upgrade pip
    $VENV_DIR/bin/pip install telethon aiohttp

    echo "🎉 首次安装完成 — 依赖全部已准备就绪！"
fi

# =====================================================
# ③ 更新 main.py
# =====================================================

echo "📥 获取最新 main.py..."
curl -fsSL "$GITHUB_RAW_BASE/main.py" -o "$APP_DIR/main.py"
echo "✔ main.py 已更新到最新版本"

# =====================================================
# ④ 创建 systemd 并启动服务
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

systemctl daemon-reload
systemctl restart ${SERVICE_NAME}
systemctl enable ${SERVICE_NAME}

echo ""
echo "====================================================="
echo "🎉 部署完成！系统运行正常！"
echo "📌 查看日志： journalctl -u ${SERVICE_NAME} -f"
echo "====================================================="
