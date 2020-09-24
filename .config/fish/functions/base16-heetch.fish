# base16-fish-shell (https://github.com/FabioAntunes/base16-fish-shell)
# Inspired by base16-shell (https://github.com/chriskempson/base16-shell)
# Heetch Dark scheme by Geoffrey Teale (tealeg@gmail.com)

function base16-heetch -d "base16 Heetch Dark theme"
    set options (fish_opt --short=t --long=test)
    argparse $options -- $argv
    set padded_seq_values (seq -w 0 21)

    # colors
    set color00 "19/01/34" # Base 00 - Black
    set color01 "27/d9/d5" # Base 08 - Red
    set color02 "c3/36/78" # Base 0B - Green
    set color03 "8f/6c/97" # Base 0A - Yellow
    set color04 "bd/01/52" # Base 0D - Blue
    set color05 "82/03/4c" # Base 0E - Magenta
    set color06 "f8/00/59" # Base 0C - Cyan
    set color07 "bd/b6/c5" # Base 05 - White
    set color08 "7b/6d/8b" # Base 03 - Bright Black
    set color09 $color01 # Base 08 - Bright Red
    set color10 $color02 # Base 0B - Bright Green
    set color11 $color03 # Base 0A - Bright Yellow
    set color12 $color04 # Base 0D - Bright Blue
    set color13 $color05 # Base 0E - Bright Magenta
    set color14 $color06 # Base 0C - Bright Cyan
    set color15 "fe/ff/ff" # Base 07 - Bright White
    set color16 "5b/a2/b6" # Base 09
    set color17 "47/05/46" # Base 0F
    set color18 "39/25/51" # Base 01
    set color19 "5a/49/6e" # Base 02
    set color20 "9c/92/a8" # Base 04
    set color21 "de/da/e2" # Base 06
    set color_foreground "bd/b6/c5" # Base 05
    set color_background "19/01/34" # Base 00

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
      __put_template_custom Pg bdb6c5 # foreground
      __put_template_custom Ph 190134 # background
      __put_template_custom Pi bdb6c5 # bold color
      __put_template_custom Pj 5a496e # selection color
      __put_template_custom Pk bdb6c5 # selected text color
      __put_template_custom Pl bdb6c5 # cursor
      __put_template_custom Pm 190134 # cursor text

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

    set -gx fish_color_autosuggestion "7b6d8b" brblack
    set -gx fish_pager_color_description "5ba2b6" yellow

    __base16_fish_shell_set_background "19" "01" "34"
    __base16_fish_shell_create_vimrc_background heetch
    set -U base16_fish_theme heetch

    if test -n "$_flag_t"
        set base16_colors
        for seq_value in $padded_seq_values
            set base16_colors $base16_colors $seq_value
        end
        set base16_colors $base16_colors

        __base16_fish_shell_color_test $base16_colors
    end
end
