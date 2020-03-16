# :sparkles: Devmoji

Using [Conventional Commits :star:](https://www.conventionalcommits.org/) as a
standard for your commit messages, makes
[Semantic Versioning :bookmark:](https://semver.org/) as easy as can be, with
tools like
[Conventional Changelog :page_facing_up:](https://github.com/conventional-changelog/conventional-changelog),
[Standard Version :bookmark:](https://github.com/conventional-changelog/standard-version)
and
[Semantic Release :package::rocket:](https://github.com/semantic-release/semantic-release)

**Devmoji** is a command line tool that adds color :rainbow: to conventional
commits, using emojis inspired by
[Gitmoji :stuck_out_tongue_winking_eye:](https://gitmoji.carloscuesta.me/)

Some of the things **Devmoji** can do:

- [**emojify:**](###devmoji-emojify) convert input between diferent emoji
  formats `unicode`, `shortcode` and `devmoji`. **devmoji** are easy to remember
  aliases like: `:test:`, `:refactor:`, `:docs:`, `:security` instead of hard to
  remember emoji codes
- [**git commit:**](###devmoji---edit) install a **`prepare-commit-msg` commit
  hook** to :sparkles: automagically emojify your commit message
- [**git log:**](###devmoji---log) emojify and colorify the output of `git log`
  even for projects not using emojis

What does it look like?

- see the commit messages of the Devmoji
  [github repository](https://github.com/folke/devmoji)
- generated Devmoji
  [CHANGELOG.md](https://github.com/folke/devmoji/blob/master/CHANGELOG.md)

## :package: Installation

Install with `npm` or `yarn`

> globally

```sh
npm install -g devmoji
yarn global install devmoji
```

> locally inside your project. use with `npx devmoji`

```shell
npm install --dev devmoji
yarn add --dev devmoji
```

See [`--edit`](###devmoji---edit) for information on how to setup a git commit
hook.

## :boom: Usage

### `devmoji --help`

```console
$ devmoji --help
Usage: devmoji [options]

Options:
  -c|--config <file>    location of the devmoji.config.js file
  -l|--list             list all known devmojis
  -t|--text <text>      text to format. reads from stdin when omitted
  -f|--format <format>  format should be one of: unicode, shortcode, devmoji (default: "unicode")
  --commit              automatically add a devmoji to the conventional commit header (default: true)
  --no-commit           do not process conventional commit headers
  -e|--edit             read last commit message from .git/COMMIT_EDITMSG in the git root
  --log                 format conventional commits in text similar to git log
  --color               use colors for formatting. Colors are enabled by default, unless output is piped to another command (default: true)
  --no-color            don't use colors
  --version             output the version number
  -h, --help            output usage information
```

### `devmoji` emojify

Emojify text using `--text` or piping it to `stdin`. Input can be a combination
using any valid format. Output formats:

| Format      | Description                                                      |
| ----------- | ---------------------------------------------------------------- |
| `shortcode` | outputs Github Markdown short codes like `:sparkles:` `:rocket:` |
| `unicode`   | outputs the emoji unicode symbols like :sparkles: :rocket:       |
| `devmoji`   | outputs the devmoji shortcodes like `:feat:` `:chore-release:`   |
| `strip`     | removes all emoji from the input                                 |

> The default format is `unicode`, since this can be used pretty much everywhere
> and has the shortest text length (relevant for commit messages)

```console
$ echo "This is a :test: of the first :release: :boom: ✨" | devmoji --format shortcode
This is a :rotating_light: of the first :rocket: :boom: :sparkles:

$ echo "This is a :test: of the first :release: :boom: :sparkles:" | devmoji --format unicode
This is a 🚨 of the first 🚀 💥 ✨

$ echo "🚀 :boom: :sparkles:" | devmoji --format devmoji
:chore-release: :breaking: :feat:

$ echo "test 🚀 :boom: :sparkles: :security:" | devmoji --format strip
test
```

### `devmoji --commit`

Automagically :sparkles: emojifies a conventional commit message of the format
`type(scope): something useful`, using the following pseudo code:

```js
if (exists(":type-scope:")) return emoji(":type-scope:")

if (exists(":type:") && exists(":scope:"))
  return emoji(":type:") + emoji(":scope:")

if (exists(":type:")) return emoji(":type:")
```

> example ouput:

```console
$ echo "feat: added a new feature :smile:" | devmoji --commit
feat: ✨ added a new feature 😄

$ echo "chore(release): 1.1.1" | devmoji --commit
chore(release): 🚀 1.1.1

$ echo "fix(security): upgraded lodash" | devmoji --commit
fix(security): 🐛 🔒 upgraded lodash
```

### `devmoji --edit`

Formats and saves your current commit message `.git/COMMIT_EDITMSG`. This is
only really useful as a `prepare-commit-msg` hook.

Configuration using [Husky](https://www.npmjs.com/package/husky)

```js
// package.json
{
  "husky": {
    "hooks": {
      "prepare-commit-msg": "devmoji -e"
    }
  }
}
```

Configuration using [Yorkie](https://www.npmjs.com/package/yorkie)

```js
// package.json
{
  "gitHooks": {
    "prepare-commit-msg": "devmoji -e"
  }
}
```

> If you installed **Devmoji** locally in your project as a dev dependency, then
> use something like `npx --no-install devmoji -e` instead of the commands
> above.

### `devmoji --log`

Works similar to `--commit`, but formats `type(scope): something useful`
anywhere in the input instead of the beginning of the first line.

This is useful to format the output of `git log`. Any `git log` option works,
but my favorite alias is:

```shell
$ git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --decorate --date=short
```

> I'll use my alias `git l`, instead of the above, for clarity. The
> `devmoji --format strip` is only for demonstration purposes, since all devmoji
> commits already have emoji
> ![devmoji --list](https://github.com/folke/devmoji/raw/master/assets/git--log.png)

> using `devmoji --log` >
> ![devmoji --list](https://github.com/folke/devmoji/raw/master/assets/devmoji--log.png)

### `devmoji --list`

To get a list of all available **Devmiji**, run with `--list`. (see also
[Default Devmoji](###Default-Devmoji))

![devmoji --list](https://github.com/folke/devmoji/raw/master/assets/devmoji--list.png)

## :gear: Configuration

`devmoji` uses the config file as specified with the `--config` option, or looks
for `devmoji.config.js` in the following paths:

- current directory
- parent directory that contains a `package.json` file
- parent directory that is a `git` repository
- home directory

### Example Config File

```js
export const defaults = {
  // extra types used in commit messages
  types: ["lint"],
  // custom devmoji
  devmoji: [
    // use :boom: instead of :sparkles: for the type 'feat'
    { code: "feat", emoji: "boom" },
    // add a custom devmoji
    {
      code: "fail",
      emoji: "poop",
      description: "something bad happened",
    },
    // add a new devmoji based on an existing gitmoji. description will be taken from the gitmoji
    {
      code: "css",
      gitmoji: "art",
    },
    // the emoji from the gitmoji can be overriden as well
    {
      code: "config",
      gitmoji: "wrench",
      emoji: "gear",
    },
  ],
}
```

### Default Devmoji Reference

| Emoji                  | Devmoji Code      | Description                                                                                                       |
| ---------------------- | ----------------- | ----------------------------------------------------------------------------------------------------------------- |
| :sparkles:             | `:feat:`          | **feat:** a new feature                                                                                           |
| :bug:                  | `:fix:`           | **fix:** a bug fix                                                                                                |
| :books:                | `:docs:`          | **docs:** documentation only changes                                                                              |
| :art:                  | `:style:`         | **style:** changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc) |
| :recycle:              | `:refactor:`      | **refactor:** a code change that neither fixes a bug nor adds a feature                                           |
| :zap:                  | `:perf:`          | **perf:** a code change that improves performance                                                                 |
| :rotating_light:       | `:test:`          | **test:** adding missing or correcting existing tests                                                             |
| :wrench:               | `:chore:`         | **chore:** changes to the build process or auxiliary tools and libraries such as documentation generation         |
| :rocket:               | `:chore-release:` | **chore(release):** code deployment or publishing to external repositories                                        |
| :link:                 | `:chore-deps:`    | **chore(deps):** add or delete dependencies                                                                       |
| :package:              | `:build:`         | **build:** changes related to build processes                                                                     |
| :construction_worker:  | `:ci:`            | **ci:** updates to the continuous integration system                                                              |
| :rocket:               | `:release:`       | code deployment or publishing to external repositories                                                            |
| :lock:                 | `:security:`      | Fixing security issues.                                                                                           |
| :globe_with_meridians: | `:i18n:`          | Internationalization and localization.                                                                            |
| :boom:                 | `:breaking:`      | Introducing breaking changes.                                                                                     |
| :gear:                 | `:config:`        | Changing configuration files.                                                                                     |
| :heavy_plus_sign:      | `:add:`           | add something                                                                                                     |
| :heavy_minus_sign:     | `:remove:`        | remove something                                                                                                  |
