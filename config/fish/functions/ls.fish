# Defined in - @ line 1
function ls --wraps='exa --color=always --icons --group-directories-first' --description 'alias ls=exa --color=always --icons --group-directories-first'
  exa --color=always --icons --group-directories-first $argv;
end
