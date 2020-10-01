# Managing dotfiles with [dotdrop](https://github.com/deadc0de6/dotdrop)

```shell
# Install all dotfiles
$ dotdrop install

# Check for unmanaged stuff
$ dotdrop compare

# Start managing some file in `~`
$ mv .somefile ~/projects/dot/home

# Start managing a directory in `~/.config`
$ mv ~/.config/foo ~/projects/dot/config/

```

# Restoring dotfiles

```shell
# Install dotdrop
$ pip3 install --user dotdrop

# Clone dotfiles
$ cd ~/projects
$ git clone git@github.com:folke/dot.git

# Install dotfiles
$ dotdrop -c ~/projects/dot/dotdrop.yaml

# Install Homebrew packages
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
$ brew bundle
```
