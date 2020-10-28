
function man --wraps man
    set -l end (set_color normal)

    set -l bold (set_color -o $fish_color_param)
    set -l standout (set_color $fish_color_comment)
    set -l underline (set_color $fish_color_command --underline)

    set -lx LESS_TERMCAP_md $bold
    set -lx LESS_TERMCAP_me $end
    set -lx LESS_TERMCAP_so $standout
    set -lx LESS_TERMCAP_se $end
    set -lx LESS_TERMCAP_us $underline
    set -lx LESS_TERMCAP_ue $end
    set -lx LESS '-rsF -m +Gg'
    MANPAGER=less command man $argv
end
