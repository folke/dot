function _autopair_insert_right --argument-names key
    set --local buffer (commandline)
    set --local before (commandline --cut-at-cursor)

    switch "$buffer"
        case "$before$key"\*
            commandline --cursor (math (commandline --cursor) + 1)
        case \*
            commandline --insert -- $key
    end
end
