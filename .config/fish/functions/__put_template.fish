function __put_template -d "base16-fish-shell private function"
  if test -n "$TMUX"
    printf '\033Ptmux;\033\033]4;%d;rgb:%s\033\033\\\\\033\\' $argv
  else if string match -q -- '*screen*' $TERM
    printf '\033P\033]4;%d;rgb:%s\007\033\\' $argv
  else if string match -q -- 'linux*' $TERM
    test $argv[1] -lt 16 && printf "\e]P%x%s" $argv[1] (echo $argv[2] | sed 's/\///g')
  else
    printf '\033]4;%d;rgb:%s\033\\' $argv
  end
end
