#!/bin/bash

echo "====================================================="
echo "🚀 缔造者 Telegram 时间同步昵称系统 - 一键终极部署程序"
echo "====================================================="
sleep 1


###############################################
# 0. 必须使用 root
###############################################
if [ "$(id -u)" != "0" ]; then
    echo "❌ 请使用 root 用户运行！"
    exit 1
fi


###############################################
# 1. 自动安装 curl 和 git（必须项）
###############################################
echo "🔧 检查 curl 和 git ..."

if ! command -v curl >/dev/null 2>&1; then
    echo "📦 正在安装 curl ..."
    if command -v apt >/dev/null 2>&1; then
        apt update -y && apt install -y curl
    elif command -v yum >/dev/null 2>&1; then
        yum install -y curl
    fi
fi

if ! command -v git >/dev/null 2>&1; then
    echo "📦 正在安装 git ..."
    if command -v apt >/dev/null 2>&1; then
        apt update -y && apt install -y git
    elif command -v yum >/dev/null 2>&1; then
        yum install -y git
    fi
fi

echo "✔ curl / git 已准备"


###############################################
# 2. 自动安装 Python 3.11.2
###############################################
PY311="/usr/local/bin/python3.11"
PIP311="/usr/local/bin/pip3.11"

echo "🐍 检查 Python 3.11.2 ..."

if [ -x "$PY311" ]; then
    echo "✔ Python 已存在：$($PY311 --version)"
else
    echo "📦 开始安装 Python 3.11.2（这个步骤耗时 1-3 分钟）..."

    if command -v apt >/dev/null 2>&1; then
        apt update -y
        apt install -y wget build-essential libssl-dev zlib1g-dev \
            libncurses5-dev libreadline-dev libsqlite3-dev libgdbm-dev \
            libbz2-dev libexpat1-dev liblzma-dev tk-dev
    elif command -v yum >/dev/null 2>&1; then
        yum groupinstall -y "Development Tools"
        yum install -y wget openssl-devel bzip2-devel libffi-devel \
            xz-devel sqlite-devel tk-devel
    else
        echo "❌ 不支持的 Linux 发行版"
        exit 1
    fi

    cd /usr/src
    wget https://www.python.org/ftp/python/3.11.2/Python-3.11.2.tgz
    tar xzf Python-3.11.2.tgz
    cd Python-3.11.2

    ./configure --enable-optimizations
    make -j$(nproc)
    make altinstall
fi

# 确保 pip3.11 存在
if [ ! -x "$PIP311" ]; then
    echo "📦 初始化 pip3.11 ..."
    $PY311 -m ensurepip
    $PY311 -m pip install --upgrade pip
fi

echo "✔ Python 3.11 → 已就绪：$($PY311 --version)"
echo "✔ pip3.11 → 已就绪：$($PIP311 --version)"


###############################################
# 3. 安装 telethon aiohttp
###############################################
echo "⚙ 安装 telethon aiohttp ..."
$PIP311 install telethon aiohttp >/dev/null 2>&1
echo "✔ 依赖安装完成"


###############################################
# 4. 从 GitHub 拉取最新版本
###############################################
echo "⬇ 拉取最新脚本 ..."

rm -rf Telegram-Time-Synchronization-Name-System
git clone https://github.com/xl78482/Telegram-Time-Synchronization-Name-System.git

if [ ! -d "Telegram-Time-Synchronization-Name-System/dist" ]; then
    echo "❌ GitHub 项目结构异常，找不到 dist 文件夹"
    exit 1
fi

cd Telegram-Time-Synchronization-Name-System/dist
echo "✔ 脚本下载完成"


###############################################
# 5. 启动加密后的 Python 程序
###############################################
echo "🚀 正在启动时间同步昵称脚本 ..."
echo "---------------------------------------------"

$PY311 telegram.py

echo "---------------------------------------------"
echo "🎉 部署完成！脚本已成功启动"
echo "---------------------------------------------"
