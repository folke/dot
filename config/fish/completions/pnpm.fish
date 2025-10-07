###-begin-pnpm-completion-###
function _pnpm_completion
    set cmd (commandline -o)
    set cursor (commandline -C)
    set words (count $cmd)

    set completions (eval command env DEBUG=\"" \"" COMP_CWORD=\""$words\"" COMP_LINE=\""$cmd \"" COMP_POINT=\""$cursor\"" SHELL=fish pnpm completion-server -- $cmd)

    if [ "$completions" = __tabtab_complete_files__ ]
        set -l matches (commandline -ct)*
        if [ -n "$matches" ]
            __fish_complete_path (commandline -ct)
        end
    else
        for completion in $completions
            echo -e $completion
        end
    end
end

complete -f -d pnpm -c pnpm -a "(_pnpm_completion)"
###-end-pnpm-completion-###
