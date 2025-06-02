# -- Bourne Again Shell Configuration --
set -o vi

# -- Environment --
export HISTSIZE=2000
export FZF_DEFAULT_OPTS="
  --color 16 \
  --color 'border:#322c27' \
  --tmux center,70% \
  --border-label ' fzf ' \
  --border \
"
export EDITOR=nvim

# My scripts
export PATH="$HOME/.local/bin:$PATH"

# -- Aliases --
alias l="ls -la"
alias d="tmux detach"

# Git
alias ga="git add"
alias gs="git status"
alias gp="git pull"
alias gP="git push"
alias gc="git checkout"
alias gd="git diff"
alias gr="git restore"
alias grs="git restore --staged"
alias gcm="git commit -m"

# Manage bare dotfiles repository from anywhere in the tree
alias dotfiles="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# -- Prompt Configuration --

RESET="\x01\e[0m\x02" 
BOLD="\x01\e[1m\x02"
LIME="\x01\e[38;2;211;255;219m\x02"
BRIGHT="\x01\e[38;2;255;255;255m\x02"
OFFWHITE="\x01\e[38;2;173;171;171m\x02"
GREEN="\x01\e[38;2;137;255;203m\x02"
RED="\x01\e[38;2;255;67;83m\x02"
BLUE="\x01\e[38;2;174;193;255m\x02"

_git_branch () {
  local branch="$(git symbolic-ref --short HEAD 2>/dev/null)"
  if [ "$branch" ]; then 
    echo -e "$OFFWHITE on $LIME${branch}$OFFWHITE$RESET" 
  fi
}

_short_pwd () {
  local pwd="$(pwd | sed "s,^$HOME,~,")" # Grab pwd, shorten $HOME to "~".
  echo -e "$BRIGHT$BOLD${pwd}$RESET" # Add bright color and bold.
}

# Return * in red or green depending on exit code of last command.
_success () {
  local sym="$([ "$exit_code" -eq 0 ] && echo "$GREEN^$RESET" || echo "$RED^$RESET")"
  echo -e "$sym"
}

#v Return indicator if in a direnv dev environment
_ifnixshell () {
  if [ "$IN_NIX_SHELL" ]; then
    echo -e "$OFFWHITE in ${BLUE}*nix$RESET"
  fi
}

# Assemble final interactive shell primary prompt.
# Must set exit_code global, which is used by prompt symbol
PROMPT_COMMAND='
  exit_code=$?
  PS1=""
  PS1+="$(_success) "
  PS1+="$(_short_pwd)"
  PS1+="$(_git_branch)"
  PS1+="$(_ifnixshell)"
  PS1+=" $ "
'

# Hook direnv into bash
eval "$(direnv hook bash)"
