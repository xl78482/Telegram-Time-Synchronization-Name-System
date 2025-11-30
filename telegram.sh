#!/bin/bash

echo "======================================================"
echo "🚀 缔造者 Telegram 时间同步昵称系统 —— 一键部署程序"
echo "======================================================"

cd ~

echo "🔧 正在安装必要组件..."
if command -v apt >/dev/null 2>&1; then
    PACK="apt"
    apt update -y
    apt install -y git curl python3 python3-pip
elif command -v yum >/dev/null 2>&1; then
    PACK="yum"
    yum install -y git curl python3 python3-pip
else
    echo "❌ 不支持的系统，请使用 Debian / Ubuntu / CentOS"
    exit 1
fi


echo "🧹 删除旧版本..."
rm -rf Telegram-Time-Synchronization-Name-System


echo "⬇️ 下载最新版本..."
git clone https://github.com/xl78482/Telegram-Time-Synchronization-Name-System.git


cd Telegram-Time-Synchronization-Name-System/dist


echo "📦 安装 Python 依赖..."
if pip3 install telethon aiohttp --break-system-packages 2>/dev/null; then
    echo "✔ 依赖安装成功"
else
    echo "⚠️ 切换到普通安装模式..."
    pip3 install telethon aiohttp
fi


echo "🚀 正在启动时间同步昵称系统..."
python3 telegram.py
