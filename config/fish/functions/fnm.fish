#!/usr/bin/env fish

function fnm --wrap='fnm'
    if test -z $fnm_initialized
        command fnm env --shell=fish | source
        fish_add_path -p ~/.local/bin/pnpm
        set -g fnm_initialized 1
    end
    command fnm $argv
end
