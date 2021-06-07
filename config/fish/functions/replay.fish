function replay --description "Run Bash commands replaying changes in Fish"
    switch "$argv"
        case -v --version
            echo "replay, version 1.2.0"
        case "" -h --help
            echo "Usage: replay <commands>  Run Bash commands replaying changes in Fish"
            echo "Options:"
            echo "       -v or --version  Print version"
            echo "       -h or --help     Print this help message"
        case \*
            set --local env
            set --local sep @$fish_pid(random)(command date +%s)
            set --local out (command bash -c "
                $argv
                status=\$?
                [ \$status -gt 0 ] && exit \$status

                command compgen -e | command awk -v sep=$sep '{
                    gsub(/\n/, \"\\\n\", ENVIRON[\$0])
                    print \$0 sep ENVIRON[\$0]
                }' && alias
            ") || return

            string replace --all -- \\n \n (
                for line in $out
                    if string split $sep $line | read --local --line name value
                        set --append env $name
                   
                        contains -- $name SHLVL PS1 BASH_FUNC || test "$$name" = "$value" && continue

                        if test "$name" = PATH
                            string replace --all : " " "set $name $value"
                        else if test "$name" = PWD
                            echo builtin cd $value
                        else
                            echo "set --global --export $name "(string escape -- $value)
                        end
                    else
                        set --query env[1] && string match --entire --regex -- "^alias" $line || echo "echo \"$line\""
                    end
                end | string replace --all -- \$ \\\$
                for name in (set --export --names)
                    contains -- $name $env || echo "set --erase $name"
                end
            ) | source
    end
end
