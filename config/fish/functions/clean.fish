function clean
    sudo paccache -rk1
    sudo paccache -ruk0
    sudo systemctl status snapper-cleanup.service
    duf
end
