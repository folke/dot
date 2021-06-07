# Setup Nix

# We need to distinguish between single-user and multi-user installs.
# This is difficult because there's no official way to do this.
# We could look for the presence of /nix/var/nix/daemon-socket/socket but this will fail if the
# daemon hasn't started yet. /nix/var/nix/daemon-socket will exist if the daemon has ever run, but
# I don't think there's any protection against accidentally running `nix-daemon` as a user.
# We also can't just look for /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh because
# older single-user installs used the default profile instead of a per-user profile.
# We can still check for it first, because all multi-user installs should have it, and so if it's
# not present that's a pretty big indicator that this is a single-user install. If it does exist,
# we still need to verify the install type. To that end we'll look for a root owner and sticky bit
# on /nix/store. Multi-user installs set both, single-user installs don't. It's certainly possible
# someone could do a single-user install as root and then manually set the sticky bit but that
# would be extremely unusual.

set -l nix_profile_path /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
set -l single_user_profile_path ~/.nix-profile/etc/profile.d/nix.sh
if test -e $nix_profile_path
  # The path exists. Double-check that this is a multi-user install.
  # We can't just check for ~/.nix-profile/… because this may be a single-user install running as
  # the wrong user.

  # stat is not portable. Splitting the output of ls -nd is reliable on most platforms.
  set -l owner (string split -n ' ' (ls -nd /nix/store 2>/dev/null))[3]
  if not test -k /nix/store -a $owner -eq 0
    # /nix/store is either not owned by root or not sticky. Assume single-user.
    set nix_profile_path $single_user_profile_path
  end
else
  # The path doesn't exist. Assume single-user
  set nix_profile_path $single_user_profile_path
end

if test -e $nix_profile_path
  # Source the nix setup script
  # We're going to run the regular Nix profile under bash and then print out a few variables
  for line in (env -u BASH_ENV bash -c '. "$0"; for name in PATH "${!NIX_@}"; do printf "%s=%s\0" "$name" "${!name}"; done' $nix_profile_path | string split0)
    set -xg (string split -m 1 = $line)
  end

  # Insert Nix's fish share directories into fish's special variables.
  # nixpkgs-installed fish tries to set these up already if NIX_PROFILES is defined, which won't
  # be the case when sourcing $__fish_data_dir/share/config.fish normally, but might be for a
  # recursive invocation. To guard against that, we'll only insert paths that don't already exit.
  # Furthermore, for the vendor_conf.d sourcing, we'll use the pre-existing presence of a path in
  # $fish_function_path to determine whether we want to source the relevant vendor_conf.d folder.

  # To start, let's locally define NIX_PROFILES if it doesn't already exist.
  set -al NIX_PROFILES
  if test (count $NIX_PROFILES) -eq 0
    set -a NIX_PROFILES $HOME/.nix-profile
  end
  # Replicate the logic from nixpkgs version of $__fish_data_dir/__fish_build_paths.fish.
  set -l __nix_profile_paths (string split ' ' -- $NIX_PROFILES)[-1..1]
  set -l __extra_completionsdir \
    $__nix_profile_paths/etc/fish/completions \
    $__nix_profile_paths/share/fish/vendor_completions.d
  set -l __extra_functionsdir \
    $__nix_profile_paths/etc/fish/functions \
    $__nix_profile_paths/share/fish/vendor_functions.d
  set -l __extra_confdir \
    $__nix_profile_paths/etc/fish/conf.d \
    $__nix_profile_paths/share/fish/vendor_conf.d \

  ### Configure fish_function_path ###
  # Remove any of our extra paths that may already exist.
  # Record the equivalent __extra_confdir path for any function path that exists.
  set -l existing_conf_paths
  for path in $__extra_functionsdir
    if set -l idx (contains --index -- $path $fish_function_path)
      set -e fish_function_path[$idx]
      set -a existing_conf_paths $__extra_confdir[(contains --index -- $path $__extra_functionsdir)]
    end
  end
  # Insert the paths before $__fish_data_dir.
  if set -l idx (contains --index -- $__fish_data_dir/functions $fish_function_path)
    # Fish has no way to simply insert into the middle of an array.
    set -l new_path $fish_function_path[1..$idx]
    set -e new_path[$idx]
    set -a new_path $__extra_functionsdir
    set fish_function_path $new_path $fish_function_path[$idx..-1]
  else
    set -a fish_function_path $__extra_functionsdir
  end

  ### Configure fish_complete_path ###
  # Remove any of our extra paths that may already exist.
  for path in $__extra_completionsdir
    if set -l idx (contains --index -- $path $fish_complete_path)
      set -e fish_complete_path[$idx]
    end
  end
  # Insert the paths before $__fish_data_dir.
  if set -l idx (contains --index -- $__fish_data_dir/completions $fish_complete_path)
    set -l new_path $fish_complete_path[1..$idx]
    set -e new_path[$idx]
    set -a new_path $__extra_completionsdir
    set fish_complete_path $new_path $fish_complete_path[$idx..-1]
  else
    set -a fish_complete_path $__extra_completionsdir
  end

  ### Source conf directories ###
  # The built-in directories were already sourced during shell initialization.
  # Any __extra_confdir that came from $__fish_data_dir/__fish_build_paths.fish was also sourced.
  # As explained above, we're using the presence of pre-existing paths in $fish_function_path as a
  # signal that the corresponding conf dir has also already been sourced.
  # In order to simulate this, we'll run through the same algorithm as found in
  # $__fish_data_dir/config.fish except we'll avoid sourcing the file if it comes from an
  # already-sourced location.
  # Caveats:
  # * Files will be sourced in a different order than we'd ideally do (because we're coming in
  #   after the fact to source them).
  # * If there are existing extra conf paths, files in them may have been sourced that should have
  #   been suppressed by paths we're inserting in front.
  # * Similarly any files in $__fish_data_dir/vendor_conf.d that should have been suppressed won't
  #   have been.
  set -l sourcelist
  for file in $__fish_config_dir/conf.d/*.fish $__fish_sysconf_dir/conf.d/*.fish
    # We know these paths were sourced already. Just record them.
    set -l basename (string replace -r '^.*/' '' -- $file)
    contains -- $basename $sourcelist
    or set -a sourcelist $basename
  end
  for root in $__extra_confdir
    for file in $root/*.fish
      set -l basename (string replace -r '^.*/' '' -- $file)
      contains -- $basename $sourcelist
      and continue
      set -a sourcelist $basename
      contains -- $root $existing_conf_paths
      and continue # this is a pre-existing path, it will have been sourced already
      [ -f $file -a -r $file ]
      and source $file
    end
  end
end
