#!/usr/bin/env bash
set -euo pipefail

export FZF_CTRL_T_COMMAND='fd --type f --follow --hidden --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"

_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    *)            fzf "$@" ;;
  esac
}

_fzf_git_wstashes() {
  _fzf_git_check || return
  git stash list | _fzf_git_fzf \
    --prompt '🥡 Stashes> ' \
    --header $'CTRL-X (drop stash)\n\n' \
    --bind 'ctrl-x:execute-silent(git stash drop {1})+reload(git stash list)' \
    -d: --preview 'git show --color=always {1}' "$@" |
  cut -d: -f1
}

_fzf_git_vreflog() {
  _fzf_git_check || return
  git reflog show | _fzf_git_fzf \
    --prompt '🥢 Reflog> ' \
    --header $'CTRL-D (diff)\n\n' \
    -d " " --preview 'git diff --color=always {1}' "$@" |
  cut -d " " -f1
}

__fzf_git_init vreflog wstashes

set +euo pipefail
