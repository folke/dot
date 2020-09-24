function __put_template_custom
  if test -n "$TMUX"
    printf '\033Ptmux;\033\033]%s%s\033\033\\\\\033\\' $argv
  else if string match -q -- 'screen*' $TERM
    printf '\033P\033]%s%s\007\033\\' $argv
  else if string match -q -- 'linux*' $TERM
      true
  else
    printf '\033]%s%s\033\\' $argv
  end
end
