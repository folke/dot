function t --wraps tmux
    # without arguments, uses fzf to list sessions if running
    # otherwise pass to tmux
    if test (count $argv) -eq 0
        set -l running (tmux list-sessions | grep -v "EXITED" | wc -l)
        if test $running -gt 0
            set -l session (tmux list-sessions -F '#{session_name}' | fzf --prompt="  Tmux Session: " --height=~50% --layout=reverse --exit-0 | head -1)
            if test -z "$session"
                return 1
            end
            tmux attach-session -t "$session"
            return 0
        end
    end
    tmux $argv
end
