# Defined in /Users/folke/.config/fish/config.fish @ line 92
function yabai_fix
        pgrep yabai | tail -n +2 | head -n1 | xargs kill
end
