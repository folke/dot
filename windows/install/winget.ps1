#Requires -Version 5.1

# Winget Package Manager Setup
# Safe to run multiple times

$ErrorActionPreference = "Stop"

Write-Host "==> Installing applications with winget..." -ForegroundColor Cyan

# Applications to install
$apps = @(
    'Microsoft.WindowsTerminal',
    'Microsoft.PowerShell'
)

Write-Host "Winget sources" -ForegroundColor Yellow
winget source update > $null

foreach ($app in $apps) {
    Write-Host "  Processing $app..." -ForegroundColor Yellow
    winget install --id $app --exact --silent --accept-package-agreements --accept-source-agreements
}

# Update all winget packages
Write-Host "Winget updates..." -ForegroundColor Yellow
winget upgrade --all --silent --accept-package-agreements --accept-source-agreements
