# Defined in - @ line 1
function ll --wraps='exa --icons --group-directories-first --all --long' --description 'alias ll exa --icons --group-directories-first --all --long'
  exa --icons --group-directories-first --all --long $argv;
end
