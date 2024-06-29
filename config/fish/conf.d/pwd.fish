# the following functions are here instead of in the functions directory
# because they utilize event handlers which autoloading does not support

# auto run onefetch if inside git repo
# --on-variable is a fish builtin that changes whenever the directory changes
# so this function will run whenever the directory changes
function auto_pwd --on-variable PWD
    set -x GUM_FORMAT_THEME dark

    # check if .git/ exists and is a git repo and if onefetch is installed
    if test -d .git && git rev-parse --git-dir >/dev/null 2>&1
        # readme file
        if test -f README.md
            awk '/^##/{exit} 1' README.md | string trim \
                | gum format | grep -v 'Image: image' 2>&1 | head -20
        end

        # recent commits
        echo -e "## Recent Activity\n" | gum format
        hub l -10 \
            --since='1 week ago' \
            | devmoji --log --color \
            | sed 's/^/  /'

        # local changes
        echo -e "## Status\n" | gum format
        hub -c color.ui=always st | sed 's/^/  /'
    end
end
