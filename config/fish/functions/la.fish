# Defined in - @ line 1
function la --wraps='exa --icons --group-directories-first --all' --description 'alias la exa --icons --group-directories-first --all'
  exa --icons --group-directories-first --all $argv;
end
