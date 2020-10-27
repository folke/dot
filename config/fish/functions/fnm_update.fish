# Defined in /Users/folke/.config/fish/conf.d/fnm.fish @ line 15
function fnm_update
    set -l last (fnm ls-remote | tail -1)
    fnm install $last
    fnm alias $last latest
    fnm alias $last default
    fnm use default
end
