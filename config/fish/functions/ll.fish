# Defined in - @ line 1
function ll --wraps='exa --color=always --icons --group-directories-first --all --long' --description 'alias ll exa --color=always --icons --group-directories-first --all --long'
  exa --color=always --icons --group-directories-first --all --long $argv;
end
