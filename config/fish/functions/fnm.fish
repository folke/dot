#!/usr/bin/env fish

function fnm --wrap='fnm'
    if test -z $fnm_initialized
        command fnm env --shell=fish | source
        set -p PATH ~/.local/bin/pnpm
        set -g fnm_initialized 1
    end
    command fnm $argv
end
