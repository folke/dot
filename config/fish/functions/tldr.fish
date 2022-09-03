#!/usr/bin/env fish

function tldr --wraps='tldr'
    # make sure env has colors
    set -l nl 0
    command tldr -r $argv \
        | sed -zr "s/^#[^\n]+\n//" \
        | sed -r 's/^`/..command../; s/`$//; s/\{\{//g; s/}}//g; s/^> (.*)$/_\1_/' | mdcat | while read -l line
        if test $line = ""
            set nl 1
            continue
        end
        set -l m (string match -r "\.\.command\.\.(.*)" $line)
        if test $status -eq 0
            echo -n "    "
            echo $m[2] | fish_indent_ansi
        else
            [ $nl -eq 1 ] && echo && set nl 0
            echo $line
        end
    end
end
