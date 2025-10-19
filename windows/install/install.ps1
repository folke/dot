#Requires -Version 5.1

# Windows Development Environment Setup Script
# Safe to run multiple times

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

Write-Host "==> Setting up Windows development environment..." -ForegroundColor Cyan

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($isAdmin) {
    Write-Host "ERROR: This script must NOT be run as Administrator!" -ForegroundColor Red
    Write-Host "Scoop requires running as a regular user." -ForegroundColor Yellow
    exit 1
}


# Run winget setup
& "$scriptDir\winget.ps1"
if ($LASTEXITCODE -ne 0) { throw "Winget setup failed" }

# Run Scoop setup
& "$scriptDir\scoop.ps1"
if ($LASTEXITCODE -ne 0) { throw "Scoop setup failed" }

# Copy PowerShell profile
$profilePath = $PROFILE

Write-Host "==> Setting up dot files..." -ForegroundColor Cyan

New-Item -ItemType SymbolicLink -Path $profilePath -Target $scriptDir\powershell.ps1 -Force | Out-Null

Copy-Item -Path $scriptDir\..\..\config\.gitconfig -Destination $HOME\.gitconfig -Force
gh config set -h github.com git_protocol ssh
gh auth setup-git

# Run projects setup
& "$scriptDir\projects.ps1"
if ($LASTEXITCODE -ne 0) { throw "Projects setup failed" }

Write-Host "`n==> Setup complete!" -ForegroundColor Cyan
