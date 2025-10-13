set -l secrets_file ~/.config/fish/secrets.env

# Source secrets if available (git-crypt handles encryption/decryption automatically)
if test -f $secrets_file
    while read -l line
        # Skip empty lines and comments
        if test -n "$line"; and not string match -qr '^\s*#' -- $line
            # Export the variable
            set -l parts (string split -m 1 '=' -- $line)
            if test (count $parts) -eq 2
                set -gx $parts[1] $parts[2]
            end
        end
    end <$secrets_file
end
