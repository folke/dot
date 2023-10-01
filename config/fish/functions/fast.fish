function fast
    powerprofilesctl launch --profile performance $argv
end

function __complete_fast
    set -l cmd (commandline -o)
    set -e cmd[1]
    if test -n "$cmd"
        complete -C "$cmd"
    else
        __fish_complete_command
    end
end

complete -c fast -a "(__complete_fast)"
