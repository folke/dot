# Function to select or use a given Neovim profile
function nvims --wraps nvim
    set -l profile $argv[1]

    # Check if the provided profile exists
    if test -n "$profile" -a -d ~/.config/nvim-profiles/"$profile"
        set args $argv[2..-1]
    else
        # Use fzf to allow the user to select a profile
        set profile (command ls ~/.config/nvim-profiles/ | fzf --prompt=" Neovim Profile: " --height=~50% --layout=reverse --exit-0)
        if test -z "$profile"
            return 1
        end
    end

    set -l appname nvim-profiles/$profile
    if not test -d ~/.config/"$appname"
        echo "Profile $profile does not exist."
        echo "Use nvims_install to install a new profile."
        return 1
    end

    set -x NVIM_APPNAME $appname
    nvim $args
end

function nvims_tmp --description 'switch to the Neovim config in this directory'
    [ -L ~/.config/nvim-profiles/tmp ]
    and rm ~/.config/nvim-profiles/tmp
    ln -s (realpath .) ~/.config/nvim-profiles/tmp
    and nvims tmp
end

# Autocomplete profiles for the nvims function
complete -f -c nvims -a '(command ls ~/.config/nvim-profiles/)'

# Function to install a new Neovim profile from a given Git URL
function nvims_install -a url -a profile
    if test -z "$profile" -o -z "$url"
        echo "Usage: nvim_profile_install <url> <profile>"
        return 1
    end

    set -l dest ~/.config/nvim-profiles/$profile
    if test -d $dest
        echo "Profile $profile already exists"
        return 1
    end

    git clone $url.git $dest
    nvims $profile
end
