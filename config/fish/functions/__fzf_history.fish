# originally implemented and transposed from https://github.com/patrickf3139/dotfiles/pull/11
function __fzf_history --description "Search command history using fzf. Replace the commandline with the selected command."
    # history merge incorporates history changes from other fish sessions
    history merge
    history --null \
        | string replace -ar "\x0" ";__delim__;" \
        | fish_indent_ansi -i \
        | sed "s/__delim__/\\x0/g" \
        | fzf --tiebreak=index --read0 --ansi --query=(commandline) \
        | read -lz cmd

    if test $status -eq 0
        # trim any surrounding white space
        commandline --replace (echo $cmd | sed -zr "s/^\s+|\s+\$//g")
    end

    commandline --function repaint
end
