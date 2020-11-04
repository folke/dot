function __fzf_tldr --description "Search tldr using fzf"
    fd --print0 --extension md . ~/.tldrc/tldr-master/pages/{common,osx} \
        | gsed -z 's/.*\///; s/\.md$//' \
        | fzf --read0 --query=(commandline) --preview 'tldr {}' --preview-window right:75% \
        | read -lz cmd

    if test $status -eq 0
        # trim any surrounding white space
        commandline --replace (echo $cmd | gsed -zr "s/^\s+|\s+\$//g")
    end

    commandline --function repaint
end
