
function conda
    functions -e conda
    eval command conda "shell.fish" hook | source

    # don't add the conda prompt. This is done by starship
    function __conda_add_prompt
    end

    conda $argv
end
