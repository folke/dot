#!/usr/bin/env fish

function fish_indent_ansi --wraps fish_indent
    # Make sure the colors are exported
    set | command grep "^fish_color" | sed "s/^/set -Ux /" | source
    command fish_indent --ansi $argv
end
