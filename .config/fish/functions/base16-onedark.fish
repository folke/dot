# base16-fish-shell (https://github.com/FabioAntunes/base16-fish-shell)
# Inspired by base16-shell (https://github.com/chriskempson/base16-shell)
# OneDark scheme by Lalit Magant (http://github.com/tilal6991)

function base16-onedark -d "base16 OneDark theme"
    set options (fish_opt --short=t --long=test)
    argparse $options -- $argv
    set padded_seq_values (seq -w 0 21)

    # colors
    set color00 "28/2c/34" # Base 00 - Black
    set color01 "e0/6c/75" # Base 08 - Red
    set color02 "98/c3/79" # Base 0B - Green
    set color03 "e5/c0/7b" # Base 0A - Yellow
    set color04 "61/af/ef" # Base 0D - Blue
    set color05 "c6/78/dd" # Base 0E - Magenta
    set color06 "56/b6/c2" # Base 0C - Cyan
    set color07 "ab/b2/bf" # Base 05 - White
    set color08 "54/58/62" # Base 03 - Bright Black
    set color09 $color01 # Base 08 - Bright Red
    set color10 $color02 # Base 0B - Bright Green
    set color11 $color03 # Base 0A - Bright Yellow
    set color12 $color04 # Base 0D - Bright Blue
    set color13 $color05 # Base 0E - Bright Magenta
    set color14 $color06 # Base 0C - Bright Cyan
    set color15 "c8/cc/d4" # Base 07 - Bright White
    set color16 "d1/9a/66" # Base 09
    set color17 "be/50/46" # Base 0F
    set color18 "35/3b/45" # Base 01
    set color19 "3e/44/51" # Base 02
    set color20 "56/5c/64" # Base 04
    set color21 "b6/bd/ca" # Base 06
    set color_foreground "ab/b2/bf" # Base 05
    set color_background "28/2c/34" # Base 00

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
      __put_template_custom Pg abb2bf # foreground
      __put_template_custom Ph 282c34 # background
      __put_template_custom Pi abb2bf # bold color
      __put_template_custom Pj 3e4451 # selection color
      __put_template_custom Pk abb2bf # selected text color
      __put_template_custom Pl abb2bf # cursor
      __put_template_custom Pm 282c34 # cursor text

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

    set -gx fish_color_autosuggestion "545862" brblack
    set -gx fish_pager_color_description "d19a66" yellow

    __base16_fish_shell_set_background "28" "2c" "34"
    __base16_fish_shell_create_vimrc_background onedark
    set -U base16_fish_theme onedark

    if test -n "$_flag_t"
        set base16_colors
        for seq_value in $padded_seq_values
            set base16_colors $base16_colors $seq_value
        end
        set base16_colors $base16_colors

        __base16_fish_shell_color_test $base16_colors
    end
end
