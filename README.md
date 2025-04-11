# Roblox520 🚀

[![Auto Update](https://github.com/yhjyhjlqx/Roblox520/actions/workflows/auto_update.yml/badge.svg)](https://github.com/yhjyhjlqx/Roblox520/actions/workflows/auto_update.yml)
[![GitHub Release](https://img.shields.io/github/v/release/yhjyhjlqx/Roblox520)](https://github.com/yhjyhjlqx/Roblox520/releases)
[![License](https://img.shields.io/github/license/yhjyhjlqx/Roblox520)](LICENSE)

> 优化 Roblox 国际版访问体验，解除强制重定向至腾讯罗布乐思官网的限制

---

## 🌟 功能特性

- **解除访问限制**  
  绕过 Roblox 国际版被强制重定向到腾讯罗布乐思官网的限制
- **自动更新**  
  每日自动检测并更新最新的 Roblox 服务器域名
- **多平台支持**  
  提供 Windows/macOS/Linux 一键更新脚本
- **零配置**  
  无需复杂设置，下载即用

---

## 🛠️ 使用方法

### 方法一：一键脚本（推荐）
根据你的系统选择对应命令运行：

#### **Windows**
irm https://raw.githubusercontent.com/yhjyhjlqx/Roblox520/main/scripts/windows_update.ps1 | iex

#### **macOS**
curl -sL https://raw.githubusercontent.com/yhjyhjlqx/Roblox520/main/scripts/macos_update.sh | sudo bash

#### **Linux**
curl -sL https://raw.githubusercontent.com/yhjyhjlqx/Roblox520/main/scripts/linux_update.sh | sudo bash

### 方法二：手动替换 Hosts
1. 下载最新 Hosts 文件：  
   [📥 直接下载](https://raw.githubusercontent.com/yhjyhjlqx/Roblox520/main/hosts)
2. 替换系统 Hosts 文件：
   - **Windows**: `C:\Windows\System32\drivers\etc\hosts`
   - **macOS/Linux**: `/etc/hosts`
3. 刷新 DNS 缓存：
   # Windows
   ipconfig /flushdns
   # macOS
   sudo killall -HUP mDNSResponder
   # Linux
   sudo systemctl restart nscd

---

## 🔄 自动更新
- 项目每日自动检查域名变更（[查看工作流](.github/workflows/auto_update.yml)）
- 建议每周手动运行一次更新脚本

---

## 🤝 参与贡献
欢迎通过以下方式改进项目：
1. **报告问题**  
   提交 [Issue](https://github.com/yhjyhjlqx/Roblox520/issues) 反馈失效域名
2. **添加域名**  
   编辑 [domains.txt](domains.txt) 并提交 Pull Request
3. **改进脚本**  
   优化各平台更新逻辑

[贡献指南](CONTRIBUTING.md) | [讨论区](https://github.com/yhjyhjlqx/Roblox520/discussions)
