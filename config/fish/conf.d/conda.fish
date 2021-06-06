eval conda "shell.fish" "hook" $argv | source

# don't add the conda prompt. This is done by starship
function __conda_add_prompt
end
