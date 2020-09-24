function __put_template_var -d "base16-fish-shell private function"
  if test -n "$TMUX"
    printf '\033Ptmux;\033\033]%d;rgb:%s\033\033\\\\\033\\' $argv
  else if string match -q -- 'screen*' $TERM
    printf '\033P\033]%d;rgb:%s\007\033\\' $argv
  else if string match -q -- 'linux*' $TERM
    true
  else
    printf '\033]%d;rgb:%s\033\\' $argv
  end
end
