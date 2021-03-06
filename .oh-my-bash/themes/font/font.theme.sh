#!/usr/bin/env bash
#
# One line prompt showing the following configurable information
# for git:
# time (virtual_env) username@hostname pwd git_char|git_branch git_dirty_status|→
#
# The → arrow shows the exit status of the last command:
# - bold green: 0 exit status
# - bold red: non-zero exit status
#
# Example outside git repo:
# 07:45:05 user@host ~ →
#
# Example inside clean git repo:
# 07:45:05 user@host .oh-my-bash ±|master|→
#
# Example inside dirty git repo:
# 07:45:05 user@host .oh-my-bash ±|master ✗|→
#
# Example with virtual environment:
# 07:45:05 (venv) user@host ~ →
#

# All of this is unused:
# SCM_NONE_CHAR=''
# SCM_THEME_PROMPT_DIRTY="${red}*"
# SCM_THEME_PROMPT_CLEAN=""
# SCM_THEME_PROMPT_PREFIX="${green}|"
# SCM_THEME_PROMPT_SUFFIX="${green}|"
# SCM_GIT_SHOW_MINIMAL_INFO=true

CLOCK_THEME_PROMPT_PREFIX=''
CLOCK_THEME_PROMPT_SUFFIX=' '
THEME_SHOW_CLOCK=true
THEME_CLOCK_COLOR=${THEME_CLOCK_COLOR:-"$bold_blue"}
THEME_CLOCK_FORMAT=${THEME_CLOCK_FORMAT:-"%I:%M:%S"}

VIRTUALENV_THEME_PROMPT_PREFIX='('
VIRTUALENV_THEME_PROMPT_SUFFIX=') '

function prompt_command() {
    # This needs to be first to save last command return code
    local RC="$?"

    hostname="${USER}"
    which hostname &> /dev/null
    [[ "$?" == "0" ]] && hostname+="@$(hostname)"
    if [[ "$hostname" == "churlin@karak-azul" ]]; then
        # Save width
        hostname="ch@ka"
    fi
    hostname="${bold_black}${hostname}"
    virtualenv="${white}$(virtualenv_prompt)"

    here=`pwd`
    if [[ "$here" == "$HOME"* ]]; then
        current_dir="~/"$(realpath --relative-to="$HOME" "$here")
    elif [[ "$here" == "/media/crypt1/repos"* ]]; then
        current_dir="repos/"$(realpath --relative-to="/media/crypt1/repos" "$here")
    else
        current_dir="$here"
    fi
    current_dir+="${normal}"

    # Set return status color
    if [[ ${RC} == 0 ]]; then
        ret_status="${bold_green}"
        last_char=">"
    else
        ret_status="${bold_red}"
        last_char="!"
    fi

    if [ -n "$IN_NIX_SHELL" ]; then
        nix_shell=" ${bold_red}${IN_NIX_SHELL}${normal}"
    else
        nix_shell=""
    fi
    if [ -n "$DIRENV_DIR" ]; then
        direnv_marker=" ${bold_green}direnv${normal}"
    else
        direnv_marker=""
    fi

    local changeset
    if git rev-parse 2> /dev/null; then
      local -r BRANCH=$(git branch --show-current)
      if [[ -z "$BRANCH" ]]; then
        changeset+="${red}"
        changeset+="$(git rev-parse HEAD | cut -c1-8)"
      else
        changeset+="${yellow}"
        changeset+="$BRANCH"
      fi
      changeset+=" ${normal}"
    else
      # Not in a git repo
      changeset=""
    fi

    # Append new history lines to history file
    history -a

    PS1="$(clock_prompt)${virtualenv}${hostname}${direnv_marker}${nix_shell} ${bold_cyan}${current_dir} ${changeset}${ret_status}${last_char} ${normal}"
}

safe_append_prompt_command prompt_command
