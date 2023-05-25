function _autopair_insert_same --argument-names key
    set --local buffer (commandline)
    set --local index (commandline --cursor)
    set --local next (string sub --start=(math $index + 1) --length=1 -- "$buffer")

    if test (math (count (string match --all --regex -- "$key" "$buffer")) % 2) = 0
        test $key = $next && commandline --cursor (math $index + 1) && return

        commandline --insert -- $key

        if test $index -lt 1 ||
                contains -- (string sub --start=$index --length=1 -- "$buffer") "" " " $autopair_left &&
                contains -- $next "" " " $autopair_right
            commandline --insert -- $key
            commandline --cursor (math $index + 1)
        end
    else
        commandline --insert -- $key
    end
end
