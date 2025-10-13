function dotenv -d "Source environment variables from a file or .env in current directory" -a file
    set -l env_file

    if test -z "$file"
        # No argument, use .env in current directory
        set env_file .env
    else
        # Use provided file path
        set env_file $file
    end

    # Check if file exists
    if not test -f $env_file
        set_color red
        echo -n "[dotenv] "
        set_color normal
        echo "$env_file not found" >&2
        return 1
    end

    # Source the file
    while read -l line
        # Skip empty lines and comments
        if test -n "$line"; and not string match -qr '^\s*#' -- $line
            # Export the variable
            set -l parts (string split -m 1 '=' -- $line)
            if test (count $parts) -eq 2
                set -gx $parts[1] $parts[2]
            end
        end
    end <$env_file
end
