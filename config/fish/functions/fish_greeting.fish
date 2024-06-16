function fish_greeting
    if not status is-interactive
        exit
    end
    fastfetch --kitty ~/.config/wall.png
end
