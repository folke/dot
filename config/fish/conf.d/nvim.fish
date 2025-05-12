set -g nvim_current ~/.local/share/bob/v0.10.4/bin/nvim
set -g nvim_old ~/.local/share/bob/v0.9.5/nvim-linux64/bin/nvim


abbr -a nvim_current $nvim_current
abbr -a nvim_old $nvim_old

function repro -a issue
    argparse --min-args=1 n 'v/version=?' s/silent -- $argv
    or return $status

    set issue $argv[1]
    set file ./debug/$issue.lua

    # Fetch the issue if it doesn't exist
    if not test -f $file
        echo "Fetching issue #$issue"
        gh issue view $issue | sed -n '/```[Ll]ua/,/```/p' | sed '1d;$d' >$file
    end

    # Use local lazy and plugins
    set -x LAZY_PATH ~/projects/lazy.nvim
    set -x LAZY_DEV "folke,LazyVim"

    # Format the file
    stylua $file

    if [ "$_flag_v" = stable ]
        set _flag_v ''
    end

    set nvim nvim
    if set -q _flag_v
        fd --type=d --maxdepth=1 "^v$_flag_v" ~/.local/share/bob
        set nvim_dir (fd --type=d --maxdepth=1 "^v$_flag_v" ~/.local/share/bob | sort -V | tail -1)
        set nvim (fd --type=x '^nvim$' $nvim_dir -1)
        if test -z "$nvim"
            echo "Version v$_flag_v not found"
            return 1
        end
    end

    # Run the repro
    if set -q _flag_s
        $nvim -u $file
    else
        $nvim -u $file $file
    end
end

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

function nvims_clean -a profile
    if test -z "$profile"
        echo "Usage: nvim_clean <profile>"
        return 1
    end

    test -d ~/.local/share/nvim-profiles/$profile
    and rm -rf ~/.local/share/nvim-profiles/$profile

    test -d ~/.local/state/nvim-profiles/$profile
    and rm -rf ~/.local/state/nvim-profiles/$profile

    test -d ~/.cache/nvim-profiles/$profile
    and rm -rf ~/.cache/nvim-profiles/$profile
end
