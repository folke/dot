
function _z_cd
    cd $argv
    or return $status

    commandline -f repaint

    if test "$_ZO_ECHO" = "1"
        echo $PWD
    end
end

function z
    set argc (count $argv)

    if test $argc -eq 0
        _z_cd $HOME
    else if begin; test $argc -eq 1; and test $argv[1] = '-'; end
        _z_cd -
    else
        set -l _zoxide_result (zoxide query -- $argv)
        and _z_cd $_zoxide_result
    end
end

function zi
    set -l _zoxide_result (zoxide query -i -- $argv)
    and _z_cd $_zoxide_result
end


abbr -a za 'zoxide add'

abbr -a zq 'zoxide query'
abbr -a zqi 'zoxide query -i'

abbr -a zr 'zoxide remove'
function zri
    set -l _zoxide_result (zoxide query -i -- $argv)
    and zoxide remove $_zoxide_result
end


function _zoxide_hook --on-variable PWD
    zoxide add (pwd -L)
end

