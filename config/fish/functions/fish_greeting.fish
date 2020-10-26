# Defined in - @ line 1
function fish_greeting --wraps=color-test --description 'alias fish_greeting color-test'
  color-test  $argv;
end
