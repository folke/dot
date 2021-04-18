# Defined via `source`
function dotdrop --wraps='command dotdrop -c ~/projects/dot/dotdrop.yaml' --description 'alias dotdrop command dotdrop -c ~/projects/dot/dotdrop.yaml'
  command dotdrop -c ~/projects/dot/dotdrop.yaml $argv; 
end
