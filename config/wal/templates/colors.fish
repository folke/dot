#!/usr/bin/env fish

# set fish_color_normal normal
set fish_color_normal {foreground.strip}
# set fish_color_command 005fd7
set fish_color_command {color2.strip}
# set fish_color_param 00afff
set fish_color_param {color1.strip}
# set fish_color_redirection 00afff
set fish_color_redirection $fish_color_param
# set fish_color_comment 990000
set fish_color_comment {color8.strip}
set fish_color_error ef6155
# set fish_color_escape 00a6b2
set fish_color_escape {color5.strip}
# set fish_color_operator 00a6b2
set fish_color_operator $fish_color_escape
set fish_color_end {color4.strip}
set fish_color_quote {color6.strip}
set fish_color_autosuggestion 555 brblack
set fish_color_user brgreen
# set fish_color_host normal
set fish_color_host $fish_color_normal
set fish_color_valid_path --underline
set fish_color_cwd green
set fish_color_cwd_root red
set fish_color_match --background=brblue
set fish_color_search_match bryellow --background=brblack
set fish_color_selection white --bold --background=brblack
set fish_color_cancel -r
set fish_pager_color_prefix white --bold --underline
set fish_pager_color_completion
# set fish_pager_color_description B3A06D yellow
set fish_pager_color_description $fish_color_quote yellow
set fish_pager_color_progress brwhite --background=cyan
set fish_color_history_current --bold
