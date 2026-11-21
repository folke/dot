# Dot File

## Secret scanning

The repository-managed pre-commit hook scans staged changes with Gitleaks and
redacts detected values. It blocks commits if Gitleaks is missing or the scan
fails. Enable it for each clone with:

```sh
just ansible --tags githooks
```

The packages role installs `gitleaks`. `.gitleaksignore` starts empty; add only
specific fingerprints after investigating false positives or revoking exposed
credentials. Run `just gitleaks` to scan history across all local refs with verbose,
redacted findings (`gitleaks git --redact --verbose --log-opts="--all"`).
Local hooks can be bypassed, so they are not a substitute for CI scanning.

![image](../.config/wall.png)

You can find my Neovim dot files [here](https://github.com/folke/dot/tree/master/nvim)

![image](https://github.com/folke/dot/assets/292349/89de8c21-1027-4aa8-8618-f3e1c5c90e1c)

![image](https://user-images.githubusercontent.com/292349/209700826-0b0a6a5e-0000-443c-a7cb-dc1504966b4f.png)
