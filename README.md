# myconfig

Personal configuration files such as .vimrc

# neovim

Install a plugin without quitting vim:

* `:source init.vim`
* `:PlugInstall`

* Jump to coc's floating window (works if window is not split): `Ctrl-w W`
* Create new tab from current window: `Ctrl-w T`

Plugins are installed in `$HOME/.local/share/nvim/plugged/`

# haskell

- Isolated GHC installs on Ubuntu:
  https://www.haskell.org/ghcup/guide/#isolated-installs

# opam

Create installation local to directory: `opam switch create . --deps-only 4.10.0`

Then for integration with [direnv](https://direnv.net/):

``` bash
> cat .envrc
eval $(opam env)
```

# ocaml

Launch repl using the repo's libraries:

```
dune utop .
```

Silence a warning, using the `dune` file:

```
(env
  (dev
    (flags (:standard -w -32 -w -27))))
```

Generate dependencies graph:

```
dune-deps src -h tezos-client | tred > deps.dot && dot -Tpng deps.dot -o deps.png && eog deps.png
```

# Tips and tricks

* Generate strong password: `apg -a 1 -s -m 48`
* List plain [pass](https://www.passwordstore.org/)words:

  ```
  for d in lili kaiko smelc tweag
  do
    for f in `ls $HOME/$d/.password-store`
    do
    echo -n "${f%.*} "; gpg --decrypt "$HOME/.password-store/$d/$f" 2> /dev/null | tail -n 3
    done
  done
  ```
* Inspect disk space consumption: `ncdu`
* Concatenate pdfs: `java -jar pdftk-all.jar 1.pdf 2.pdf cat output 1-2.pdf`
  See also [https://doc.ubuntu-fr.org/pdftk](https://doc.ubuntu-fr.org/pdftk)
* Fix `meld`, `nautilus`, etc. slow opening: `systemctl --user restart gvfs-daemon.service`

# git

* The git equivalent of `hg histedit -r foo` is `git rebase --interactive foo^`
* See the history of a file: `git log --follow -p -- path-to-file`
* Sign commits with git:
  ```
  git config user.signingkey secret_key_id # Obtain key id with gpg --list-secret-keys --keyid-format LONG clement.hurlin@tweag.io
  git commit -S -m ...
  ```
* Make repo using `pass-git-helper`: `git config credential.helper '!pass-git-helper $@'`
* Move `myBranch` to current commit: `git branch -f myBranch`
* Move local branch so that it matches remote: `git fetch origin; git reset --hard origin/myBranch`
* Split a commit in two:

  ```
  git rebase -i commit_hash^ # record commit for edition ('e')
  git reset HEAD^
  git add ...
  git commit -m "First part"
  git add ...
  git commit -m "Second part"
  git rebase --continue
  ```
* Undo commit, keeping changes: `git reset HEAD^`
* Unstage file (hereby keeping modifications): `git reset HEAD file`
* Apply stash interactively: `git checkout -p stash@{0}`
* Sign existing: commits `git rebase --exec 'git commit --amend --no-edit -n -S' -i ...`
* Always sign commits in local repository: `git config commit.gpgsign true`
* Undo last commit (keep its changes): `git reset --soft HEAD~1` (means returns in state of `HEAD~1` keeping the changes).
* See commit content in editor:
    * `git commit --verbose`
    * `git config commit.verbose true`
* Cherry pick commits A (**included**) to B: `git cherry-pick A^..B`
* List commits from `foo` to `HEAD`: `git rev-list foo^..HEAD`
* Copy file from commit `foo` to `HEAD`: `git checkout foo src/dir/file.ml`
* Git push until commit foo: `git push <remote> <foo hash>:<branch>`
* Check if all commits of current branch satisfy some command: `git rebase -i $(gitfst.py)^ -x 'cmd'` (for Tezos, `cmd` is `./b.py --verify`)
* Unstage all files: `git reset`
* Reset all modifications, return to pristine `HEAD`: `git reset --hard`
* Track remote branch: `git checkout --track origin/copybara@monorepo-ci-copy-2`

# @polux recommendations

Skeptics' Guide to the Universe, Skeptics with a K, Sawbones, Darknet diaries, Compositional, Designer notes (interviews de designers de JV), numberphile, code poscat (c'est mort maintenent mais le back catalogue est bien), the haskell cast (mort maintenant pareil)

# GitHub

- Check workflow syntax: [actionlint](https://golangexample.com/a-static-checker-for-github-actions-workflow-files/)
- `nix run nixpkgs#gh -- pr list -s all -S 'org:kaiko-eng commenter:smelc updated:>=2022-09-12 sort:updated' --json state,number,title,url,author --jq '.[] | "[\(.state)] [#\(.number)](\(.url)) \"\(.title)\" by @\(.author.login)"'`

# #linux

- `/mode -n`

# nix

- Search for a package: `nix-env -qaP --description '.*bazel.*' | cat`
- Search in some snapshot: https://search.nixos.org/packages?channel=21.11

# Docker

- [enter docker image](https://www.freecodecamp.org/news/docker-exec-how-to-run-a-command-inside-a-docker-image-or-container/):
  ```
  docker run -it olivr/copybara:latest bash
  ```
