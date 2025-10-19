$ErrorActionPreference = "Stop"

Write-Host "==> Setting up projects..." -ForegroundColor Cyan

# Check if already authenticated with GitHub
$authStatus = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    gh auth login --git-protocol ssh --web
    if ($LASTEXITCODE -ne 0) { throw "GitHub authentication failed" }
}

# Create projects directory
$projects = "$HOME\projects"
New-Item -ItemType Directory -Path $projects -Force | Out-Null

# Repositories to clone
$repos = @(
  'folke/dot',
  'LazyVim/LazyVim',
  'LazyVim/starter'
)

# Clone repositories
Write-Host "Cloning repositories..." -ForegroundColor Yellow
foreach ($repo in $repos) {
    $repoName = $repo.Split('/')[-1]
    $repoPath = "$projects\$repoName"
    if (!(Test-Path $repoPath)) {
        gh repo clone $repo $repoPath
        if ($LASTEXITCODE -ne 0) { throw "Failed to clone $repo" }
    }
}

# Create symlinks
Write-Host "Creating symlinks..." -ForegroundColor Yellow

$symlinks = @(
    @{
        Source = "$projects\starter"
        Target = "$env:LOCALAPPDATA\lazyvim"
    },
    @{
        Source = "$projects\dot\nvim"
        Target = "$env:LOCALAPPDATA\nvim"
    }
)

foreach ($link in $symlinks) {
    $source = $link.Source
    $target = $link.Target

    # Remove existing target if it exists
    if (Test-Path $target) {
        Remove-Item -Path $target -Recurse -Force
    }

    # Create symlink
    New-Item -ItemType SymbolicLink -Path $target -Target $source -Force | Out-Null
    Write-Host "  $target -> $source" -ForegroundColor Green
}

Write-Host "==> Projects setup complete!" -ForegroundColor Green
