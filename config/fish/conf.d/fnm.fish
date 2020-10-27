
set -p PATH ~/.fnm/aliases/default/bin

function _fnm_autoload_hook --on-variable PWD --description 'Change Node version on directory change'
    status --is-command-substitution; and return
    if test -f .node-version
        echo "fnm: Found .node-version"
        fnm use
    else if test -f .nvmrc
        echo "fnm: Found .nvmrc"
        fnm use
    end
end

function fnm_update
    set -l last (fnm ls-remote | tail -1)
    fnm install $last
    fnm alias $last latest
    fnm alias $last default
    fnm use default
end
