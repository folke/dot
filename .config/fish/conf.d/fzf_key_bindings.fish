if test "$FZF_LEGACY_KEYBINDINGS" -eq 1
    bind \ct '__fzf_find_file'
    bind \cr '__fzf_reverse_isearch'
    bind \ec '__fzf_cd'
    bind \eC '__fzf_cd --hidden'
    bind \cg '__fzf_open'
    bind \co '__fzf_open --editor'

    if bind -M insert >/dev/null 2>/dev/null
        bind -M insert \ct '__fzf_find_file'
        bind -M insert \cr '__fzf_reverse_isearch'
        bind -M insert \ec '__fzf_cd'
        bind -M insert \eC '__fzf_cd --hidden'
        bind -M insert \cg '__fzf_open'
        bind -M insert \co '__fzf_open --editor'
    end
else
    bind \co '__fzf_find_file'
    bind \cr '__fzf_reverse_isearch'
    bind \ec '__fzf_cd'
    bind \eC '__fzf_cd --hidden'
    bind \eO '__fzf_open'
    bind \eo '__fzf_open --editor'

    if bind -M insert >/dev/null 2>/dev/null
        bind -M insert \co '__fzf_find_file'
        bind -M insert \cr '__fzf_reverse_isearch'
        bind -M insert \ec '__fzf_cd'
        bind -M insert \eC '__fzf_cd --hidden'
        bind -M insert \eO '__fzf_open'
        bind -M insert \eo '__fzf_open --editor'
    end
end

if set -q FZF_COMPLETE
    bind \t '__fzf_complete'
    if bind -M insert >/dev/null 2>/dev/null
        bind -M insert \t '__fzf_complete'
    end
end

function fzf_key_bindings_uninstall -e fzf_key_bindings_uninstall
    # disabled until we figure out a sensible way to ensure user overrides
    # are not erased
    # set -l _bindings (bind -a | sed -En "s/(')?__fzf.*\$//p" | sed 's/bind/bind -e/')
    # for binding in $_bindings
    #     eval $binding
    # end
end
