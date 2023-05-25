function _autopair_insert_left --argument-names left right
    set --local buffer (commandline)
    set --local before (commandline --cut-at-cursor)

    commandline --insert -- $left

    switch "$buffer"
        case "$before"{," "\*,$autopair_right\*}
            set --local index (commandline --cursor)
            commandline --insert -- $right
            commandline --cursor $index
    end
end
