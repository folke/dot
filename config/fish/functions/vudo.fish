function vudo --wraps='sudo (which nvim)' --description 'alias vudo=sudo (which nvim)'
  sudo (which nvim) $argv; 
end
