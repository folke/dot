function show_help
    # Save the current command line
    set -l cmd (commandline)
    set -l cursor_pos (commandline -C)

    # Execute the help command with pager
    eval "$cmd --help 2>&1 | bat --plain --language help --paging always"

    # Restore the command line
    commandline -r $cmd
    commandline -C $cursor_pos
    commandline -f repaint
end
