function n --wraps "niri msg"
    set -l ret (CLICOLOR_FORCE=1 niri msg --json $argv)
    set -l code $status
    # if output looks like json [{, pretty print it
    if string match -qr '^\s*[\[{]' $ret
        echo $ret | jq
    else
        printf '%s\n' $ret
    end
    return $code
end
