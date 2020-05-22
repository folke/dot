function __tf_updt
  set -l tf_vers (thefuck -v 2>&1)
  if test "$__tf_vers" != "$tf_vers" -o -z "$__tf_func"
    set -U __tf_vers $tf_vers
    set -U __tf_func (thefuck -a "__tf_alias" | tr "\n" ";")
    eval $__tf_func
  end
end
