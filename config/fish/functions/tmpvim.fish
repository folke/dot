function tmpvim --description 'switch to the Neovim config in this directory'
    set -x NVIM_APPNAME tmpvim
    [ -L ~/.config/tmpvim ]
    and rm ~/.config/tmpvim
    ln -s (realpath .) ~/.config/tmpvim
    and nvim $argv
end
