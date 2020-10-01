function __fish_describe_command --description 'Command used to find descriptions for commands'
    # $argv will be inserted directly into the awk regex, so it must be escaped
    set -l argv_regex (string escape --style=regex "$argv")
    __fish_apropos $argv 2>/dev/null | awk -v FS=" +- +" '{
split($1, names, ", ");
for (name in names)
if (names[name] ~ /^'"$argv_regex"'.* *\([18]\)/ ) {
sub( "( |\t)*\\\([18]\\\)", "", names[name] );
sub( " \\\[.*\\\]", "", names[name] );
print names[name] "\t" $2;
}
}'
end
