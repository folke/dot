# originally implemented and transposed from https://github.com/patrickf3139/dotfiles/pull/11
function fzf_history --description "Search command history using fzf. Replace the commandline with the selected command."

    set | rg "^fish_color" | sed "s/^/set -x /" | source
    # history merge incorporates history changes from other fish sessions
    history merge
    set cmd (
        history | fish_indent --ansi | fzf --tiebreak=index --ansi --query=(commandline)
    )

    if test $status -eq 0
        commandline --replace $cmd
    end

    commandline --function repaint
end
