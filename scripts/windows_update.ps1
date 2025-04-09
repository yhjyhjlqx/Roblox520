<#
.SYNOPSIS
    Roblox520 Windows自动更新脚本
.DESCRIPTION
    支持从GitHub Releases下载最新脚本和hosts文件
#>

param(
    [switch]$Auto = $false,
    [switch]$ForceDownload = $false
)

$RepoOwner = "yourname"
$RepoName = "Roblox520"
$ReleaseUrl = "https://api.github.com/repos/$RepoOwner/$RepoName/releases/latest"
$DownloadUrl = "https://github.com/$RepoOwner/$RepoName/releases/latest/download/Roblox520_Scripts.zip"
$TempDir = "$env:temp\Roblox520"
$ZipPath = "$TempDir\scripts.zip"
$BackupPath = "$env:temp\hosts.backup"
$SystemHosts = "$env:windir\System32\drivers\etc\hosts"

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# 显示欢迎信息
if (-not $Auto) {
    Write-Host "========================================"
    Write-Host " Roblox520 Hosts 更新工具 - Windows版"
    Write-Host " 版本: $(if($ForceDownload){"强制下载"}else{"自动检测"})"
    Write-Host "========================================"
    Write-Host ""
}

# 检查管理员权限
if (-not (Test-Admin)) {
    if ($Auto) {
        Write-Host "错误: 需要管理员权限运行此脚本" -ForegroundColor Red
        exit 1
    }
    else {
        Write-Host "需要管理员权限来更新hosts文件"
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -Auto" -Verb RunAs
        exit
    }
}

# 创建临时目录
if (-not (Test-Path $TempDir)) {
    New-Item -ItemType Directory -Path $TempDir | Out-Null
}

# 下载最新发布包
try {
    Write-Host "正在获取最新版本..." -NoNewline
    $ProgressPreference = 'SilentlyContinue'
    
    # 下载ZIP包
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $ZipPath -ErrorAction Stop
    Write-Host "完成" -ForegroundColor Green
    
    # 解压文件
    Write-Host "正在解压文件..." -NoNewline
    Expand-Archive -Path $ZipPath -DestinationPath $TempDir -Force
    Write-Host "完成" -ForegroundColor Green
    
    # 备份现有hosts
    if (Test-Path $SystemHosts)) {
        Copy-Item $SystemHosts $BackupPath -Force
        Write-Host "已备份现有hosts文件到 $BackupPath"
    }
    
    # 更新hosts文件
    $NewHosts = "$TempDir\release_package\hosts"
    if (Test-Path $NewHosts)) {
        Copy-Item $NewHosts $SystemHosts -Force
        Write-Host "hosts文件已更新" -ForegroundColor Green
    }
    else {
        Write-Host "警告: 未找到新的hosts文件" -ForegroundColor Yellow
    }
    
    # 刷新DNS
    ipconfig /flushdns | Out-Null
    Write-Host "DNS缓存已刷新" -ForegroundColor Green
    
    # 更新脚本自身（如果需要）
    $NewScript = "$TempDir\release_package\windows_update.ps1"
    if ((Test-Path $NewScript) -and ($PSCommandPath -ne $NewScript)) {
        $currentHash = (Get-FileHash $PSCommandPath).Hash
        $newHash = (Get-FileHash $NewScript).Hash
        if ($currentHash -ne $newHash -or $ForceDownload) {
            Copy-Item $NewScript $PSCommandPath -Force
            Write-Host "脚本已更新，请重新运行" -ForegroundColor Green
            if (-not $Auto) { pause }
            & $PSCommandPath -Auto
            exit
        }
    }
}
catch {
    Write-Host "`n错误: $_" -ForegroundColor Red
    if (Test-Path $BackupPath)) {
        Write-Host "正在恢复原始hosts文件..."
        Copy-Item $BackupPath $SystemHosts -Force
    }
    exit 1
}
finally {
    if (-not $Auto) {
        Write-Host "`n操作完成"
        Write-Host "注意: 某些更改可能需要重启浏览器或电脑才能生效"
        pause
    }
}
