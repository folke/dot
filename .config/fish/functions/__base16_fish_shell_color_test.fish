function __base16_fish_shell_color_test -d "Util function that generates colour output"
    set ansi_mappings Black Red Green Yellow Blue Magenta Cyan White "Bright Black" "Bright Red" "Bright Green" "Bright Yellow" "Bright Blue" "Bright Magenta" "Bright Cyan" "Bright White"
    set colors base00 base08 base0B base0A base0D base0E base0C base05 base03 base08 base0B base0A base0D base0E base0C base07 base09 base0F base01 base02 base04 base06
    set base16_colors $argv
    set padded_values (seq -w 0 21)
    set non_padded_values (seq 0 21)

    for base16_color in $base16_colors
      set -l index (contains -i -- $base16_color $base16_colors)
      set -q ansi_mappings[$index]; or set ansi_mappings[$index] ""
      set current_color (string replace -a / "" $base16_color)

      set block (printf "\x1b[48;5;""$non_padded_values[$index]"m___________________________)
      set foreground (printf "\x1b[38;5;""$non_padded_values[$index]"m"color$padded_values[$index]")

      printf "%s %s %s %-30s %s\x1b[0m\n" $foreground $colors[$index] $current_color $ansi_mappings[$index] $block
    end
end
