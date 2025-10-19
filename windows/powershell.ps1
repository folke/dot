Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

$prompt = ""
function Invoke-Starship-PreCommand {
    $current_location = $executionContext.SessionState.Path.CurrentLocation
    if ($current_location.Provider.Name -eq "FileSystem") {
        $ansi_escape = [char]27
        $provider_path = $current_location.ProviderPath -replace "\\", "/"
        $prompt = "$ansi_escape]7;file://${env:COMPUTERNAME}/${provider_path}$ansi_escape\"
    }
    $host.ui.Write($prompt)
}

# Aliases
Set-Alias -Name v -Value nvim

function lazyvim {
    $env:NVIM_APPNAME = "lazyvim"
    nvim @args
    Remove-Item Env:\NVIM_APPNAME
}

function ls { eza --color=auto --icons=auto --group-directories-first @args }
function la { eza --color=auto --icons=auto --group-directories-first --all --git @args }
function ll { eza --color=auto --icons=auto --group-directories-first --all --git --long @args }
function l { eza --color=auto --icons=auto --group-directories-first --all --git --long @args }

# Key bindings
Set-PSReadlineKeyHandler -Chord Ctrl+d -Function DeleteCharOrExit
Set-PSReadlineKeyHandler -Chord Ctrl+a -Function BeginningOfLine
Set-PSReadlineKeyHandler -Chord Ctrl+e -Function EndOfLine
