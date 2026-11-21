# nerd-fonts: https://www.nerdfonts.com/cheat-sheet
# function fish_title
#     # emacs is basically the only term that can't handle it.
#     set -l cmd (status current-command)
#     switch $cmd
#         case fish
#             set cmd " "
#         case nvim vim
#             set cmd " "
#         case gh
#             set cmd " "
#         case lazygit git
#             set cmd " "
#         case topgrade
#             set cmd " "
#         case htop btop
#             set cmd "󰄧 "
#         case curl wget
#             set cmd " "
#         case cargo
#             set cmd " "
#         case docker docker-compose lazydocker
#             set cmd " "
#         case make
#             set cmd " "
#         case node
#             set cmd " "
#         case pacman paru
#             set cmd "󰮯 "
#     end
#     echo "$cmd   $(prompt_pwd)"
# end

# emoji: https://emojicombos.com/
function fish_title
    # emacs is basically the only term that can't handle it.
    set -l cmd (status current-command)
    switch $cmd
        case fish
            set cmd "🐟 "
        case nvim vim
            set cmd "📝 "
        case gh
            set cmd "🐙 "
        case git lazygit
            set cmd "🌿 "
        case topgrade
            set cmd "🔄 "
        case htop btop
            set cmd "📊 "
        case curl wget
            set cmd "🌐 "
        case cargo
            set cmd "📦 "
        case docker docker-compose lazydocker
            set cmd "🐳 "
        case make
            set cmd "🛠️ "
        case node
            set cmd "🌲 "
        case pacman yay
            set cmd "📦 "
    end
    echo "$cmd   $(prompt_pwd)"
end
