# base16-fish-shell (https://github.com/FabioAntunes/base16-fish-shell)
# Inspired by base16-shell (https://github.com/chriskempson/base16-shell)
# Material Vivid scheme by joshyrobot

function base16-material-vivid -d "base16 Material Vivid theme"
    set options (fish_opt --short=t --long=test)
    argparse $options -- $argv
    set padded_seq_values (seq -w 0 21)

    # colors
    set color00 "20/21/24" # Base 00 - Black
    set color01 "f4/43/36" # Base 08 - Red
    set color02 "00/e6/76" # Base 0B - Green
    set color03 "ff/eb/3b" # Base 0A - Yellow
    set color04 "21/96/f3" # Base 0D - Blue
    set color05 "67/3a/b7" # Base 0E - Magenta
    set color06 "00/bc/d4" # Base 0C - Cyan
    set color07 "80/86/8b" # Base 05 - White
    set color08 "44/46/4d" # Base 03 - Bright Black
    set color09 $color01 # Base 08 - Bright Red
    set color10 $color02 # Base 0B - Bright Green
    set color11 $color03 # Base 0A - Bright Yellow
    set color12 $color04 # Base 0D - Bright Blue
    set color13 $color05 # Base 0E - Bright Magenta
    set color14 $color06 # Base 0C - Bright Cyan
    set color15 "ff/ff/ff" # Base 07 - Bright White
    set color16 "ff/98/00" # Base 09
    set color17 "8d/6e/63" # Base 0F
    set color18 "27/29/2c" # Base 01
    set color19 "32/36/39" # Base 02
    set color20 "67/6c/71" # Base 04
    set color21 "9e/9e/9e" # Base 06
    set color_foreground "80/86/8b" # Base 05
    set color_background "20/21/24" # Base 00

    # 16 color space
    __put_template 0  $color00
    __put_template 1  $color01
    __put_template 2  $color02
    __put_template 3  $color03
    __put_template 4  $color04
    __put_template 5  $color05
    __put_template 6  $color06
    __put_template 7  $color07
    __put_template 8  $color08
    __put_template 9  $color09
    __put_template 10 $color10
    __put_template 11 $color11
    __put_template 12 $color12
    __put_template 13 $color13
    __put_template 14 $color14
    __put_template 15 $color15

    # 256 color space
    __put_template 16 $color16
    __put_template 17 $color17
    __put_template 18 $color18
    __put_template 19 $color19
    __put_template 20 $color20
    __put_template 21 $color21

    # foreground / background / cursor color
    if test -n "$ITERM_SESSION_ID"
      # iTerm2 proprietary escape codes
      __put_template_custom Pg 80868b # foreground
      __put_template_custom Ph 202124 # background
      __put_template_custom Pi 80868b # bold color
      __put_template_custom Pj 323639 # selection color
      __put_template_custom Pk 80868b # selected text color
      __put_template_custom Pl 80868b # cursor
      __put_template_custom Pm 202124 # cursor text

    else
      __put_template_var 10 $color_foreground
      if test "$BASE16_SHELL_SET_BACKGROUND" != false
        __put_template_var 11 $color_background
        if string match -q -- '*rxvt*' $TERM
          __put_template_var 708 $color_background # internal border (rxvt)
        end
      end
      __put_template_custom 12 ";7" # cursor (reverse video)
    end

    set -gx fish_color_autosuggestion "44464d" brblack
    set -gx fish_pager_color_description "ff9800" yellow

    __base16_fish_shell_set_background "20" "21" "24"
    __base16_fish_shell_create_vimrc_background material-vivid
    set -U base16_fish_theme material-vivid

    if test -n "$_flag_t"
        set base16_colors
        for seq_value in $padded_seq_values
            set base16_colors $base16_colors $seq_value
        end
        set base16_colors $base16_colors

        __base16_fish_shell_color_test $base16_colors
    end
end
