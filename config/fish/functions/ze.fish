function ze --wraps zellij
    # without arguments, uses fzf to list sessions if running
    # otherwise pass to zellij
    if test (count $argv) -eq 0
        set -l running (zellij list-sessions | grep -v "EXITED" | wc -l)
        if test $running -gt 0
            set -l session (zellij list-sessions -ns | fzf --prompt="  Zellij Session: " --height=~50% --layout=reverse --exit-0 | head -1)
            if test -z "$session"
                return 1
            end
            zellij attach "$session"
            return 0
        end
    end
    zellij $argv
end
