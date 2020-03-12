# myconfig

Personal configuration files such as .vimrc

# Tips and tricks

* Generate strong password: `apg -a 0 -s -m 48`
* List plain [pass](https://www.passwordstore.org/)words:

  ```
  for f in `ls $HOME/.password-store`
  do
  echo -n "${f%.*} "; gpg --decrypt "$HOME/.password-store/$f" 2> /dev/null | tail -n 3
  done
  ```

# git

* The git equivalent of `hg histedit -r foo` is `git rebase --interactive foo^`
* See the history of a file: `git log --follow -p -- path-to-file`
