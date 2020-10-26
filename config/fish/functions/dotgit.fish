# Defined in - @ line 1
function dotgit --wraps='hub -C ~/projects/dot/' --description 'alias dotgit hub -C ~/projects/dot/'
  hub -C ~/projects/dot/ $argv;
end
