if test -n "$DESKTOP_SESSION"
    for env_var in (gnome-keyring-daemon --start 2> /dev/null)
        set -x (echo $env_var | string split "=")
    end
end
