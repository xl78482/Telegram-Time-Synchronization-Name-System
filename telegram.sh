#!/bin/bash

echo "============================================"
echo " 🚀 缔造者 Telegram 时间同步昵称系统 - 一键部署程序"
echo "============================================"
sleep 1

# ---------------------------
# 1. 检查 Root
# ---------------------------
if [ "$(id -u)" != "0" ]; then
    echo "❌ 必须使用 root 权限运行！"
    exit 1
fi


# ---------------------------
# 2. 自动安装 Python 3.11.2
# ---------------------------
echo "🐍 检查 Python 3.11.2 环境..."

PY311="/usr/local/bin/python3.11"
PIP311="/usr/local/bin/pip3.11"

if [ -x "$PY311" ]; then
    echo "✔ Python 3.11 已存在：$($PY311 --version)"
else
    echo "📦 未检测到 Python 3.11，开始安装 Python 3.11.2..."

    # 安装依赖
    if command -v apt >/dev/null 2>&1; then
        apt update -y
        apt install -y wget build-essential libssl-dev zlib1g-dev \
            libncurses5-dev libreadline-dev libsqlite3-dev libgdbm-dev \
            libdb5.3-dev libbz2-dev libexpat1-dev liblzma-dev tk-dev
    elif command -v yum >/dev/null 2>&1; then
        yum groupinstall -y "Development Tools"
        yum install -y wget openssl-devel bzip2-devel libffi-devel \
            xz-devel sqlite-devel tk-devel
    else
        echo "❌ 不支持的系统，请使用 Debian / Ubuntu / CentOS"
        exit 1
    fi

    cd /usr/src
    wget https://www.python.org/ftp/python/3.11.2/Python-3.11.2.tgz
    tar xzf Python-3.11.2.tgz
    cd Python-3.11.2

    ./configure --enable-optimizations
    make -j$(nproc)
    make altinstall

    echo "✔ Python 安装完成：$($PY311 --version)"
fi

# 确认 pip3.11
if [ ! -x "$PIP311" ]; then
    echo "📦 安装 pip3.11..."
    $PY311 -m ensurepip
    $PY311 -m pip install --upgrade pip
fi
echo "✔ pip3.11 版本：$($PIP311 --version)"


# ---------------------------
# 3. 安装 Telegram 依赖
# ---------------------------
echo "⚙ 安装 telethon + aiohttp..."

$PIP311 install telethon aiohttp >/dev/null 2>&1
echo "✔ 依赖安装成功"


# ---------------------------
# 4. 下载最新脚本（覆盖 dist/）
# ---------------------------
echo "⬇ 从 GitHub 拉取最新脚本..."

rm -rf Telegram-Time-Synchronization-Name-System
git clone https://github.com/xl78482/Telegram-Time-Synchronization-Name-System.git

cd Telegram-Time-Synchronization-Name-System/dist || {
    echo "❌ 找不到 dist 文件夹，脚本结构异常"
    exit 1
}

echo "✔ 下载完成"


# ---------------------------
# 5. 启动加密 Python 程序
# ---------------------------
echo "🚀 正在启动时间同步昵称脚本..."

$PY311 telegram.py

echo "============================================"
echo "🎉 部署完成！脚本已启动！"
echo "============================================"
