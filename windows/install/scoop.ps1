$ErrorActionPreference = "Stop"

Write-Host "==> Setting up Scoop and packages..." -ForegroundColor Cyan

# Install Scoop if not already installed
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Scoop..." -ForegroundColor Yellow
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    scoop install git # needed to add buckets
} else {
    Write-Host "Updating Scoop..." -ForegroundColor Yellow
    scoop update > $null
}

# Add useful buckets
Write-Host "Adding Scoop buckets..." -ForegroundColor Yellow
$buckets = @('extras', 'versions', 'nerd-fonts', 'main')
$installedBuckets = (scoop bucket list).Name
foreach ($bucket in $buckets) {
    if ($installedBuckets -notcontains $bucket) {
        Write-Host "Adding bucket: $bucket" -ForegroundColor Yellow
        scoop bucket add $bucket
    }
}

# Core development tools
$packages = @(
    '7zip',
    'bat',
    'curl',
    'delta',
    'eza',
    'fd',
    'fzf',
    'gcc',
    'gh'  # GitHub CLI
    'git',
    'jq',
    'lazygit',
    'less',
    'make',
    'neovim',
    'nodejs-lts',
    'ripgrep',
    'starship',
    'tar',
    'tree-sitter',
    'unzip',
    'which',
    'wget',
    'vcredist2022',
    'zoxide'
)

Write-Host "Installing packages..." -ForegroundColor Yellow
scoop install $packages

# Update all installed packages
Write-Host "Updating packages..." -ForegroundColor Yellow
scoop update *
