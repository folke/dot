# base16-fish-shell (https://github.com/FabioAntunes/base16-fish-shell)
# Inspired by base16-shell (https://github.com/chriskempson/base16-shell)
# PaperColor Dark scheme by Jon Leopard (http://github.com/jonleopard) based on PaperColor Theme (https://github.com/NLKNguyen/papercolor-theme)

function base16-papercolor-dark -d "base16 PaperColor Dark theme"
    set options (fish_opt --short=t --long=test)
    argparse $options -- $argv
    set padded_seq_values (seq -w 0 21)

    # colors
    set color00 "1c/1c/1c" # Base 00 - Black
    set color01 "58/58/58" # Base 08 - Red
    set color02 "af/87/d7" # Base 0B - Green
    set color03 "af/d7/00" # Base 0A - Yellow
    set color04 "ff/5f/af" # Base 0D - Blue
    set color05 "00/af/af" # Base 0E - Magenta
    set color06 "ff/af/00" # Base 0C - Cyan
    set color07 "80/80/80" # Base 05 - White
    set color08 "d7/af/5f" # Base 03 - Bright Black
    set color09 $color01 # Base 08 - Bright Red
    set color10 $color02 # Base 0B - Bright Green
    set color11 $color03 # Base 0A - Bright Yellow
    set color12 $color04 # Base 0D - Bright Blue
    set color13 $color05 # Base 0E - Bright Magenta
    set color14 $color06 # Base 0C - Bright Cyan
    set color15 "d0/d0/d0" # Base 07 - Bright White
    set color16 "5f/af/5f" # Base 09
    set color17 "5f/87/87" # Base 0F
    set color18 "af/00/5f" # Base 01
    set color19 "5f/af/00" # Base 02
    set color20 "5f/af/d7" # Base 04
    set color21 "d7/87/5f" # Base 06
    set color_foreground "80/80/80" # Base 05
    set color_background "1c/1c/1c" # Base 00

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
      __put_template_custom Pg 808080 # foreground
      __put_template_custom Ph 1c1c1c # background
      __put_template_custom Pi 808080 # bold color
      __put_template_custom Pj 5faf00 # selection color
      __put_template_custom Pk 808080 # selected text color
      __put_template_custom Pl 808080 # cursor
      __put_template_custom Pm 1c1c1c # cursor text

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

    set -gx fish_color_autosuggestion "d7af5f" brblack
    set -gx fish_pager_color_description "5faf5f" yellow

    __base16_fish_shell_set_background "1c" "1c" "1c"
    __base16_fish_shell_create_vimrc_background papercolor-dark
    set -U base16_fish_theme papercolor-dark

    if test -n "$_flag_t"
        set base16_colors
        for seq_value in $padded_seq_values
            set base16_colors $base16_colors $seq_value
        end
        set base16_colors $base16_colors

        __base16_fish_shell_color_test $base16_colors
    end
end
