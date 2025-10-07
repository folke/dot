function _pnpm-shell-completion_install --on-event pnpm-shell-completion_install
    set OS (uname -s)
    set arch (uname -m)
    if test $OS = "Darwin"
        if test $arch = "arm64"
            set target "aarch64-apple-darwin"
        else
            set target "x86_64-apple-darwin"
        end
    else
        set target "x86_64-unknown-linux-musl"
    end

    echo "Downloading `pnpm-shell-completion` binary…"
    set release_url "https://github.com/g-plane/pnpm-shell-completion/releases/latest/download/pnpm-shell-completion_$target.zip"
    curl -sL $release_url -o release.zip

    unzip -o release.zip pnpm-shell-completion -d $HOME/.local/bin

    mkdir -p $__fish_config_dir/completions/
    unzip -o release.zip pnpm.fish -d $__fish_config_dir/completions/

    rm release.zip
end
