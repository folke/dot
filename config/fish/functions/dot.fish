
function _dot_add -a name
    set -l src ~/dot/config/$name
    set -l dest ~/.config/$name

    # src should exist and be a file or a directory
    # dest should not exist
    if not test -f $dest -o -d $dest
        echo "$dest does not exist"
        return 1
    end

    if test -e $src
        echo "$src already exists"
        return 1
    end

    mv -v $dest $src
    ln -sv $src $dest
end

function _dot_del -a name
    # remove the symlink and move the directory back
    set -l src ~/dot/config/$name
    set -l dest ~/.config/$name

    if not test -e $src
        echo "$src does not exist"
        return 1
    end

    if not test -L $dest
        echo "$dest is not a symlink"
        return 1
    end

    rm -v $dest
    mv -v $src $dest
end

function _dot_help
    echo "Usage: dot [add|del] <name>"
    return 1
end

function dot -a cmd
    if test (count $argv) -lt 2
        _dot_help
        return 1
    end
    switch $cmd
        case add
            _dot_add $argv[2]
        case del
            _dot_del $argv[2]
        case '*'
            _dot_help
            return 1
    end
end
