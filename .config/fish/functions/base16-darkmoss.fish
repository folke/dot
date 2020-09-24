# base16-fish-shell (https://github.com/FabioAntunes/base16-fish-shell)
# Inspired by base16-shell (https://github.com/chriskempson/base16-shell)
# darkmoss scheme by Gabriel Avanzi (https://github.com/avanzzzi)

function base16-darkmoss -d "base16 darkmoss theme"
    set options (fish_opt --short=t --long=test)
    argparse $options -- $argv
    set padded_seq_values (seq -w 0 21)

    # colors
    set color00 "17/1e/1f" # Base 00 - Black
    set color01 "ff/46/58" # Base 08 - Red
    set color02 "49/91/80" # Base 0B - Green
    set color03 "fd/b1/1f" # Base 0A - Yellow
    set color04 "49/80/91" # Base 0D - Blue
    set color05 "9b/c0/c8" # Base 0E - Magenta
    set color06 "66/d9/ef" # Base 0C - Cyan
    set color07 "c7/c7/a5" # Base 05 - White
    set color08 "55/5e/5f" # Base 03 - Bright Black
    set color09 $color01 # Base 08 - Bright Red
    set color10 $color02 # Base 0B - Bright Green
    set color11 $color03 # Base 0A - Bright Yellow
    set color12 $color04 # Base 0D - Bright Blue
    set color13 $color05 # Base 0E - Bright Magenta
    set color14 $color06 # Base 0C - Bright Cyan
    set color15 "e1/ea/ef" # Base 07 - Bright White
    set color16 "e6/db/74" # Base 09
    set color17 "d2/7b/53" # Base 0F
    set color18 "25/2c/2d" # Base 01
    set color19 "37/3c/3d" # Base 02
    set color20 "81/8f/80" # Base 04
    set color21 "e3/e3/c8" # Base 06
    set color_foreground "c7/c7/a5" # Base 05
    set color_background "17/1e/1f" # Base 00

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
      __put_template_custom Pg c7c7a5 # foreground
      __put_template_custom Ph 171e1f # background
      __put_template_custom Pi c7c7a5 # bold color
      __put_template_custom Pj 373c3d # selection color
      __put_template_custom Pk c7c7a5 # selected text color
      __put_template_custom Pl c7c7a5 # cursor
      __put_template_custom Pm 171e1f # cursor text

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

    set -gx fish_color_autosuggestion "555e5f" brblack
    set -gx fish_pager_color_description "e6db74" yellow

    __base16_fish_shell_set_background "17" "1e" "1f"
    __base16_fish_shell_create_vimrc_background darkmoss
    set -U base16_fish_theme darkmoss

    if test -n "$_flag_t"
        set base16_colors
        for seq_value in $padded_seq_values
            set base16_colors $base16_colors $seq_value
        end
        set base16_colors $base16_colors

        __base16_fish_shell_color_test $base16_colors
    end
end
