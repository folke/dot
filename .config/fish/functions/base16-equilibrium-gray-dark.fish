# base16-fish-shell (https://github.com/FabioAntunes/base16-fish-shell)
# Inspired by base16-shell (https://github.com/chriskempson/base16-shell)
# Equilibrium Gray Dark scheme by Carlo Abelli

function base16-equilibrium-gray-dark -d "base16 Equilibrium Gray Dark theme"
    set options (fish_opt --short=t --long=test)
    argparse $options -- $argv
    set padded_seq_values (seq -w 0 21)

    # colors
    set color00 "11/11/11" # Base 00 - Black
    set color01 "f0/43/39" # Base 08 - Red
    set color02 "7f/8b/00" # Base 0B - Green
    set color03 "bb/88/01" # Base 0A - Yellow
    set color04 "00/8d/d1" # Base 0D - Blue
    set color05 "6a/7f/d2" # Base 0E - Magenta
    set color06 "00/94/8b" # Base 0C - Cyan
    set color07 "ab/ab/ab" # Base 05 - White
    set color08 "77/77/77" # Base 03 - Bright Black
    set color09 $color01 # Base 08 - Bright Red
    set color10 $color02 # Base 0B - Bright Green
    set color11 $color03 # Base 0A - Bright Yellow
    set color12 $color04 # Base 0D - Bright Blue
    set color13 $color05 # Base 0E - Bright Magenta
    set color14 $color06 # Base 0C - Bright Cyan
    set color15 "e2/e2/e2" # Base 07 - Bright White
    set color16 "df/59/23" # Base 09
    set color17 "e3/48/8e" # Base 0F
    set color18 "1b/1b/1b" # Base 01
    set color19 "26/26/26" # Base 02
    set color20 "91/91/91" # Base 04
    set color21 "c6/c6/c6" # Base 06
    set color_foreground "ab/ab/ab" # Base 05
    set color_background "11/11/11" # Base 00

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
      __put_template_custom Pg ababab # foreground
      __put_template_custom Ph 111111 # background
      __put_template_custom Pi ababab # bold color
      __put_template_custom Pj 262626 # selection color
      __put_template_custom Pk ababab # selected text color
      __put_template_custom Pl ababab # cursor
      __put_template_custom Pm 111111 # cursor text

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

    set -gx fish_color_autosuggestion "777777" brblack
    set -gx fish_pager_color_description "df5923" yellow

    __base16_fish_shell_set_background "11" "11" "11"
    __base16_fish_shell_create_vimrc_background equilibrium-gray-dark
    set -U base16_fish_theme equilibrium-gray-dark

    if test -n "$_flag_t"
        set base16_colors
        for seq_value in $padded_seq_values
            set base16_colors $base16_colors $seq_value
        end
        set base16_colors $base16_colors

        __base16_fish_shell_color_test $base16_colors
    end
end
