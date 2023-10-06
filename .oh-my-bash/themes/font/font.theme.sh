#! bash oh-my-bash.module
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

SCM_NONE_CHAR=''
SCM_THEME_PROMPT_DIRTY=" ${_omb_prompt_brown}✗"
SCM_THEME_PROMPT_CLEAN=""
SCM_THEME_PROMPT_PREFIX="${_omb_prompt_green}|"
SCM_THEME_PROMPT_SUFFIX="${_omb_prompt_green}|"
SCM_GIT_SHOW_MINIMAL_INFO=true

CLOCK_THEME_PROMPT_PREFIX=''
CLOCK_THEME_PROMPT_SUFFIX=' '
THEME_SHOW_CLOCK=${THEME_SHOW_CLOCK:-"true"}
THEME_CLOCK_COLOR=${THEME_CLOCK_COLOR:-"$_omb_prompt_bold_navy"}
THEME_CLOCK_FORMAT=${THEME_CLOCK_FORMAT:-"%I:%M:%S"}

VIRTUALENV_THEME_PROMPT_PREFIX='('
VIRTUALENV_THEME_PROMPT_SUFFIX=') '

function _omb_theme_PROMPT_COMMAND() {
    # This needs to be first to save last command return code
    local RC="$?"

    if [[ "$USER" == "churlin" && "$HOSTNAME" == "karak-azul" ]]
    then
      local hostname=""
    else
      local hostname="${_omb_prompt_bold_gray}\u@\h "
    fi
    local python_venv; _omb_prompt_get_python_venv
    python_venv=$_omb_prompt_white$python_venv

    # Set return status color
    if [[ ${RC} == 0 ]]; then
        ret_status="${_omb_prompt_bold_green}"
    else
        ret_status="${_omb_prompt_bold_brown}"
    fi

    git rev-parse --show-toplevel &> /dev/null
    if [[ "$?" == "0" ]]
    then
      # In a git repo
      CURRENT_BRANCH=$(git branch --show-current 2> /dev/null)
      scm_prompt_char_info=" ${_omb_prompt_green}|$CURRENT_BRANCH${_omb_prompt_green}|"
      local omb_location="$(realpath --relative-to="$(git root)/.." $(pwd))"
    else
      scm_prompt_char_info=""
      omb_location="$(pwd)"
      if [[ "$omb_location" == "$HOME" ]]
      then
        omb_location="HOME"
      elif [[ "$omb_location" == "$HOME"* ]]
      then
        omb_location="HOME/$(realpath --relative-to=$HOME $(pwd))"
      fi
    fi

    if [[ -n "$DIRENV_DIR" ]]
    then
      direnv="${_omb_prompt_bold_purple}direnv${normal} "
    else
      direnv=""
    fi

    if [[ -n "$IN_NIX_SHELL" ]]
    then
      nix_shell="${bold_red}${IN_NIX_SHELL}${normal} "
    else
      nix_shell=""
    fi

    # Append new history lines to history file
    history -a

    PS1="$(clock_prompt)$direnv$nix_shell$python_venv${hostname}${_omb_prompt_bold_teal}${omb_location}$scm_prompt_char_info${ret_status} → ${_omb_prompt_normal}"
}

_omb_util_add_prompt_command _omb_theme_PROMPT_COMMAND
