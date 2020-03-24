function __fzf_reverse_isearch
    history merge
    history -z | eval (__fzfcmd) --read0 --tiebreak=index --toggle-sort=ctrl-r $FZF_DEFAULT_OPTS $FZF_REVERSE_ISEARCH_OPTS -q '(commandline)' | perl -pe 'chomp if eof' | read -lz result
    and commandline -- $result
    commandline -f repaint
end
