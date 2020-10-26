function __fish_fnm_needs_command
  set cmd (commandline -opc)

  if [ (count $cmd) -eq 1 ]
    return 0
  end

  return 1
end

function __fish_fnm_using_command
  set cmd (commandline -opc)

  if [ (count $cmd) -gt 1 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end

  return 1
end

function __fnm_use_entries
  command fnm ls | awk '{print $2}' | sed '1d;'
end

complete -f -c fnm -n '__fish_fnm_needs_command' -l 'version' -d 'Display fnm\'s application version.'
complete -f -c fnm -n '__fish_fnm_needs_command' -l 'help' -d 'Displays fnm\'s help.'

complete -f -c fnm -n '__fish_fnm_needs_command alias' -a 'alias' -d 'Alias a version'
complete -f -c fnm -n '__fish_fnm_needs_command default' -a 'default' -d 'Alias a version as default'
complete -f -c fnm -n '__fish_fnm_needs_command env' -a 'env' -d 'Show env configurations'
complete -f -c fnm -n '__fish_fnm_needs_command install' -a 'install' -d 'Install another node version'
complete -f -c fnm -n '__fish_fnm_needs_command ls' -a 'ls' -d 'List all the installed versions'
complete -f -c fnm -n '__fish_fnm_needs_command ls-remote' -a 'ls-remote' -d 'List all the versions upstream'
complete -f -c fnm -n '__fish_fnm_needs_command uninstall' -a 'uninstall' -d 'Uninstall a node version'
complete -f -c fnm -n '__fish_fnm_needs_command use' -a 'use' -d 'Switch to another installed node version'

complete -f -c fnm -n '__fish_fnm_using_command alias' -a '--help' -d 'Displays fnm\'s help for "alias".'
complete -f -c fnm -n '__fish_fnm_using_command default' -a '--help' -d 'Displays fnm\'s help for "default".'
complete -f -c fnm -n '__fish_fnm_using_command env' -a '--help' -d 'Displays fnm\'s help for "env".'
complete -f -c fnm -n '__fish_fnm_using_command install' -a '--help' -d 'Displays fnm\'s help for "install".'
complete -f -c fnm -n '__fish_fnm_using_command ls' -a '--help' -d 'Displays fnm\'s help for "ls".'
complete -f -c fnm -n '__fish_fnm_using_command ls-remote' -a '--help' -d 'Displays fnm\'s help for "ls-remote".'
complete -f -c fnm -n '__fish_fnm_using_command uninstall' -a '--help' -d 'Displays fnm\'s help for "uninstall".'
complete -f -c fnm -n '__fish_fnm_using_command use' -a "(__fnm_use_entries)"
