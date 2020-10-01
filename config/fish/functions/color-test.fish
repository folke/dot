# Defined in /Users/folke/.config/fish/config.fish @ line 144
function color-test
    set scripts square crunch alpha spectrum unowns.py ghosts monster
    set script "$HOME/projects/color-scripts/color-scripts/"(random choice $scripts)
    $script
end
