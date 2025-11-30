#!/bin/bash

echo "============================================"
echo " 🚀 缔造者 Telegram 时间同步昵称系统 - 一键部署程序"
echo "============================================"
sleep 1

# ---------------------------
# 1. 必须 root
# ---------------------------
if [ "$(id -u)" != "0" ]; then
    echo "❌ 必须使用 root 权限运行！"
    exit 1
fi

# ---------------------------
# 2. 使用系统自带 Python3（Debian 默认 3.11.2）
# ---------------------------
echo "🐍 使用系统内置 Python3："
python3 --version || { echo "❌ 系统缺少 python3"; exit 1; }

# ---------------------------
# 3. 安装 Python 依赖
# ---------------------------
echo "📦 安装 telethon aiohttp..."

pip3 install -U pip >/dev/null 2>&1
pip3 install telethon aiohttp >/dev/null 2>&1

echo "✔ 依赖安装成功"

# ---------------------------
# 4. 拉取最新脚本
# ---------------------------
echo "⬇ 拉取 GitHub 最新脚本..."

rm -rf Telegram-Time-Synchronization-Name-System
git clone https://github.com/xl78482/Telegram-Time-Synchronization-Name-System.git

cd Telegram-Time-Synchronization-Name-System/dist || {
    echo "❌ dist 文件不存在"
    exit 1
}

echo "✔ dist 加载完毕"

# ---------------------------
# 5. 运行加密脚本
# ---------------------------
echo "🚀 正在启动加密脚本..."
python3 telegram.py

echo "============================================"
echo "🎉 部署完成！脚本已启动！"
echo "============================================"
