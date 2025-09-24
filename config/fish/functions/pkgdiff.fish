function pkgdiff -a file
    test -f $file; or begin
        echo "File not found"
        return 1
    end

    set pkg (pacman -Qo $file | awk '{print $5}')
    test -n "$pkg"; or begin
        echo "No owning package"
        return 1
    end

    # ensure package in cache
    sudo pacman -Sw --noconfirm $pkg >/dev/null

    # latest cached pkg archive
    set cache (command ls -t /var/cache/pacman/pkg/$pkg-*.pkg.tar.zst | head -1)
    set rel (string replace -r '^/' '' -- $file)

    # extract packaged version to a temp file
    set pkg_tmp (mktemp)
    if not bsdtar -xOf "$cache" "$rel" >"$pkg_tmp" 2>/dev/null
        echo "Not found in package: $rel"
        rm -f "$pkg_tmp"
        return 1
    end

    nvim -d "$file" "$pkg_tmp"

    # cleanup
    rm -f "$pkg_tmp"
end
