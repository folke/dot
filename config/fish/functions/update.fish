# Defined in /Users/folke/.config/fish/config.fish @ line 71
function update --description 'Update homebrew, fish, pnpm'
    and echo "[update] Homebrew"
    and brew update
    and brew upgrade

    and echo "[update] cleaning brew cache"
    and rm -rfv (brew --cache) # brew cleanup -s doesn't remove everythin
    and brew bundle dump --describe --force --global

    and echo "[update] Doom Emacs"
    and doom upgrade

    and echo "[update] nodejs"
    and pnpm update -g

    and echo "[update] python"
    and pip3 list -o --user --format=freeze | sed "s/==.*//" | xargs pip3 install -U --user

    and echo "[update] tldr"
    and tldr -u

    and echo "[update] fish"
    and fisher self-update
    and fisher
    and fish_update_completions
    and zoxide init fish >~/.config/fish/functions/z.fish
    and starship init fish --print-full-init >~/.config/fish/functions/fish_prompt.fish
end
