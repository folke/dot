set -g git_worktrees_root ~/projects/git-worktrees
mkdir -p $git_worktrees_root

function gw -a name
    if test -z "$name"
        gwm # switch to main or latest worktree
        return 0
    end

    set -l repo (basename (git rev-parse --show-toplevel))
    set -l path $git_worktrees_root/$repo-$name

    if not test -d $path
        git worktree add $path -b $name
        echo "Created worktree '$name' at $path"
    end
    cd $path
end

function gpr -a pr
    if test -z "$pr"
        echo "Usage: gpr <pr-number-or-branch>"
        return 1
    end

    set -l branch (gh pr view "$pr" --json headRefName -q .headRefName)
    set -l repo (basename (git rev-parse --show-toplevel))
    set -l path $git_worktrees_root/$repo-$pr-$branch

    if not test -d $path
        git worktree add $path || return 1
        cd $path # needed for gh to work correctly
        gh pr checkout $pr || return 1
    end
    cd $path # switch to the worktree
end

function gwl
    set -l current (pwd)
    set -l worktrees (git worktree list | awk '{print $1}')
    set -l filtered
    for wt in $worktrees
        if test "$wt" != "$current"
            set -a filtered $wt
        end
    end
    set -l selected (printf '%s\n' $filtered | fzf)
    if test -n "$selected"
        cd $selected
    end
end

function gwr
    set -l selected (git worktree list | tail -n +2 | fzf | awk '{print $1}')
    if test -n "$selected"
        set -l main (git worktree list | head -n 1 | awk '{print $1}')
        cd $main
        git worktree remove $selected
    end
end

function gwm
    set -l current (pwd)
    set -l main (git worktree list | head -n 1 | awk '{print $1}')

    if test "$current" = "$main"
        # We're in main, go to most recent worktree
        set -l latest (git worktree list | tail -n 1 | awk '{print $1}')
        if test "$latest" != "$main"
            cd $latest
        end
    else
        # We're in a worktree, go to main
        cd $main
    end
end
