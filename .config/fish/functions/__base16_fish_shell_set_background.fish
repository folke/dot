function __base16_fish_shell_set_background -d "base16-fish-shell private function to check if theme is dark or light"
    set red $argv[1]
    set green $argv[2]
    set blue $argv[3]

    set luma (math 0.2126 \* 0x$red + 0.7152 \* 0x$green + 0.0722 \* 0x$blue)

    # luma value range goes from 0 to 255
    # where 0 is darkest and 255 lightest
    if test $luma -lt 128
        set -gx base16_fish_shell_background dark
    else
        set -gx base16_fish_shell_background light
    end
end
