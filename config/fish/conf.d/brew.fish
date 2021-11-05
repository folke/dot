set -l prefix "/home/linuxbrew/.linuxbrew"

set -gx HOMEBREW_PREFIX $prefix
set -gx HOMEBREW_CELLAR $prefix/Cellar
set -gx HOMEBREW_REPOSITORY $prefix/Homebrew
set -gx HOMEBREW_SHELLENV_PREFIX $prefix

set -gx PATH $PATH $prefix/bin $prefix/sbin
