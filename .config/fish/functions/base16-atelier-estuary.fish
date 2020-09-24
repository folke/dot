# base16-fish-shell (https://github.com/FabioAntunes/base16-fish-shell)
# Inspired by base16-shell (https://github.com/chriskempson/base16-shell)
# Atelier Estuary scheme by Bram de Haan (http://atelierbramdehaan.nl)

function base16-atelier-estuary -d "base16 Atelier Estuary theme"
    set options (fish_opt --short=t --long=test)
    argparse $options -- $argv
    set padded_seq_values (seq -w 0 21)

    # colors
    set color00 "22/22/1b" # Base 00 - Black
    set color01 "ba/62/36" # Base 08 - Red
    set color02 "7d/97/26" # Base 0B - Green
    set color03 "a5/98/0d" # Base 0A - Yellow
    set color04 "36/a1/66" # Base 0D - Blue
    set color05 "5f/91/82" # Base 0E - Magenta
    set color06 "5b/9d/48" # Base 0C - Cyan
    set color07 "92/91/81" # Base 05 - White
    set color08 "6c/6b/5a" # Base 03 - Bright Black
    set color09 $color01 # Base 08 - Bright Red
    set color10 $color02 # Base 0B - Bright Green
    set color11 $color03 # Base 0A - Bright Yellow
    set color12 $color04 # Base 0D - Bright Blue
    set color13 $color05 # Base 0E - Bright Magenta
    set color14 $color06 # Base 0C - Bright Cyan
    set color15 "f4/f3/ec" # Base 07 - Bright White
    set color16 "ae/73/13" # Base 09
    set color17 "9d/6c/7c" # Base 0F
    set color18 "30/2f/27" # Base 01
    set color19 "5f/5e/4e" # Base 02
    set color20 "87/85/73" # Base 04
    set color21 "e7/e6/df" # Base 06
    set color_foreground "92/91/81" # Base 05
    set color_background "22/22/1b" # Base 00

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
      __put_template_custom Pg 929181 # foreground
      __put_template_custom Ph 22221b # background
      __put_template_custom Pi 929181 # bold color
      __put_template_custom Pj 5f5e4e # selection color
      __put_template_custom Pk 929181 # selected text color
      __put_template_custom Pl 929181 # cursor
      __put_template_custom Pm 22221b # cursor text

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

    set -gx fish_color_autosuggestion "6c6b5a" brblack
    set -gx fish_pager_color_description "ae7313" yellow

    __base16_fish_shell_set_background "22" "22" "1b"
    __base16_fish_shell_create_vimrc_background atelier-estuary
    set -U base16_fish_theme atelier-estuary

    if test -n "$_flag_t"
        set base16_colors
        for seq_value in $padded_seq_values
            set base16_colors $base16_colors $seq_value
        end
        set base16_colors $base16_colors

        __base16_fish_shell_color_test $base16_colors
    end
end
