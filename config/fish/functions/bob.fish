
function bob --wraps bob
    command bob $argv
    set used (cat ~/.local/share/bob/used)
    test -L ~/.local/share/bob/active
    and unlink ~/.local/share/bob/active
    ln -s ~/.local/share/bob/$used/nvim-linux64 ~/.local/share/bob/active
end
