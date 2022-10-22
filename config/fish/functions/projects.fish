set -g myprojects (gh repo list --source --no-archived --json name --jq ".[].name")

function projects
    for p in $myprojects
        set fp ~/projects/$p
        # cd $fp
        # # and git remote set-url origin https://github.com/$(git remote get-url origin | sed 's/https:\/\/github.com\///' | sed 's/git@github.com://')
        # and git remote set-url origin git@github.com:$(    git remote get-url origin | sed 's/https:\/\/github.com\///' | sed 's/git@github.com://')
        # and cd ..
        if test ! -d $fp
            echo "[clone] $fp"
            git clone git@github.com:folke/$p.git $fp
        end
    end
end

function projects_update
    projects
    for p in $myprojects
        set fp ~/projects/$p
        echo "[$fp]"
        if test -d $fp
            git -C $fp pull
        end
    end
end
