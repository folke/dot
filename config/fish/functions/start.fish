function start
    set service_name $argv[1]

    # Start the service
    sudo systemctl start $service_name

    # Wait for the service to become active
    while true
        if systemctl is-active --quiet $service_name
            break
        else
            echo "Waiting for service to start..."
            sleep 1
        end
    end

    # Optionally, show some of the recent logs for the service
    journalctl -u $service_name --no-pager -n 10
end
