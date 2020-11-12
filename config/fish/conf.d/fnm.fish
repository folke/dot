
set -p PATH ~/.fnm/aliases/default/bin
set -p PATH ~/.local/bin/pnpm

function _fnm_autoload_hook --on-variable PWD --description 'Change Node version on directory change'
    status --is-command-substitution; and return
    if test -f .node-version -o -f .nvmrc
        fnm use
    end
end
