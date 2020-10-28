# Defined in - @ line 1
function la --wraps='exa --color=always --icons --group-directories-first --all' --description 'alias la exa --color=always --icons --group-directories-first --all'
  exa --color=always --icons --group-directories-first --all $argv;
end
