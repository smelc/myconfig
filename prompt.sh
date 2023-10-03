# This needs to be first to save the last command return code
previous_rc="$?"

current_branch="$(git branch --show-current 2> /dev/null)"
if [[ "$?" == "0" ]]
then
  in_git_repo="true"
  current_branch="$(git branch --show-current)"
else
  in_git_repo="false"
fi

PS1=""
here=$(pwd)

# Colors
color_bold_cyan="\e[1;36m"
color_cyan="\e[36m"
color_light_blue="\e[94m"
color_bold_blue="\e[1;34m"
color_bold_green="\e[1;32m"
color_green="\e[32m"
color_red="\e[31m"
color_end="\e[0m"

# Reset prompt
PS1=""

#####################
### Add timestamp ###
#####################

PS1+="$color_light_blue"
PS1+="$(date "+%H:%M:%S")"
PS1+="$color_end "

#######################
### Print working dir #
#######################

if [[ "$in_git_repo" == "true" ]]
then
  PS1+="$color_bold_cyan"
  PS1+="$(realpath --relative-to="$(git root)/.." $(pwd))"
  PS1+="$color_end "
  PS1+="$color_green$current_branch$color_end"
else
  PS1+="$color_bold_cyan"
  case "$here" in
    "$HOME")
      PS1+="HOME"
      ;;
    "$HOME"*)
      PS1+="HOME/$(realpath --relative-to=$HOME $here)"
      ;;
    *)
      PS1+="$here"
      ;;
  esac
  PS1+="$color_end"
fi

##################
### Add suffix ###
##################

if [[ "$previous_rc" == "0" ]]
then
  PS1+="$color_bold_green"
else
  PS1+="$color_red"
fi
PS1+=" > "
PS1+="$color_end"
