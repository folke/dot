function run
    nohup $argv >/dev/null 2>&1 </dev/null & disown
end

function __complete_run
    set -l cmd (commandline -o)
    set -e cmd[1]
    if test -n "$cmd"
        complete -C "$cmd"
    else
        __fish_complete_command
    end
end

complete -c run -a "(__complete_run)"
