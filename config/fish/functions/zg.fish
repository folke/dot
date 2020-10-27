function zg --description 'Jumps to parent git repo'
    set -l d (pwd)
    if test -d $d/.git
        return
    end
    while test $d != "/"
        if test -d $d/.git
            cd $d
            return
        else
            set d (dirname $d)
        end
    end
    echo "Not in a Git repository"
    return 1
end
