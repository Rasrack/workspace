#!/usr/bin/env bash
set -euo pipefail

append_line() {
    set +o pipefail

    local update line file pat lno
    update="$1"
    line="$2"
    file="$3"
    pat="${4:-}"
    lno=""

    echo "Update $file:"
    echo "  - $line"
    if [ -f "$file" ]; then
        if [ $# -lt 3 ]; then
            lno=$(\grep -nF "$line" "$file" | sed 's/:.*//' | tr '\n' ' ')
        else
            lno=$(\grep -nF "$pat" "$file" | sed 's/:.*//' | tr '\n' ' ')
        fi
    fi
    if [ -n "$lno" ]; then
        echo "    - Already exists: line #$lno"
    else
        if [ "$update" -eq 1 ]; then
            [ -f "$file" ] && echo >> "$file"
            echo "$line" >> "$file"
            echo "    + Added"
        else
            echo "    ~ Skipped"
        fi
    fi
    echo

    set -o pipefail
}

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
THIRDPARTY="${SCRIPT_DIR}/thirdparty"

ln -s -f "${THIRDPARTY}/oh-my-tmux/.tmux.conf" "${HOME}/.tmux.conf"
ln -s -f "${SCRIPT_DIR}/tmux.config.local" "${HOME}/.tmux.conf.local"
ln -s -f "${SCRIPT_DIR}/emacs_config" "${HOME}/.emacs"
ln -s -f "${SCRIPT_DIR}/gitignore" "$HOME/.gitignore"
git config --global include.path "${SCRIPT_DIR}/gitconfig"

BASHRC_WORKSPACE="${SCRIPT_DIR}/bashrc_workspace"
append_line 1 "[ -f $BASHRC_WORKSPACE ] && source $BASHRC_WORKSPACE" "$HOME/.bashrc" "$BASHRC_WORKSPACE"
