status is-interactive || exit

set --global autopair_left "(" "[" "{" '"' "'"
set --global autopair_right ")" "]" "}" '"' "'"
set --global autopair_pairs "()" "[]" "{}" '""' "''"

function _autopair_fish_key_bindings --on-variable fish_key_bindings
    set --query fish_key_bindings[1] || return

    test $fish_key_bindings = fish_default_key_bindings &&
        set --local mode default insert ||
        set --local mode insert default

    bind --mode $mode[-1] --erase \177 \b \t

    bind --mode $mode[1] \177 _autopair_backspace # macOS ⌫
    bind --mode $mode[1] \b _autopair_backspace
    bind --mode $mode[1] \t _autopair_tab

    printf "%s\n" $autopair_pairs | while read --local left right --delimiter ""
        bind --mode $mode[-1] --erase $left $right
        if test $left = $right
            bind --mode $mode[1] $left "_autopair_insert_same \\$left"
        else
            bind --mode $mode[1] $left "_autopair_insert_left \\$left \\$right"
            bind --mode $mode[1] $right "_autopair_insert_right \\$right"
        end
    end
end

_autopair_fish_key_bindings

function _autopair_uninstall --on-event autopair_uninstall
    string collect (
        bind --all | string replace --filter --regex -- "_autopair.*" --erase
        set --names | string replace --filter --regex -- "^autopair" "set --erase autopair"
    ) | source
    functions --erase (functions --all | string match "_autopair_*")
end
