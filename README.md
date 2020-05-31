# Managing Dot Files with Git

Create a `.dotfiles` folder, which we'll use to track your dotfiles

```bash
git init --bare $HOME/.dotfiles
```

Create a `dot` alias that uses `.dot` as the git repository and your `$HOME` as the working directory.
Make sure to add it to your `.bashrc` or `.zshrc`

```bash
alias dot='git --git-dir=$HOME/.dot --work-tree=$HOME'
```

You can now use `dot` to manage any file in your home directory.

## Restoring Dot Files

Add `.dot` to `.gitignore` to prevent weird recursion issues.

```bash
echo ".dot" >> .gitignore
```

Clone your dotfiles in a bare git repository.

```shell
git clone --bare git@github.com:folke/dot.git $HOME/.dot
```

Define the alias

```bash
alias dot='git --git-dir=$HOME/.dot --work-tree=$HOME'
```

Checkout your dotfiles!

```bash
dot checkout
```

If you get errors about existing files, back them up first and retry

```bash
mkdir -p .dot-backup && \
dot checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .dot-backup/{}
```
