# base16-fish-shell (https://github.com/FabioAntunes/base16-fish-shell)
# Inspired by base16-shell (https://github.com/chriskempson/base16-shell)
# Eighties scheme by Chris Kempson (http://chriskempson.com)

function base16-eighties -d "base16 Eighties theme"
    set options (fish_opt --short=t --long=test)
    argparse $options -- $argv
    set padded_seq_values (seq -w 0 21)

    # colors
    set color00 "2d/2d/2d" # Base 00 - Black
    set color01 "f2/77/7a" # Base 08 - Red
    set color02 "99/cc/99" # Base 0B - Green
    set color03 "ff/cc/66" # Base 0A - Yellow
    set color04 "66/99/cc" # Base 0D - Blue
    set color05 "cc/99/cc" # Base 0E - Magenta
    set color06 "66/cc/cc" # Base 0C - Cyan
    set color07 "d3/d0/c8" # Base 05 - White
    set color08 "74/73/69" # Base 03 - Bright Black
    set color09 $color01 # Base 08 - Bright Red
    set color10 $color02 # Base 0B - Bright Green
    set color11 $color03 # Base 0A - Bright Yellow
    set color12 $color04 # Base 0D - Bright Blue
    set color13 $color05 # Base 0E - Bright Magenta
    set color14 $color06 # Base 0C - Bright Cyan
    set color15 "f2/f0/ec" # Base 07 - Bright White
    set color16 "f9/91/57" # Base 09
    set color17 "d2/7b/53" # Base 0F
    set color18 "39/39/39" # Base 01
    set color19 "51/51/51" # Base 02
    set color20 "a0/9f/93" # Base 04
    set color21 "e8/e6/df" # Base 06
    set color_foreground "d3/d0/c8" # Base 05
    set color_background "2d/2d/2d" # Base 00

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
      __put_template_custom Pg d3d0c8 # foreground
      __put_template_custom Ph 2d2d2d # background
      __put_template_custom Pi d3d0c8 # bold color
      __put_template_custom Pj 515151 # selection color
      __put_template_custom Pk d3d0c8 # selected text color
      __put_template_custom Pl d3d0c8 # cursor
      __put_template_custom Pm 2d2d2d # cursor text

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

    set -gx fish_color_autosuggestion "747369" brblack
    set -gx fish_pager_color_description "f99157" yellow

    __base16_fish_shell_set_background "2d" "2d" "2d"
    __base16_fish_shell_create_vimrc_background eighties
    set -U base16_fish_theme eighties

    if test -n "$_flag_t"
        set base16_colors
        for seq_value in $padded_seq_values
            set base16_colors $base16_colors $seq_value
        end
        set base16_colors $base16_colors

        __base16_fish_shell_color_test $base16_colors
    end
end
