# Defined in - @ line 1
function ls --wraps='exa --icons --group-directories-first' --description 'alias ls=exa --icons --group-directories-first'
  exa --icons --group-directories-first $argv;
end
