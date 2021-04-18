# Defined via `source`
function dotgit --wraps='hub -C ~/projects/dot/' --description 'alias dotgit hub -C ~/projects/dot/'
  hub -C ~/projects/dot/ $argv; 
end
