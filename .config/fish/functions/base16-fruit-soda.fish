# base16-fish-shell (https://github.com/FabioAntunes/base16-fish-shell)
# Inspired by base16-shell (https://github.com/chriskempson/base16-shell)
# Fruit Soda scheme by jozip

function base16-fruit-soda -d "base16 Fruit Soda theme"
    set options (fish_opt --short=t --long=test)
    argparse $options -- $argv
    set padded_seq_values (seq -w 0 21)

    # colors
    set color00 "f1/ec/f1" # Base 00 - Black
    set color01 "fe/3e/31" # Base 08 - Red
    set color02 "47/f7/4c" # Base 0B - Green
    set color03 "f7/e2/03" # Base 0A - Yellow
    set color04 "29/31/df" # Base 0D - Blue
    set color05 "61/1f/ce" # Base 0E - Magenta
    set color06 "0f/9c/fd" # Base 0C - Cyan
    set color07 "51/51/51" # Base 05 - White
    set color08 "b5/b4/b6" # Base 03 - Bright Black
    set color09 $color01 # Base 08 - Bright Red
    set color10 $color02 # Base 0B - Bright Green
    set color11 $color03 # Base 0A - Bright Yellow
    set color12 $color04 # Base 0D - Bright Blue
    set color13 $color05 # Base 0E - Bright Magenta
    set color14 $color06 # Base 0C - Bright Cyan
    set color15 "2d/2c/2c" # Base 07 - Bright White
    set color16 "fe/6d/08" # Base 09
    set color17 "b1/6f/40" # Base 0F
    set color18 "e0/de/e0" # Base 01
    set color19 "d8/d5/d5" # Base 02
    set color20 "97/95/98" # Base 04
    set color21 "47/45/45" # Base 06
    set color_foreground "51/51/51" # Base 05
    set color_background "f1/ec/f1" # Base 00

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
      __put_template_custom Pg 515151 # foreground
      __put_template_custom Ph f1ecf1 # background
      __put_template_custom Pi 515151 # bold color
      __put_template_custom Pj d8d5d5 # selection color
      __put_template_custom Pk 515151 # selected text color
      __put_template_custom Pl 515151 # cursor
      __put_template_custom Pm f1ecf1 # cursor text

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

    set -gx fish_color_autosuggestion "b5b4b6" brblack
    set -gx fish_pager_color_description "fe6d08" yellow

    __base16_fish_shell_set_background "f1" "ec" "f1"
    __base16_fish_shell_create_vimrc_background fruit-soda
    set -U base16_fish_theme fruit-soda

    if test -n "$_flag_t"
        set base16_colors
        for seq_value in $padded_seq_values
            set base16_colors $base16_colors $seq_value
        end
        set base16_colors $base16_colors

        __base16_fish_shell_color_test $base16_colors
    end
end
