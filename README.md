# myconfig

Personal configuration files such as .vimrc

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

# Tips and tricks

* Generate strong password: `apg -a 1 -s -m 48`
* List plain [pass](https://www.passwordstore.org/)words:

  ```
  for f in `ls $HOME/.password-store`
  do
  echo -n "${f%.*} "; gpg --decrypt "$HOME/.password-store/$f" 2> /dev/null | tail -n 3
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
* Git push until commit foo: `git push <remote> <foo hash>:<branch>
