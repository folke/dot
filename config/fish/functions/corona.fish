# Defined in /Users/folke/.config/fish/config.fish @ line 100
function corona
    tput civis
    while true
        set stats (curl "https://corona-stats.online/Belgium?source=2" --silent | head -n 7)
        clear
        for line in $stats
            echo $line
        end
        tput cuu1
        sleep 30
    end
end
