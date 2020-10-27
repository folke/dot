#!/usr/bin/env fish

function fnm --wrap='fnm'
    if test -z $fnm_initialized
        command fnm env --shell=fish --use-on-cd | source
        set -g fnm_initialized 1
    end
    command fnm $argv
end
