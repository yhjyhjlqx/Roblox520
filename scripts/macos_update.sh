#!/bin/bash

# Roblox520 macOS 自动更新脚本
# 功能: 从GitHub Releases下载最新hosts文件并替换系统hosts

# 配置变量
REPO_OWNER="yhjyhjlqx"
REPO_NAME="Roblox520"
RELEASE_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest"
DOWNLOAD_URL="https://github.com/$REPO_OWNER/$REPO_NAME/releases/latest/download/Roblox520_Scripts.zip"
TEMP_DIR="/tmp/Roblox520"
ZIP_PATH="$TEMP_DIR/scripts.zip"
BACKUP_PATH="/tmp/hosts.backup"
SYSTEM_HOSTS="/etc/hosts"
LOG_FILE="/tmp/Roblox520_update.log"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# 检查是否为root用户
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}错误: 需要root权限运行此脚本${NC}"
        echo -e "请使用以下命令重新运行:"
        echo -e "sudo bash $0"
        exit 1
    fi
}

# 显示欢迎信息
show_header() {
    clear
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN} Roblox520 Hosts 更新工具 - macOS版${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo -e "项目地址: https://github.com/$REPO_OWNER/$REPO_NAME"
    echo -e "日志文件: $LOG_FILE"
    echo -e "${YELLOW}注意: 此操作将修改系统hosts文件${NC}"
    echo -e "----------------------------------------"
}

# 准备临时目录
prepare_temp_dir() {
    echo -n "准备临时目录... "
    mkdir -p "$TEMP_DIR" && chmod 700 "$TEMP_DIR"
    echo -e "${GREEN}完成${NC}"
}

# 下载最新发布包
download_package() {
    echo -n "下载最新版本... "
    if curl -sL "$DOWNLOAD_URL" -o "$ZIP_PATH" >> "$LOG_FILE" 2>&1; then
        echo -e "${GREEN}完成${NC}"
    else
        echo -e "${RED}失败${NC}"
        echo -e "${RED}错误: 无法下载发布包${NC}"
        exit 1
    fi
}

# 解压文件
extract_package() {
    echo -n "解压文件... "
    if unzip -o "$ZIP_PATH" -d "$TEMP_DIR" >> "$LOG_FILE" 2>&1; then
        echo -e "${GREEN}完成${NC}"
    else
        echo -e "${RED}失败${NC}"
        echo -e "${RED}错误: 解压失败${NC}"
        exit 1
    fi
}

# 备份当前hosts
backup_hosts() {
    echo -n "备份当前hosts文件... "
    if cp "$SYSTEM_HOSTS" "$BACKUP_PATH" >> "$LOG_FILE" 2>&1; then
        echo -e "${GREEN}完成${NC}"
        echo -e "备份位置: $BACKUP_PATH"
    else
        echo -e "${YELLOW}警告: 备份失败${NC}"
    fi
}

# 更新hosts文件
update_hosts() {
    NEW_HOSTS="$TEMP_DIR/release_package/hosts"
    if [ -f "$NEW_HOSTS" ]; then
        echo -n "更新hosts文件... "
        if cp "$NEW_HOSTS" "$SYSTEM_HOSTS" >> "$LOG_FILE" 2>&1; then
            echo -e "${GREEN}完成${NC}"
        else
            echo -e "${RED}失败${NC}"
            echo -e "${RED}错误: 更新hosts文件失败${NC}"
            restore_backup
            exit 1
        fi
    else
        echo -e "${RED}错误: 未找到新的hosts文件${NC}"
        restore_backup
        exit 1
    fi
}

# 恢复备份
restore_backup() {
    if [ -f "$BACKUP_PATH" ]; then
        echo -n "恢复原始hosts文件... "
        if cp "$BACKUP_PATH" "$SYSTEM_HOSTS" >> "$LOG_FILE" 2>&1; then
            echo -e "${GREEN}完成${NC}"
        else
            echo -e "${RED}失败${NC}"
        fi
    fi
}

# 刷新DNS缓存
flush_dns() {
    echo -n "刷新DNS缓存... "
    if killall -HUP mDNSResponder >> "$LOG_FILE" 2>&1; then
        echo -e "${GREEN}完成${NC}"
    else
        echo -e "${YELLOW}警告: 刷新DNS缓存失败${NC}"
    fi
}

# 清理临时文件
cleanup() {
    echo -n "清理临时文件... "
    rm -rf "$TEMP_DIR" >> "$LOG_FILE" 2>&1
    echo -e "${GREEN}完成${NC}"
}

# 主函数
main() {
    check_root
    show_header
    prepare_temp_dir
    download_package
    extract_package
    backup_hosts
    update_hosts
    flush_dns
    cleanup
    
    echo -e "\n${GREEN}更新成功完成!${NC}"
    echo -e "某些更改可能需要重启浏览器才能生效"
}

# 执行主函数
main
