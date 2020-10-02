set -l _pisces_bind_mode default
switch $fish_key_bindings
    case 'fish_vi_key_bindings' 'fish_hybrid_key_bindings'
        set _pisces_bind_mode insert
end

set -q pisces_pairs
or set -U pisces_pairs '(,)' '[,]' '{,}' '","' "','"

for pair in $pisces_pairs
    _pisces_bind_pair $_pisces_bind_mode (string split -- ',' $pair)
end

# normal backspace, also known as \010 or ^H:
bind -M $_pisces_bind_mode \b _pisces_backspace
# Terminal.app sends DEL code on ⌫:
bind -M $_pisces_bind_mode \177 _pisces_backspace

# overrides TAB to provide completion of vars before a closing '"'
bind -M $_pisces_bind_mode \t _pisces_complete
