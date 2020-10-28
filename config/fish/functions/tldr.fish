#!/usr/bin/env fish

function tldr --wraps='tldr'
    # make sure env has colors
    set | rg "^fish_color" | sed "s/^/set -lx /" | source
    set -l nl 0
    command tldr -m $argv \
        | sed 's/^`/cccommand/; s/`$//; s/{{//g; s/}}//g; s/^>/#/ ;s/^-/> -/' \
        | bat -l md --style "plain" --pager never -f | \
        while read -l line
        if test $line = ""
            set nl 1
            continue
        end
        set -l m (string match -r "ccommand(.*)" $line)
        if test $status -eq 0
            echo -n "    "
            echo $m[2] | fish_indent --ansi
        else
            [ $nl -eq 1 ] && echo && set nl 0
            echo $line | sed 's/[>#]//'
        end
    end
end
