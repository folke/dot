
# Function to install a new Neovim profile from a given Git URL
function ln_dot -a name
    if test -z "$name"
        echo "Usage: ln_dot <name>"
        return 1
    end

    set -l src ~/dot/config/$name
    set -l dest ~/.config/$name

    if test -L $dest
        echo "Link $dest already exists"
        return 1
    end

    if test -d $dest
        if test -d $src
            echo "Directory $src already exists"
            return 1
        end
        echo "Moving $dest to $src"
        mv $dest $src
    end
    ln -s $src $dest
end
