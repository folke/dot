function slay
    # Get list of high CPU usage processes (pid, cpu%, command)
    top -b -n1 | awk 'NR>7 {if($9 > 90) print $1, $9, $12}' | while read pid cpu command
        echo "Killing PID $pid ($command) for high CPU usage: $cpu%"
        kill -9 $pid
    end
end
