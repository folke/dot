function __base16_fish_shell_create_vimrc_background -d "base16-fish-shell private function to generate vimrc background"
    echo -e "if !exists('g:colors_name') || g:colors_name != '$argv[1]'\n  colorscheme base16-$argv[1]\n  set background=$base16_fish_shell_background\nendif" >  ~/.vimrc_background
end
