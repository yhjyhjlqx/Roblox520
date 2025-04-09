<#
.SYNOPSIS
    Roblox520 Windows自动更新脚本
.DESCRIPTION
    自动下载最新的hosts文件并替换系统hosts，支持自动和手动模式
.PARAMETER Auto
    使用自动模式(无交互)
#>

param(
    [switch]$Auto = $false
)

$RepoUrl = "https://github.com/yourname/Roblox520"
$HostsUrl = "https://raw.githubusercontent.com/yourname/Roblox520/main/hosts"
$BackupPath = "$env:temp\hosts.backup"
$SystemHosts = "$env:windir\System32\drivers\etc\hosts"

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not $Auto) {
    Write-Host "========================================"
    Write-Host " Roblox520 Hosts 更新工具 - Windows版"
    Write-Host " 项目地址: $RepoUrl"
    Write-Host "========================================"
    Write-Host ""
}

# 检查管理员权限
if (-not (Test-Admin)) {
    if ($Auto) {
        Write-Host "错误: 需要管理员权限运行此脚本"
        exit 1
    }
    else {
        Write-Host "需要管理员权限来更新hosts文件"
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -Auto" -Verb RunAs
        exit
    }
}

try {
    # 备份现有hosts文件
    if (Test-Path $SystemHosts) {
        Copy-Item $SystemHosts $BackupPath -Force
        if (-not $Auto) { Write-Host "已备份现有hosts文件到 $BackupPath" }
    }

    # 下载最新hosts文件
    if (-not $Auto) { Write-Host "正在下载最新hosts文件..." }
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $HostsUrl -OutFile $SystemHosts -ErrorAction Stop

    # 刷新DNS缓存
    ipconfig /flushdns | Out-Null

    if (-not $Auto) {
        Write-Host "`nHosts文件更新成功!"
        Write-Host "DNS缓存已刷新"
        Write-Host "`n注意: 某些更改可能需要重启浏览器或电脑才能生效"
        pause
    }
}
catch {
    if (-not $Auto) {
        Write-Host "`n更新失败: $_`n"
        Write-Host "正在恢复原始hosts文件..."
    }
    
    # 恢复备份
    if (Test-Path $BackupPath) {
        Copy-Item $BackupPath $SystemHosts -Force
    }
    
    if (-not $Auto) {
        Write-Host "已恢复原始hosts文件"
        pause
    }
    exit 1
}
