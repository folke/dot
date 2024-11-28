function clean
    sudo paccache -rk1
    sudo paccache -ruk0
    paru -Sccd --noconfirm
    cargo cache -a
    yarn cache clean
    pnpm store prune
    pip cache purge
    sudo docker system prune -a -f
    podman system prune -a -f
    start snapper-cleanup.service
    sudo systemctl status snapper-cleanup.service
    duf
end
