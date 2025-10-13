set bob ~/.local/share/bob
set nvim ~/.local/share/bob/nvim-used

function bob_update
    read -f used <$bob/used
    test -L $nvim; and unlink $nvim
    ln -sfT $bob/$used $nvim
end

function bob --wraps bob
    command bob $argv
    set ret $status
    if test $ret -eq 0
        bob_update
    end
    return $ret
end

function bob_run --wraps nvim -a v
    command bob install $v
    command bob run $v -- $argv[2..-1]
end

bob_update
fish_add_path --path $nvim/bin

alias nvim_stable="bob_run stable"
alias nvim_10="bob_run 0.10.4"
abbr nvim_11 nvim_stable
