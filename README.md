# 🚀 缔造者 Telegram 时间同步昵称系统（加密发布版）

本项目用于将 Telegram 昵称自动同步为当前时间（精确到分钟 + 表情时钟），  
主程序已使用 PyArmor 加密，部署脚本使用 shc 编译为二进制，可安全对外发布。

---

## 📦 安装教程（真正的一键部署）

### ① 克隆仓库

```
git clone https://github.com/yourname/yourrepo.git
cd yourrepo
```

### ② 给部署脚本赋予执行权限

```
chmod +x deploy.sh.x
```

### ③ 启动系统（自动安装依赖 + 自动运行加密程序）

```
./deploy.sh.x
```

脚本会自动完成：

- 自动安装 python3 / pip3  
- 自动修复 Debian 的 pip 限制  
- 自动安装 telethon / aiohttp  
- 自动运行加密后的 dist/telegram.py  

无需任何手动操作。

---

## 🖥️ 动图展示效果

<div align="center">
<img src="https://cdn.jsdelivr.net/gh/mdnice/markdown-images@main/demo/run-terminal.gif" width="620" />
</div>

---

## 📊 昵称更新示例

系统启动后会每分钟更新 Telegram 昵称：

```
✨ 更新成功 → 缔造者 2025-11-30 12:17 🕒
✨ 更新成功 → 缔造者 2025-11-30 12:18 🕓
✨ 更新成功 → 缔造者 2025-11-30 12:19 🕔
```

昵称格式示例：

```
缔造者 2025-11-30 12:20 🕠
```

---

## 📩 联系作者

如需定制开发（多账号版本 / 后台面板 / 自动同步 / 加密工具），请联系：

- **系统作者 / 开发维护者**  
👉 https://t.me/n456n  
