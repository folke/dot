
fish_add_path -p ~/.fnm/aliases/default/bin
fish_add_path -p ~/.local/bin/pnpm

function _fnm_autoload_hook --on-variable PWD --description 'Change Node version on directory change'
    status --is-command-substitution; and return
    if test -f .node-version -o -f .nvmrc
        fnm --log-level error use
    end
end
