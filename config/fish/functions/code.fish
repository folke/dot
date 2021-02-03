# Defined in - @ line 1
function code 
  codesign --remove-signature '/Applications/Visual Studio Code - Insiders.app/Contents/Frameworks/Code - Insiders Helper (Renderer).app'
  code-insiders $argv;
end
