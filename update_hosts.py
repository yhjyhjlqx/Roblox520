#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import time
from datetime import datetime
from urllib.request import urlopen

HEADER = """# Roblox520 Hosts Start
# Last updated: {update_time}
# Project URL: https://github.com/yourname/Roblox520
# 此文件由Roblox520项目自动生成，请勿手动修改

"""
FOOTER = """
# Roblox520 Hosts End
"""

def load_domains():
    """从外部文件加载域名列表"""
    with open('domains.txt', 'r', encoding='utf-8') as f:
        domains = [line.strip() for line in f if line.strip() and not line.startswith('#')]
    return domains

def check_domain_availability(domain):
    """检查域名是否可用（简单实现）"""
    try:
        # 这里可以添加更复杂的检查逻辑
        return True
    except:
        return False

def generate_hosts_content():
    """生成hosts文件内容"""
    update_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    domains = load_domains()
    
    # 过滤无效域名
    valid_domains = []
    for domain in domains:
        if check_domain_availability(domain):
            valid_domains.append(f"127.0.0.1 {domain}")
        else:
            print(f"警告: 域名 {domain} 可能无效，已跳过")
    
    content = HEADER.format(update_time=update_time)
    content += "\n".join(valid_domains)
    content += FOOTER
    
    return content

def update_hosts_file():
    """更新hosts文件"""
    content = generate_hosts_content()
    
    with open("hosts", "w", encoding="utf-8") as f:
        f.write(content)
    
    print(f"Hosts文件已更新，包含 {len(content.splitlines())} 行")

if __name__ == "__main__":
    update_hosts_file()
